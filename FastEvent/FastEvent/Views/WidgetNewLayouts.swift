//
//  WidgetNewLayouts.swift
//  FastEvent
//
//  Created by Social Development on 30/11/23.
//

import SwiftUI

struct WidgetNewLayouts: View {
    
    @State var progressValue: Float = 0.8
    @State private var degress: Double = -110
    private let padding: Double = 15
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            let gradient = LinearGradient(colors: [Color.widgetSixthOne, Color.widgetSixthtwo], startPoint: .top, endPoint: .bottom)
            
            gradient.opacity(15)
            ZStack {
//                StyleSixthView
//                StyleSeventhView
//                StyleEightThView
//                StyleNinThView
//                StyleTenthView
//                StyleElevenThView
//                StyleTwelveThView
//                StyleTherteenThView
//                StyleFourteenThView
            }
        }
    }
    
    /// Style #6
    private var StyleSixthView: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .center) {
                Image("SixthWidgetCircleImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Text("20 Days")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding([.top], 15)
                Spacer()
                HStack(alignment: .center, spacing: 8) {
                    ZStack {
                        let lineWidth: Double = 5
                        let totalDays: Double = 365.0
                        let daysLeft: Int = 200
                        let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
                        Circle().strokeBorder(.white, lineWidth: lineWidth)
                            .opacity(0.3)
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(275.0)).padding(lineWidth / 2.0)
                            .foregroundStyle(LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom))
                    }
                    .frame(width: 20, height: 20)

                    
                    Text("New Year’s Day")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.8))
                    Image("img_celebration")
                        .aspectRatio(contentMode: .fit)

                }
                .frame(width: geometry.size.width, height: 30, alignment: .center)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.98, green: 0.51, blue: 0.1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.97, green: 0.4, blue: 0.13), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                    .shadow(radius: 5)
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
                        Text("Makar Sankranti")
                            .font(.system(size: 12, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
                        
                        HStack(alignment: .top) {
                            Text("158 days")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)

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
                            .foregroundStyle(.white)
                        
                        Text("25 days")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
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
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.widgetSixthOne, Color.widgetSixthtwo]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(1))
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .offset(x: geometry.size.width / 3, y: geometry.size.height / 3)
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.widgetSixthOne, Color.widgetSixthtwo]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(1))
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            GeometryReader(content: { geometry in
                VStack {
                    Text("Makar Sankranti")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                                
                    Spacer()

                    Image("img_kites")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                    
                    Spacer()

                    
                    HStack {
                        let days: Int = 5
                        if days > 99 {
                            let months: Int = 10
                            FlipTile(title: "\(months)",
                                     subtitle: "month\(months == 1 ? "" : "s")")
                        } else {
                            FlipTile(title: "\(days)",
                                     subtitle: "day\(days == 1 ? "" : "s")")
                        }
                        
                        let hours: Int = 5
                        FlipTile(title: "\(hours)", subtitle: "hours")
                        
                        let minutes: Int = 10
                        FlipTile(title: "\(minutes)", subtitle: "min")
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
                        Text("Makar Sankranti")
                            .font(.system(size: 12, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("158 days")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                
                Spacer()
                
                Image("img_calendar")
                    .resizable()
                    .frame(width: 42, height: 42)
            }
            .lineLimit(1)
            .padding()
        }
        .overlay {
            Image("img_bg_lines")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    private var StyleTenthView: some View {
        ZStack {
            GeometryReader(content: { geometry in
                Image("img_circles")
                    .resizable()
                    .frame(width: geometry.size.width)
            })
//                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text("Father's day").font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                HStack {
                    Text("155").font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack(alignment: .center, spacing: 5) {
                    VStack(alignment: .leading) {
                        Text("Days").font(.system(size: 25, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
            }
            .lineLimit(1)
            .padding(padding)
        }
    }
    
//    private var StyleElevenThView: some View {
//        ZStack {
//            Image("img_shades")
//                .resizable()
////                .aspectRatio(contentMode: .fill)
//
//            VStack(alignment: .center) {
//                HStack(alignment: .center) {
//                    Image("img_only_kites")
//                    
//                    Text("Makar Sankranti")
//                        .font(.system(size: 12, weight: .medium, design: .rounded))
//                        .foregroundStyle(.white)
//                }
//                
//                Spacer()
//
//                ZStack {
//                    ProgressBar(progress: self.$progressValue)
////                        .frame(width: 100, height: 100)
//                        .padding(0).onReceive(timer) { _ in
//                            withAnimation {
//                                if progressValue < 0.8999996 {
//                                    progressValue += 0.0275
//                                }
//                            }
//                        }
////                        .offset(x: 0, y: 50)
//                    
////                    ProgressBarTriangle(progress: self.$progressValue)
////                        .frame(width: 20, height: 20)
////                        .rotationEffect(.degrees(degress), anchor: .bottom)
////                        .offset(x: 0, y: -170).onReceive(timer) { input in
////                            withAnimation(.linear(duration: 0.01).speed(200)) {
////                                if degress < 110.0 {
////                                    degress += 10
////                                }
////                                print(degress)
////                            }
////                        }
//                }
//            }
//            .lineLimit(1)
//            .padding()
//        }
//    }

    private var StyleTwelveThView: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                Spacer()
                ZStack(alignment: .center) {
                    Image("img_polygon")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    Image("img_flag")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
            }
            
            ZStack {
                Image("img_special_day_bg")
                    .resizable()
//                    .aspectRatio(contentMode: .fill)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("National day")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding([.leading, .top])
                    
                    VStack(alignment: .leading) {
                        Text("183 days")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        ZStack {
                            Color.white.opacity(0.4).cornerRadius(5)
                            HStack(spacing: 5) {
                                Image("img_clock")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("10 hr, 5 min")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 35)
                    }
                    .padding()
                }
            }.lineLimit(1)
        }
    }
    
    private var StyleTherteenThView: some View {
        ZStack {
            
//            HStack {
                Image("img_flowers")
                    .resizable()
                
//                Spacer()
//
//                Image("img_flowers_right")
//                    .resizable()
//            }
            VStack {
                //            let gradient = LinearGradient(colors: [Color.widgetSixthOne, Color.widgetSixthtwo], startPoint: .top, endPoint: .bottom)
                
                HStack(spacing: 5) {
                    Image("mothersDay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text("Mother's day")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                ZStack {
                    let lineWidth: Double = 10
                    let totalDays: Double = 365.0
                    let daysLeft: Int = 50
                    let progress: Double = ((totalDays - Double(daysLeft)) / totalDays)
                    Circle().strokeBorder(.white, lineWidth: lineWidth)
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth / 1.8,
                                                   lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(275.0)).padding(lineWidth / 2.0)
                        .foregroundStyle(LinearGradient(colors: [.red, .pink], startPoint: .top, endPoint: .bottom))
                    VStack(spacing: -2) {
                        Text("7hr").font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                        Text("17hr").font(.system(size: 10, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
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
                Text("National day")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("183 days")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 5) {
                            Image("img_clock")
                                .resizable()
                                .frame(width: 12, height: 12)
                            
                            Text("10 hr, 5 min")
                                .font(.system(size: 10, weight: .light, design: .rounded))
                                .foregroundStyle(.white)
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

#Preview {
    WidgetNewLayouts()
        .cornerRadius(26).frame(width: 335, height: 335)
}
