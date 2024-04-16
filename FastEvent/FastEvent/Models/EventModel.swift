//
//  EventModel.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import SwiftData
import Foundation

/// Event data type/key for the model
enum EventDataType: String, Codable, CaseIterable {
    case title, icon, date, time
    case backgroundColorStart, backgroundColorEnd // Updated enum cases
    case fontColor, layoutStyle, dateCreated, location
}

/// A model for the event
@Model
class EventModel: Identifiable {

//    @Attribute(.unique) let id: String
    let id: String = UUID().uuidString
    var data: [EventDataType: String]
    var isWidgetShared: Bool = false

    /// Create the event model with id and data
    /// - Parameters:
    ///   - id: event identifier
    ///   - data: data for the event
    init(id: String = UUID().uuidString,data: [EventDataType : String]) {
        self.id = id
        self.data = data
    }

    var dateCreated: Date {
        data[.dateCreated]?.convertStringToDate() ?? .yesterday
    }

    var title: String {
        data[.title] ?? "Event Title"
    }

    var iconName: String {
        data[.icon] ?? "date"
    }

    var fontColor: Color {
        data[.fontColor]?.color ?? .white
    }

    var eventDate: String {
        
        data[.date] ?? Date().shortFormat
    }
    
    var eventTime: String {
        data[.time] ?? Date().shortTimeFormat
    }

    var location: WidgetLocation {
        WidgetLocation(rawValue: data[.location] ?? "" ) ?? .light
    }

    // Updated computed property to directly return colors
    var backgroundColorStart: Color {
        data[.backgroundColorStart]?.color ?? .white
    }

    var backgroundColorEnd: Color {
        data[.backgroundColorEnd]?.color ?? .black
    }
    
    /*
     var gradient: LinearGradient {
         LinearGradient(colors: [
             data[.backgroundStartColor]?.color ?? .white,
             data[.backgroundEndColor]?.color ?? .white
         ], startPoint: .top, endPoint: .bottom)
     }
    */

    var widgetStyle: WidgetLayoutType {
        WidgetLayoutType(rawValue: data[.layoutStyle] ?? "") ?? .basic
    }

    var iconSize: Double {
        switch widgetStyle {
        case .basic: return 20.0
        case .styleOne: return 10.0
        case .styleTwo: return 20.0
        case .styleThree: return 40.0
        case .styleFour: return 12.0
        case .styleFive: return 15.0
        case .styleSix: return 15.0
        case .styleSeventh: return 15.0
        case .styleEighth: return 15.0
        case .styleNinth: return 30
        case .styleTenth: return 15.0
        case .styleEleventh: return 15.0
        case .styleTwelveth: return 15.0
        case .styleThirteen: return 15.0
        case .styleFourteen: return 15.0
        }
    }

    var totalSecondsLeft: TimeInterval {
        guard let eventDate = exactEventDate else { return 0 }
        return eventDate.timeIntervalSince(.now)
    }

    var exactEventDate: Date? {
        
        var DateStr = String()
        var timeStr = String()
        
        if self.eventDate.count > "MM/dd/yyyy".count{
            print("Different Time Fromate", self.eventDate)
        }else{
            DateStr = self.eventDate.convertDateFormat(formate: "MM/dd/yyyy")
        }
        
        if self.eventTime.count > 5{
            timeStr = self.eventTime.convertDateFormat(formate: "hh:mm a")
        }else{
            timeStr = self.eventTime.convertDateFormat(formate: "HH:mm")
        }
        var tempDt = Date()
        guard let date = DateStr.date, let time = timeStr.time else { return nil }
        tempDt = date
        if date < Date() {
            print(" My \(date) is less than currentDate \(Date())")
            var dateComponent = DateComponents()
            dateComponent.year = 1
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            print("futureData", futureDate)
            tempDt = futureDate!
            data[.date] = futureDate?.shortFormat
        }
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: tempDt)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        return Calendar.current.date(from: dateComponents) ?? nil
    }

    func exactTimeLeft(_ component: Calendar.Component) -> Int {
        guard let eventDate = exactEventDate else { return 0 }
        
        if eventDate.timeDifference[component] ?? 0 <= 0{
            return 0
        }
        
        return eventDate.timeDifference[component] ?? 0
    }

    func timeLeft(_ component: Calendar.Component) -> Int {
        
//        print("EventDate", self.eventDate.convertDateFormat("MM/dd/yyyy"))
//        if self.eventTime.count > 5{
//            print("EventDateTime", self.eventTime.convertDateFormat(formate: "hh:mm a"))
//        }else{
//            print("EventDateTime", self.eventTime.convertDateFormat(formate: "HH:mm"))
//        }
        
        guard let eventDate = exactEventDate else { return 0 }
        switch component {
        case .month:
            
//            if Calendar.current.dateComponents([component], from: .now, to: eventDate).month ?? 0 <= 0{
//                return 0
//            }
            
            return Calendar.current.dateComponents([component], from: .now, to: eventDate).month ?? 0
        case .day:
            
//            if Calendar.current.dateComponents([component], from: .now, to: eventDate).day ?? 0 <= 0{
//                return 0
//            }
            
            return Calendar.current.dateComponents([component], from: .now, to: eventDate).day ?? 0
        case .hour:
            
//            if Calendar.current.dateComponents([component], from: .now, to: eventDate).hour ?? 0 <= 0{
//                return 0
//            }
            
            return Calendar.current.dateComponents([component], from: .now, to: eventDate).hour ?? 0
        case .minute:
            
//            if Calendar.current.dateComponents([component], from: .now, to: eventDate).minute ?? 0 <= 0{
//                return 0
//            }
            
            return Calendar.current.dateComponents([component], from: .now, to: eventDate).minute ?? 0
        default: return 0
        }
    }

    func font(for dataType: EventDataType) -> Font {
        switch dataType {
        case .title:
            switch widgetStyle {
            case .basic:
                return .system(size: 20, weight: .medium, design: .none)
            case .styleOne:
                return .system(size: 12, weight: .regular, design: .rounded)
            case .styleTwo:
                return .system(size: 15, weight: .medium, design: .none)
            case .styleThree:
                return .system(size: 20, weight: .semibold, design: .rounded)
            case .styleFour:
                return .system(size: 12, weight: .regular, design: .none)
            case .styleFive:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleSix:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleSeventh:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleEighth:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleNinth:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleTenth:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleEleventh:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleTwelveth:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleThirteen:
                return .system(size: 14, weight: .regular, design: .none)
            case .styleFourteen:
                return .system(size: 14, weight: .regular, design: .none)
            }
        case .date:
            switch widgetStyle {
            case .basic:
                return .system(size: 30, weight: .bold, design: .rounded)
            case .styleOne:
                return .system(size: 25, weight: .semibold, design: .rounded)
            case .styleTwo:
                return .system(size: 28, weight: .semibold, design: .rounded)
            case .styleThree:
                return .system(size: 17, weight: .semibold, design: .rounded)
            case .styleFour:
                return .system(size: 28, weight: .semibold, design: .rounded)
            case .styleFive:
                return .system(size: 70, weight: .black, design: .rounded)
            case .styleSix:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleSeventh:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleEighth:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleNinth:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleTenth:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleEleventh:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleTwelveth:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleThirteen:
                return .system(size: 28, weight: .black, design: .rounded)
            case .styleFourteen:
                return .system(size: 15, weight: .black, design: .rounded)
            }
        case .time:
            switch widgetStyle {
            case .basic:
                return .system(size: 20, weight: .medium, design: .none)
            case .styleOne:
                return .system(size: 15, weight: .regular, design: .none)
            case .styleTwo:
                return .system(size: 25, weight: .medium, design: .rounded)
            case .styleThree:
                return .system(size: 10, weight: .regular, design: .rounded)
            case .styleFour:
                return .system(size: 22, weight: .light, design: .none)
            case .styleFive:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleSix:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleSeventh:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleEighth:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleNinth:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleTenth:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleEleventh:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleTwelveth:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleThirteen:
                return .system(size: 10, weight: .regular, design: .none)
            case .styleFourteen:
                return .system(size: 10, weight: .regular, design: .none)
            }
        default: return .system(size: 0.0)
        }
    }
    
    func getSmallWidgetSize() -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let height = screenBounds.height
        switch height {
        case 926:
            return CGSize(width: 170, height: 170)
        case 896:
            return CGSize(width: 169, height: 169)
        case 812:
            return CGSize(width: 155, height: 155)
        case 736:
            return CGSize(width: 159, height: 159)
        case 667:
            return CGSize(width: 148, height: 148)
        case 568:
            return CGSize(width: 141, height: 141)
        default:
            return CGSize(width: 155, height: 155)
        }
    }
    
    func getMediumWidgetSize() -> CGSize {
        let screenBounds = UIScreen.main.bounds.size
        let height = screenBounds.height
        switch height {
        case 926:
            return CGSize(width: 362, height: 170)
        case 896:
            return CGSize(width: 360, height: 169)
        case 812:
            return CGSize(width: 329, height: 155)
        case 736:
            return CGSize(width: 348, height: 159)
        case 667:
            return CGSize(width: 322, height: 148)
        case 568:
            return CGSize(width: 291, height: 141)
        default:
            return CGSize(width: 329, height: 155)
        }
    }
    
    func getLargeWidgetSize() -> CGSize {
        let screenBounds = UIScreen.main.bounds
        let height = screenBounds.height
        switch height {
        case 926:
            return CGSize(width: 362, height: 382)
        case 896:
            return CGSize(width: 360, height: 376)
        case 812:
            return CGSize(width: 329, height: 345)
        case 736:
            return CGSize(width: 348, height: 357)
        case 667:
            return CGSize(width: 322, height: 324)
        case 568:
            return CGSize(width: 291, height: 299)
        default:
            return CGSize(width: 329, height: 376)
        }
    }
}
