//
//  WidgetView.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import WidgetKit

/// Widget layouts
enum WidgetLayoutType: String, CaseIterable, Identifiable {
   case basic, styleOne, styleTwo, styleThree, styleFour, styleFive, styleSix, styleSeventh, styleEighth, styleNinth, styleTenth, styleEleventh, styleTwelveth, styleThirteen, styleFourteen
   var id: Int { hashValue }
}

/// Widget preview based on location
enum WidgetLocation: String, Identifiable, CaseIterable {
   case light = "StandBy Light"
   case dark = "StandBy Dark"
   var icon: String {
       switch self {
       case .light:
           return "sun.max.fill"
       case .dark:
           return "moon.fill"
       }
   }
   var id: Int { hashValue }
}

/// Shows the widget view with different styles
struct WidgetView: View {

    let model: EventModel
    private let padding: Double = 15
//    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var useRenderingMode: Bool = false
    @State var progressValue: Float = 0.8
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            let gradient = LinearGradient(colors: [self.model.backgroundColorStart, self.model.backgroundColorEnd], startPoint: .top, endPoint: .bottom)

            if useRenderingMode {
                if widgetRenderingMode != .vibrant {
                    gradient.opacity(padding)
                } else {
                    Color.black.opacity(0.1)
                }
            } else {
                gradient.opacity(padding)
                Color.black.opacity(model.location == .light ? 0 : 1)
            }
            ZStack {
                switch model.widgetStyle {
                case .basic:
                    BasicStyleView
                case .styleOne:
                    StyleOneView
                case .styleTwo:
                    StyleTwoView
                case .styleThree:
                    StyleThreeView
                case .styleFour:
                    StyleFourView
                case .styleFive:
                    StyleFiveView
                case .styleSix:
                    StyleSixthView
                case .styleSeventh:
                    StyleSeventhView
                case .styleEighth:
                    StyleEightThView
                case .styleNinth:
                    StyleNinThView
                case .styleTenth:
                    StyleTenthView
                case .styleEleventh:
                    StyleElevenThView
                case .styleTwelveth:
                    StyleTwelveThView
                case .styleThirteen:
                    StyleThirteenThView
                case .styleFourteen:
                    StyleFourteenThView
                }
            }
            .foregroundStyle(model.location == .light ? model.fontColor : .red)
        }
    }

    /// Basic widget layout
    private var BasicStyleView: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(model.title)
                        .font(model.font(for: .title))
                    Spacer()
                    Image(model.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                }
                Spacer()
                Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                    .font(model.font(for: .date))
                Text("\(model.exactTimeLeft(.hour)) hr, \(model.exactTimeLeft(.minute)) min")
                    .font(model.font(for: .time))
            }
            .lineLimit(1)
        }
        .overlay {
            Image(model.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.1).offset(x: 30, y: 50).rotationEffect(.degrees(-30))
        }
        .padding(padding)
    }

    /// Style #1
    private var StyleOneView: some View {
        VStack {
            let gradient = LinearGradient(colors: [self.model.backgroundColorStart, self.model.backgroundColorEnd], startPoint: .top, endPoint: .bottom)

            HStack(spacing: 5) {
                Text(model.title)
                    .font(model.font(for: .title))
                Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: model.iconSize, height: model.iconSize)
            }
            ZStack {
                let lineWidth: Double = 14.0
                let totalDays: Double = 365.0
                let daysLeft: Int = model.timeLeft(.day)
                let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
                Circle().strokeBorder(model.fontColor, lineWidth: lineWidth)
                    .opacity(model.location == .light ? 1 : 0.3)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth / 1.8,
                                               lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(275.0)).padding(lineWidth / 2.0)
                    .foregroundStyle(model.location == .light ? gradient : LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom))
                VStack(spacing: -2) {
                    Text("\(daysLeft)").font(model.font(for: .date))
                    Text("day\(daysLeft == 1 ? "" : "s")").font(model.font(for: .time))
                }.multilineTextAlignment(.center)
            }
        }
        .padding(padding)
    }

    /// Style #2
    private var StyleTwoView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(model.title).font(model.font(for: .title))
                Spacer()
                Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: model.iconSize, height: model.iconSize)
            }
            model.fontColor.frame(height: 1).opacity(0.5)
            HStack(spacing: 0) {
                Text("\(model.timeLeft(.day))")
                Text(" day\(model.timeLeft(.day) == 1 ? "" : "s")").opacity(0.8)

            }.font(model.font(for: .date))
            HStack(spacing: 0) {
                Text("\(model.exactTimeLeft(.hour))")
                Text(" hour\(model.exactTimeLeft(.hour) == 1 ? "" : "s")").opacity(0.7)

            }.font(model.font(for: .time))
            HStack(spacing: 0) {
                Text("\(model.exactTimeLeft(.minute))")
                Text(" minute\(model.exactTimeLeft(.minute) == 1 ? "" : "s")").opacity(0.6)

            }.font(model.font(for: .time))
        }
        .lineLimit(1)
        .padding(padding)
    }

    /// Style #3
    private var StyleThreeView: some View {
        func FlipTile(title: String, subtitle: String) -> some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    LinearGradient(colors: [Color(#colorLiteral(red: 0.9720312953, green: 0.9720312953, blue: 0.9720312953, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))], startPoint: .top, endPoint: .bottom)
                    [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))][0].frame(height: 1)
                    LinearGradient(colors: [Color(#colorLiteral(red: 0.9720312953, green: 0.9720312953, blue: 0.9720312953, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))], startPoint: .bottom, endPoint: .top)
                }
                .cornerRadius(5.0)
                .frame(width: 35, height: 28).shadow(radius: 1, y: 1)
                .opacity(model.location == .light ? 1 : 0.2)
                .overlay(
                    Text(title).font(model.font(for: .date))
                        .foregroundColor(model.location == .light ? .black : .red)
                )
                Text(subtitle).foregroundStyle(model.fontColor)
                    .font(model.font(for: .time)).opacity(0.7)
            }
        }
        return ZStack {
            Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                .frame(width: model.iconSize, height: model.iconSize)
                .offset(y: -12).opacity(0.5)
            VStack {
                Text(model.title).font(model.font(for: .title))
                Spacer()
                HStack {
                    let days: Int = model.timeLeft(.day)
                    if days > 99 {
                        let months: Int = model.timeLeft(.month)
                        FlipTile(title: "\(months)",
                                 subtitle: "month\(months == 1 ? "" : "s")")
                    } else {
                        FlipTile(title: "\(days)",
                                 subtitle: "day\(days == 1 ? "" : "s")")
                    }

                    let hours: Int = model.exactTimeLeft(.hour)
                    FlipTile(title: "\(hours)", subtitle: "hours")

                    let minutes: Int = model.exactTimeLeft(.minute)
                    FlipTile(title: "\(minutes)", subtitle: "minutes")
                }
            }.lineLimit(1)
        }
        .padding(padding)
    }

    /// Style #4
    private var StyleFourView: some View {
        VStack {
            VStack(spacing: -5) {
                Text("\(model.timeLeft(.day))").font(model.font(for: .date))
                Text("day\(model.timeLeft(.day) == 1 ? "" : "s")")
                    .opacity(0.8).font(model.font(for: .time))
            }.padding(.top).offset(y: -5)
            Spacer()
            ZStack {
                model.fontColor.opacity(0.2).cornerRadius(5)
                Text("\(model.exactTimeLeft(.hour)) hr, \(model.exactTimeLeft(.minute)) min")
                    .font(model.font(for: .title))
            }
            Spacer()
            model.fontColor.frame(height: 1).opacity(0.5)
            HStack(alignment: .center, spacing: 5) {
                Text(model.title).font(model.font(for: .title))
                Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: model.iconSize, height: model.iconSize)
            }
        }
        .lineLimit(1)
        .padding(padding)
    }

    /// Style #5
    private var StyleFiveView: some View {
        ZStack {
            Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                .opacity(0.1).offset(x: 40, y: 60).rotationEffect(.degrees(-20))
            VStack(alignment: .leading) {
                Text(model.title).font(model.font(for: .title)).bold()
                Spacer()
                HStack {
                    Text("\(model.timeLeft(.day))").font(model.font(for: .date))
                    Spacer()
                }.minimumScaleFactor(0.5)
                Spacer()
                HStack(alignment: .center, spacing: 5) {
                    VStack(alignment: .leading) {
                        Text("Days Until").font(model.font(for: .time)).bold()
                        Text(model.eventDate).font(model.font(for: .time)).italic()
                    }
                    Spacer()
                    Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                }
            }.lineLimit(1)
        }
        .padding(padding)
    }
    
    private var StyleSixthView: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .center) {
                let gradient = LinearGradient(colors: [(model.location == .light ? model.backgroundColorStart : .red.opacity(0.6)), (model.location == .light ? model.backgroundColorEnd : .red.opacity(0.6))], startPoint: .top, endPoint: .bottom)

                Image("SixthWidgetCircleImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }
                    .padding([.top], 15)
                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
                Spacer()
                HStack(alignment: .center, spacing: 8) {
                    ZStack {
                        let lineWidth: Double = 5
                        let totalDays: Double = 365.0
                        let daysLeft: Int = model.timeLeft(.day)
                        let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
                        Circle().strokeBorder(model.fontColor, lineWidth: lineWidth)
                            .opacity(model.location == .light ? 1 : 0.3)
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(275.0)).padding(lineWidth / 2.0)
                            .foregroundStyle(model.location == .light ? gradient : LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom))
                    }
                    .frame(width: 20, height: 20)

                    
                    Text(model.title).font(model.font(for: .title))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    
                    Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)

                }
                .frame(width: geometry.size.width, height: 30, alignment: .center)
                .background(
                    gradient
                )
            }
            .lineLimit(1)
        })
    }
    
    private var StyleSeventhView: some View {
        ZStack {
            Image("img_stars")
                .resizable()

            GeometryReader(content: { geometry in
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(model.title)
                            .font(model.font(for: .title))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        HStack(alignment: .top) {
                            Text("14 Jan")
                                .font(model.font(for: .title))
                                .foregroundStyle(model.location == .light ? model.fontColor : .red)
                            
                            Spacer()
                            
                            Image("img_long_kites")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.4)
                        }
                    }
                    
                    Spacer()
                    HStack {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .frame(width: 2, height: 35)
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }
                }
                .lineLimit(1)
                .padding([.leading, .top, .bottom])
            })
        }
    }
    
    private var StyleEightThView: some View {
        func FlipTile(title: String, subtitle: String) -> some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    LinearGradient(colors: [Color(#colorLiteral(red: 0.9720312953, green: 0.9720312953, blue: 0.9720312953, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))], startPoint: .top, endPoint: .bottom)
//                    [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))][0].frame(height: 1)
                    LinearGradient(colors: [Color(#colorLiteral(red: 0.9720312953, green: 0.9720312953, blue: 0.9720312953, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))], startPoint: .bottom, endPoint: .top)
                }
                .cornerRadius(5.0)
                .frame(width: 35, height: 28).shadow(radius: 1, y: 1)
                .opacity(/*model.location == .light ? 1 :*/ 0.2)
                .overlay(
                    Text(title).font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(/*model.location == .light ? .black :*/ .white)
                )
                Text(subtitle).foregroundStyle(.white)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
            }
        }
        return ZStack {
            
            let gradient = LinearGradient(colors: [(model.location == .light ? model.backgroundColorStart : .red.opacity(0.6)), (model.location == .light ? model.backgroundColorEnd : .red.opacity(0.8))], startPoint: .top, endPoint: .bottom)

            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(gradient.opacity(1))
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .offset(x: geometry.size.width / 3, y: geometry.size.height / 3)
                    
                    Circle()
                        .fill(gradient.opacity(1))
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            GeometryReader(content: { geometry in
                VStack {
                    Text(model.title)
                        .font(model.font(for: .title))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    Spacer()

//                    Image("img_kites")
                    Image(model.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    
                    Spacer()

                    
                    HStack {
                        let days: Int = model.timeLeft(.day)
                        if days > 99 {
                            let months: Int = model.timeLeft(.month)
                            FlipTile(title: "\(months)", subtitle: "month\(months == 1 ? "" : "s")")
                        } else {
                            FlipTile(title: "\(days)", subtitle: "day\(days == 1 ? "" : "s")")
                        }

                        let hours: Int = model.exactTimeLeft(.hour)
                        FlipTile(title: "\(hours)", subtitle: "hours")

                        let minutes: Int = model.exactTimeLeft(.minute)
                        FlipTile(title: "\(minutes)", subtitle: "minutes")
                    }
                }
                .lineLimit(1)
            })
        }
        .padding(padding)
    }
    
    private var StyleNinThView: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(model.title)
                            .font(model.font(for: .title))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }
                    Spacer()
                }
                
                Spacer()
                
//                Image("img_calendar")
//                    .resizable()
//                    .frame(width: 42, height: 42)
                
                Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: model.iconSize, height: model.iconSize)
                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
            }
            .lineLimit(1)
            .padding()
        }
        .overlay {
            Image("img_bg_lines")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(model.location == .light ? model.fontColor : .red)
        }
    }
    
    private var StyleTenthView: some View {
        ZStack {
            GeometryReader(content: { geometry in
                Image("img_circles")
                    .resizable()
                    .frame(width: geometry.size.width)
                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
            })
//                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(model.font(for: .title))
                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
                
                Spacer()
                HStack {
                    Text("\(model.timeLeft(.day))")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    Spacer()
                }
                HStack(alignment: .center, spacing: 5) {
                    VStack(alignment: .leading) {
                        Text("Day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 25, weight: .medium, design: .rounded))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }
                }
            }
            .lineLimit(1)
            .padding(padding)
        }
    }
    
    private var StyleElevenThView: some View {
        ZStack {
            let gradient = LinearGradient(colors: [self.model.backgroundColorStart, self.model.backgroundColorEnd], startPoint: .top, endPoint: .bottom)
            let finalGradient = (model.location == .light) ? gradient : LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom)
            let finalColor = (model.location == .light ? model.fontColor : .red)
            
            Image("img_shades")
                .resizable()
//                .aspectRatio(contentMode: .fill)

            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Image(model.iconName).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    
                    Text(model.title)
                        .font(model.font(for: .title))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                }
                
                Spacer()

                ZStack {
//                    let totalDays: Double = 365.0
//                    let daysLeft: Int = model.timeLeft(.day)
//                    let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
//                    let progress: Double = ((totalDays - Double(daysLeft)) / totalDays) * 180.0
                    
                    let totalDays: Double = 365.0
                    let daysLeft: Int = model.timeLeft(.day)
                    let progress: Double = 1.0 - ((Double(daysLeft)) / totalDays)

                    // Map progress to the range 0.3 to 0.9
                    let minValue: Double = 0.3
                    let maxValue: Double = 0.9
                    let mappedProgress = minValue + progress * (maxValue - minValue)
                    
                    
                    let _ = print("progress is : ", mappedProgress)
                                        
                    ProgressBar(progress: Float(mappedProgress), timeLeft: self.getFinalTime(daysLeft: daysLeft, model: model), color: finalColor, gradient: finalGradient)
//                        .frame(width: 100, height: 100)
//                        .padding(0).onReceive(timer) { _ in
//                            withAnimation {
//                                if progressValue < 0.8999996 {
//                                    progressValue += 0.0275
//                                }
//                            }
//                        }
//                        .offset(x: 0, y: 50)
                    
//                    ProgressBarTriangle(progress: self.$progressValue)
//                        .frame(width: 20, height: 20)
//                        .rotationEffect(.degrees(degress), anchor: .bottom)
//                        .offset(x: 0, y: -170).onReceive(timer) { input in
//                            withAnimation(.linear(duration: 0.01).speed(200)) {
//                                if degress < 110.0 {
//                                    degress += 10
//                                }
//                                print(degress)
//                            }
//                        }
                }
            }
            .lineLimit(1)
            .padding()
        }
    }
    
    func getFinalTime(daysLeft: Int, model: EventModel) -> String {
        if daysLeft != 0 {
            return "day\(daysLeft == 1 ? "" : "s")"
        } else {
            return "\(model.exactTimeLeft(.hour)) hr, \(model.exactTimeLeft(.minute)) min"
        }
    }

    private var StyleTwelveThView: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                Spacer()
                ZStack(alignment: .center) {
                    Image("img_polygon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    
                    Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                }
            }
            
            ZStack {
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(model.title).font(model.font(for: .title))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }
                    .padding([.leading, .top])
                    
                    VStack(alignment: .leading) {
                        Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        Spacer()
                        
                        ZStack {
                            Color.white.opacity(0.4).cornerRadius(5)
                            HStack(spacing: 5) {
                                Image("img_clock")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
                                
                                Text("\(model.exactTimeLeft(.hour)) hr, \(model.exactTimeLeft(.minute)) min")
                                    .font(model.font(for: .time))
                                    .foregroundStyle(model.location == .light ? model.fontColor : .red)
                            }
                        }
                        .frame(height: 35)
                    }
                    .padding()
                }
            }.lineLimit(1)
        }
    }
    
    private var StyleThirteenThView: some View {
        ZStack {
            let gradient = LinearGradient(colors: [self.model.backgroundColorStart, self.model.backgroundColorEnd], startPoint: .top, endPoint: .bottom)

            Image("img_flowers")
                .resizable()
                .foregroundStyle(model.fontColor)
            
            VStack {
                HStack(spacing: 5) {
                    Image(model.iconName).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: model.iconSize, height: model.iconSize)
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)

                    Text(model.title).font(model.font(for: .dateCreated))
                        .foregroundStyle(model.location == .light ? model.fontColor : .red)
                }
                
                ZStack {
                    let lineWidth: Double = 10
                    let totalDays: Double = 365.0
                    let daysLeft: Int = model.timeLeft(.day)
                    let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
                    Circle().strokeBorder(.white, lineWidth: lineWidth)
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth / 1.8,
                                                   lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(275.0)).padding(lineWidth / 2.0)
                        .foregroundStyle(model.location == .light ? gradient : LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom))
                    VStack(spacing: -2) {
                        Text("\(daysLeft)").font(model.font(for: .date))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        Text("day\(daysLeft == 1 ? "" : "s")").font(model.font(for: .time))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                    }.multilineTextAlignment(.center)
                }
                .padding(.top)
            }
            .padding()
        }
    }

    private var StyleFourteenThView: some View {
        ZStack {
            Image("img_snow")
                .resizable()
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(model.font(for: .dateCreated))
                    .foregroundStyle(model.location == .light ? model.fontColor : .red)

                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(model.timeLeft(.day)) day\(model.timeLeft(.day) == 1 ? "" : "s")")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        
                        HStack(spacing: 5) {
                            Image("img_clock")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(model.location == .light ? model.fontColor : .red)
                            
                            Text("\(model.exactTimeLeft(.hour)) hr, \(model.exactTimeLeft(.minute)) min")
                                .font(.system(size: 10, weight: .light, design: .rounded))
                                .foregroundStyle(model.location == .light ? model.fontColor : .red)
                        }
                    }
                    
                    Spacer()
                    
                    Image("img_christmas")
                }
            }
            .lineLimit(1)
            .padding()
        }
    }
}

// MARK: - Preview UI
#Preview {
    let manager = DataManager()
    manager.getAllObjects()
    if let event = manager.eventsArr.first {
        var firstLayoutData = event.data
        firstLayoutData[.layoutStyle] = WidgetLayoutType.basic.rawValue
        firstLayoutData[.date] = Date.create(["10/30/2023"]).string
        manager.eventsArr[0] = .init(data: firstLayoutData)
    }
    return WidgetView(model: manager.eventsArr[0])
        .cornerRadius(26).frame(width: 165, height: 165)
//    return WidgetView(model: manager.events[0], padding: 15)
//        .cornerRadius(26).frame(width: 165, height: 165)
}
