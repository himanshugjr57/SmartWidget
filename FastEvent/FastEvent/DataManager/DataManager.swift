//
//  DataManager.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import UIKit
import SwiftUI
import SwiftData
import Foundation
import WidgetKit
import TipKit
/// Main data manager for the app
class DataManager:NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var eventsArr: [EventModel] = [EventModel]()
    @Published var fullScreenMode: FullScreenMode?
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("createdWidgetsCount") var createdWidgetsCount: Int = 0
    @AppStorage("didSaveDefaultEvents") var didSaveDefaultEvents: Bool = false
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("selectedWidgetId", store: AppConfig.userDefaults) var selectedWidgetId: String = ""
    @AppStorage(AppConfig.premiumVersion, store: AppConfig.userDefaults) var isPremiumUser: Bool = false
        
    /// SwiftData model container
    private var container: ModelContainer?
    
    /// Default initializer
    init(preview: Bool = true) {
        super.init()
        do {
            let groupContainer = ModelConfiguration.GroupContainer.identifier(AppConfig.appGroup)
            let configuration = ModelConfiguration(groupContainer: groupContainer)
            let container = try ModelContainer(for: EventModel.self, configurations: configuration)
            self.container = container
            
            do {
                Task {
                    @MainActor in getAllObjects()
                }
            }
        } catch {
            fatalError("Failed to create a container")
        }
    }
    
    @MainActor func getAllObjects(){
        if !didSaveDefaultEvents {
            Holiday.allCases.forEach { event in
                if getObject(id: event.model.id) != nil{
                    
                }else{
                    container!.mainContext.insert(event.model)
                }
            }
            self.eventsArr = Holiday.allCases.map { $0.model }
            didSaveDefaultEvents = true
        }
        
        do {
            // We have chosen to order it by "date" - the creation date - so that the UICollectionView maintains its order as we update the items.
            let data = try self.container!.mainContext.fetch(FetchDescriptor<EventModel>())
            debugPrint("getAllObjects : \(data) \(data.count)")
            self.eventsArr = data
            self.eventsArr = eventsArr.sorted(by: { $0.dateCreated > $1.dateCreated })
        } catch {
            debugPrint("getAllObjects : data is nil")
            self.eventsArr = []
        }
    }
    
    @MainActor func saveEvent(withData data: [EventDataType: String], isWidgetShared: Bool = false) {
        var eventData = data
        eventData[.dateCreated] = Date().string
        print("Save Param", eventData)
        let widget_id = UUID().uuidString
        let event: EventModel = EventModel(id: widget_id,data: eventData)
        event.isWidgetShared = isWidgetShared
        container!.mainContext.insert(event)
        
        if isWidgetShared{
            self.selectedWidgetId = widget_id
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        
        
        //        NotificationCenter.default.post(name: NSNotification.Name("ReloadEventData"),object: nil, userInfo: nil)
        self.getAllObjects()
        
        print("------ enter on notification center ---------")
        
    }
    
    func getSelectedWidget(withId widgetId: String) -> EventModel? {
        if widgetId == selectedWidgetId {
            return self.eventsArr.first { $0.id == widgetId }
        }
        return nil
    }
    
    /// Load saved widget events
//    @MainActor func loadSavedEvents(completion: ((_ data: [EventModel]) -> Void)? = nil) {
//        
//        self.getAllObjects()
//        completion?(self.eventsArr)
//    }
    
    @MainActor func getObject(id: String) -> EventModel? {
        do {
            let predicate = #Predicate<EventModel> { object in
                if id.count > 0{
                    object.id == id
                }else{
                    object.isWidgetShared == true
                }
            }
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1
            let object = try self.container!.mainContext.fetch(descriptor)
            debugPrint("getObject : \(object)")
            return object.first
        } catch {
            debugPrint("getObject : \(error)")
            return nil
        }
    }
    
    @MainActor func updateEventData(withData data: [EventDataType: String], widgetID: String, isWidgetShared: Bool = false) {
        if let object = getObject(id: widgetID) {
            print("Update Data on Uuid")
            self.container!.mainContext.delete(object)
            self.saveEvent(withData: data, isWidgetShared: isWidgetShared)
        } else {
            print("saveData with new uuid")
            self.saveEvent(withData: data, isWidgetShared: isWidgetShared)
        }
    }
    
    
    
#if !(WIDGET)
    /// Delete a widget for a given identifier
    /// - Parameter id: widget data model identifier
    @MainActor func deleteWidget(withId id: String) {
        if selectedWidgetId == id {
            presentAlert(title: "Oops!", message: "You cannot delete this widget. Select another one as primary, then delete this one.", primaryAction: .OK)
        } else {
            var events = FetchDescriptor<EventModel>()
            events.predicate = #Predicate { $0.id == id }
            if let matchingResult = try? self.container!.mainContext.fetch(events).first {
                self.container!.mainContext.delete(matchingResult)
                try? self.container!.mainContext.save()
                self.getAllObjects()
            }
        }
    }
#endif
}


/// Convert color to string
extension Color {
    var string: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return "\(red)_\(green)_\(blue)_\(alpha)"
    }
}



/// Convert date to string
extension Date {
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var shortFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var shortTimeFormat: String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "MM/dd/yyyy"
        //        dateFormatter.locale = Locale(identifier: "en_US")
        //        return dateFormatter.string(from: self)
        
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            //phone is set to 12 hours
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: self)
        }
    }
    
    static func create(_ text: [String], index: Int = 0) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let textDate = text[safe: index], let date = dateFormatter.date(from: textDate) {
            var finalDate = date
            while Date() > finalDate {
                finalDate = create(text, index: index + 1)
            }
            return finalDate
        } else {
            return Date()
        }
    }
    
    static var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    }
}

/// Convert string to date/color
extension String {
    func toDate(dateFormate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormate
        guard let date = dateFormatter.date(from:self) else { return Date() }
        return date
    }

    func extractUsernameFromEmail() -> String? {
        if let atIndex = self.firstIndex(of: "@") {
            return String(self.prefix(upTo: atIndex))
        }
        return nil
    }

    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let dt = dateFormatter.date(from: self){            
            return dateFormatter.date(from: self)
        }else{
            return dateFormatter.date(from: self)
        }
    }
    
    func convertStringToDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self)
    }
    
    var time: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self)
    }
    
    var color: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        components(separatedBy: "_").enumerated().forEach { index, value in
            switch index {
            case 0: red = CGFloat(Double(value) ?? 0)
            case 1: green = CGFloat(Double(value) ?? 0)
            case 2: blue = CGFloat(Double(value) ?? 0)
            case 3: alpha = CGFloat(Double(value) ?? 0)
            default: break
            }
        }
        return Color(uiColor: UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    //    func dateFromString(formate: String = "MM/dd/yyyy") -> Date {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = formate
    //        return dateFormatter.date(from: self) ?? Date()
    //    }
    
    func convertDateFormat(formate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = formate
        
        let oldDate = olDateFormatter.date(from: self)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let oldDate = oldDate {
            return convertDateFormatter.string(from: oldDate)
        } else {
            return convertDateFormatter.string(from: Date())
        }
    }
}

/// Get the time difference between 2 dates
extension Date {
    var timeDifference: [Calendar.Component: Int] {
        let components: Set<Calendar.Component> = [.month, .day, .hour, .minute]
        let difference: DateComponents = Calendar.current.dateComponents(components, from: Date(), to: self)
        var result: [Calendar.Component: Int] = [:]
        components.forEach { component in
            if let value = difference.value(for: component), value != 0 {
                result[component] = value
            }
        }
        return result
    }
}

#if !(WIDGET)
/// Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction? = nil, secondaryAction: UIAlertAction? = nil, tertiaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let primary = primaryAction { alert.addAction(primary) }
        if let secondary = secondaryAction { alert.addAction(secondary) }
        if let tertiary = tertiaryAction { alert.addAction(tertiary) }
        rootController?.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    static var Cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    static var OK: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}
#endif

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

public extension Binding where Value: Equatable {
    
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}

extension Date {
    func reduceDayFromGiveDate(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }

    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
                              time timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current,
                              using calendar: Calendar = .current) -> String {
        Formatter.date.calendar = calendar
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }

    var fullDate: String { localizedDescription(date: .full, time: .none) }
    var longDate: String { localizedDescription(date: .long, time: .none) }
    var mediumDate: String { localizedDescription(date: .medium, time: .none) }
    var shortDate: String { localizedDescription(date: .short, time: .none) }

    var fullTime: String { localizedDescription(date: .none, time: .full) }
    var longTime: String { localizedDescription(date: .none, time: .long) }
    var mediumTime: String { localizedDescription(date: .none, time: .medium) }
    var shortTime: String { localizedDescription(date: .none, time: .short) }

    var fullDateTime: String { localizedDescription(date: .full, time: .full) }
    var longDateTime: String { localizedDescription(date: .long, time: .long) }
    var mediumDateTime: String { localizedDescription(date: .medium, time: .medium) }
    var shortDateTime: String { localizedDescription(date: .short, time: .short) }
    
    static func /(recent: Date, previous: Date) -> (day: Int?, month: Int?) {// (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
//        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
//        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
//        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (day: day, month: month)// (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    func toStringS(dateFormat format: String = "h:mm:ss dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Formatter {
    static let date = DateFormatter()
}
