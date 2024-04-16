//
//  AppConfig.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import TipKit
import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {

    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-3940256099942544/4411468910"

    // MARK: - Generic Configurations
    static let icons: [String] = ["christmas", "date", "diwali", "easter", "fathersDay", "feet", "halloween", "hanukkah", "heart", "honey-moon", "house", "mothersDay", "newYear", "snowed-mountains", "snowflake", "stroller", "sun-umbrella", "thanksgiving", "tooth"]

    // MARK: - Settings flow items
    static let emailSupport = "support@apps4world.com"
    static let privacyURL: URL = URL(string: "https://www.google.com/")!
    static let termsAndConditionsURL: URL = URL(string: "https://www.google.com/")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!

    // MARK: - In App Purchases
    static let premiumVersion: String = "com.go.reminder.widget.premium"
    static let freeLayoutStyles: [WidgetLayoutType] = [.basic, .styleOne]
    static let freeWidgetsCount: Int = 2

    // MARK: - App Group identifier
    static let appGroup: String = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_IDENTIFIER") as! String

    // MARK: - Shared UserDefaults
    static var userDefaults: UserDefaults? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_IDENTIFIER") as? String else { return nil }
        return UserDefaults(suiteName: value)
    }
}

/// Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case premium
    var id: Int { hashValue }
}

func getCurrentMillis()->Int64{
    return  Int64(NSDate().timeIntervalSince1970 * 1000)
}

/// Default Holidays
enum Holiday: String, CaseIterable, Identifiable {
    case christmas = "Christmas"
    case hanukkah = "Hanukkah"
    case newYear = "New Year"
    case easter = "Easter"
    case mothersDay = "Mother's Day"
    case fathersDay = "Father's Day"
    case diwali = "Diwali"
    case halloween = "Halloween"
    case thanksgiving = "Thanksgiving"
    var id: Int { hashValue }

    /// Upcoming date
    var date: Date {
        switch self {
        case .christmas: return .create(["12/25/2024", "12/25/2025", "12/25/2026"])
        case .hanukkah: return .create(["12/08/2024", "12/26/2025", "12/05/2026"])
        case .newYear: return .create(["01/01/2024", "01/01/2025", "01/01/2026"])
        case .easter: return .create(["04/09/2024", "03/31/2025", "04/20/2026"])
        case .mothersDay: return .create(["05/14/2024", "05/12/2025", "05/11/2026"])
        case .fathersDay: return .create(["06/18/2024", "06/16/2025", "06/15/2026"])
        case .diwali: return .create(["11/12/2024", "11/01/2025", "10/21/2026"])
        case .halloween: return .create(["10/31/2024", "10/31/2025", "10/31/2026"])
        case .thanksgiving: return .create(["11/23/2024", "11/28/2025", "11/27/2026"])
        }
    }

    /// Widget gradient colors
    var colors: [Color] {
        switch self {
        case .christmas: return [Color(#colorLiteral(red: 0.8629896045, green: 0.3201281726, blue: 0.3448847532, alpha: 1)), Color(#colorLiteral(red: 0.7062624097, green: 0.1932396591, blue: 0.2215294838, alpha: 1))]
        case .hanukkah: return [Color(#colorLiteral(red: 0.9983513951, green: 0.6176047921, blue: 0.01037522405, alpha: 1)), Color(#colorLiteral(red: 0.9991112351, green: 0.4763198495, blue: 0.01283245254, alpha: 1))]
        case .newYear: return [Color(#colorLiteral(red: 0.470384419, green: 0.7322953939, blue: 0.2413284183, alpha: 1)), Color(#colorLiteral(red: 0.3769256473, green: 0.613894403, blue: 0.1617893577, alpha: 1))]
        case .easter: return [Color(#colorLiteral(red: 0.2769576311, green: 0.5475818515, blue: 0.9584969878, alpha: 1)), Color(#colorLiteral(red: 0.1742394567, green: 0.4491225481, blue: 0.8220514655, alpha: 1))]
        case .mothersDay: return [Color(#colorLiteral(red: 0.5302895308, green: 0.365604341, blue: 0.8966403604, alpha: 1)), Color(#colorLiteral(red: 0.3996735215, green: 0.2689704299, blue: 0.8300299048, alpha: 1))]
        case .fathersDay: return [Color(#colorLiteral(red: 0.0, green: 0.4862745098, blue: 0.6078431373, alpha: 1)), Color(#colorLiteral(red: 0.0, green: 0.4588235294, blue: 0.7450980392, alpha: 1))]
        case .diwali: return [Color(#colorLiteral(red: 0.9991112351, green: 0.4763198495, blue: 0.01283245254, alpha: 1)), Color(#colorLiteral(red: 0.9988374114, green: 0.6133651137, blue: 0.01535863429, alpha: 1))]
        case .halloween: return [Color(#colorLiteral(red: 0.9019607843, green: 0.1176470588, blue: 0.3882352941, alpha: 1)), Color(#colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1))]
        case .thanksgiving: return [Color(#colorLiteral(red: 0.1742394567, green: 0.4491225481, blue: 0.8220514655, alpha: 1)), Color(#colorLiteral(red: 0.2769576311, green: 0.5475818515, blue: 0.9584969878, alpha: 1))]
        }
    }

    /// Widget layout style
    var layout: WidgetLayoutType {
        switch self {
        case .christmas: return .basic
        case .hanukkah: return .styleOne
        case .newYear: return .styleTwo
        case .easter: return .styleThree
        case .mothersDay: return .styleFour
        case .fathersDay: return .styleFive
        case .diwali: return .basic
        case .halloween: return .styleTwo
        case .thanksgiving: return .styleFour
        }
    }

    /// Event model
    var model: EventModel {
        let eventId: String = "\(self)"
        var data: [EventDataType: String] = [EventDataType: String]()
        EventDataType.allCases.forEach { dataType in
            switch dataType {
            case .title: data[dataType] = rawValue
            case .icon: data[dataType] = eventId
            case .date: data[dataType] = date.shortFormat
            case .time: data[dataType] = date.shortTimeFormat
            case .backgroundColorStart: data[dataType] = colors[0].string
            case .backgroundColorEnd: data[dataType] = colors[1].string
            case .fontColor: data[dataType] = Color.white.string
            case .layoutStyle: data[dataType] = layout.rawValue
            case .dateCreated: data[dataType] = Date().string
            case .location: data[dataType] = WidgetLocation.light.rawValue
            }
        }
        return .init(id: "\(self)",data: data)
    }
}

struct ProgressBar: View {
    var progress: Float
    var timeLeft: String
    var color: Color
    var gradient: LinearGradient
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
//                .opacity(0.3)
                .foregroundColor(.white)
                .rotationEffect(.degrees(54.5))
            
            Circle()
                .trim(from: 0.3, to: CGFloat(self.progress))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .fill(gradient)
                .rotationEffect(.degrees(54.5))

//                .foregroundStyle(.white)
//                .fill(AngularGradient(gradient: Gradient(stops: [
//                    .init(color: Color.init(hex: "ED4D4D"), location: 0.39000002),
//                    .init(color: Color.init(hex: "E59148"), location: 0.48000002),
//                    .init(color: Color.init(hex: "EFBF39"), location: 0.5999999),
//                    .init(color: Color.init(hex: "EEED56"), location: 0.7199998),
//                    .init(color: Color.init(hex: "32E1A0"), location: 0.8099997)]), center: .center))
            
            VStack{
                Text(timeLeft)
                    .font(Font.system(size: 14)).bold()
                    .foregroundColor(color)
//                Text("Great Score!").bold().foregroundColor(Color.init(hex: "32E1A0"))
            }
        }
    }
}

struct ProgressBarTriangle: View {
    @Binding var progress: Float
    
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.white)
            
            Circle()
                .frame(width: 12, height: 12)
                .overlay {
                    AngularGradient(colors: [.widgetSixthOne, .widgetSixthtwo], center: .center)
                    
//                    LinearGradient(gradient: Gradient(colors: [Color.widgetSixthOne, Color.widgetSixthtwo]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(1)
                        .clipShape(.circle)
                }
        }
    }
}

//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
