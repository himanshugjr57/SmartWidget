//
//  WidgetCreatorContentView.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import RevenueCatUI

/// Shows the flow to let users create a widget event
struct WidgetCreatorContentView: View {

    @EnvironmentObject var manager: DataManager
    @Environment(\.dismiss) private var dismissAction
    @State var widgetLocation: WidgetLocation = .light
    @State var widgetLayout: WidgetLayoutType = .basic
    @State var eventTitle: String = "Event Title"
    @State var eventDate: Date = Date().advanced(by: 86400)
    @State var eventTime: Date = Date().advanced(by: 60)
    @State var backgroundStartColor: Color = [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))][0]
    @State var backgroundEndColor: Color = [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))][0]
    @State var selectedIconName: String = AppConfig.icons[0]
    @State var fontColor: Color = .white
    @State var selectedWidgetId: String = ""
    @State var shouldPresentContactMainView = false

    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: 0) {
            WidgetPreviewHeader
            ZStack {
                Image("img_bg")
                    .resizable()
//                    .aspectRatio(contentMode: .fill) // Fill the entire space
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the entire view

                List {
                    EventDetailsSection
                    EventIconSection
                    WidgetStyleSection
                    WidgetLayoutSection
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    /// Event details (title, date, time)
    private var EventDetailsSection: some View {
        Section {
            TextField("Event title", text: $eventTitle)
            DatePicker(selection: $eventDate, displayedComponents: [.date]) {
                Label("Event date", systemImage: "calendar").padding(.vertical, 7)
            }
            DatePicker(selection: $eventTime, displayedComponents: [.hourAndMinute]) {
                Label("Event time", systemImage: "clock").padding(.vertical, 7)
            }
        } header: {
            Text("Event details")
        }
    }

    /// Scrollable list of icons for the event
    private var EventIconSection: some View {
        Section {
            HStack {
                Label("Icon", systemImage: "photo").padding(.vertical, 7)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer(minLength: 25)
                        ForEach(0..<AppConfig.icons.count, id: \.self) { index in
                            Image(AppConfig.icons[index])
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30).onTapGesture {
                                    selectedIconName = AppConfig.icons[index]
                                }.opacity(selectedIconName == AppConfig.icons[index] ? 1 : 0.3)
                        }
                        Spacer(minLength: 25)
                    }
                }.overlay(
                    HStack {
                        LinearGradient(colors: [.white.opacity(0), .white], startPoint: .trailing, endPoint: .leading).frame(width: 30)
                        Spacer()
                    }.allowsHitTesting(false)
                )
            }.padding(.trailing, -25)
        } header: {
            Text("Event icon")
        }
    }

    /// Widget background and font colors (only for Home Screen widgets)
    private var WidgetStyleSection: some View {
        Section {
            HStack(spacing: 15) {
                ColorPicker(selection: $backgroundStartColor) {
                    Label("Background", systemImage: "calendar")
                }
                ColorPicker("", selection: $backgroundEndColor).labelsHidden()
            }
            ColorPicker(selection: $fontColor) {
                Label("Font color", systemImage: "a")
            }
        } header: {
            Text("Widget style")
        }
        .disabled(widgetLocation == .dark)
        .opacity(widgetLocation == .dark ? 0.2 : 1.0)
    }

    /// Widget layouts
    private var WidgetLayoutSection: some View {
        Section { } header: {
            Text("Layout")
        } footer: {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 55), count: 2), spacing: 18) {
                ForEach(WidgetLayoutType.allCases) { type in
                    Button { widgetLayout = type } label: {
                        WidgetPreview(currentStyle: .constant(type), eventTitle: $eventTitle,
                                      eventDate: $eventDate, eventTime: $eventTime,
                                      backgroundColorStart: $backgroundStartColor,
                                      backgroundColorEnd: $backgroundEndColor,
                                      selectedIconName: $selectedIconName,
                                      fontColor: $fontColor, location: $widgetLocation)
                        .cornerRadius(26).frame(width: 165, height: 165)
                        .opacity(widgetLayout == type ? 1 : 0.6)
                        .overlay(PremiumOverlay(for: type))
                    }
                    .disabled(isPremium(type))
                    .onTapGesture {
                        shouldPresentContactMainView = true
                    }
                    .sheet(isPresented: $shouldPresentContactMainView, content: {
                        PaywallDemoView(isPresented: $shouldPresentContactMainView)
                    })
                }
            }
        }
    }

    /// Premium layout overlay
    private func PremiumOverlay(for type: WidgetLayoutType) -> some View {
        ZStack {
            if isPremium(type) {
                Color.black.opacity(0.4)
                VStack {
                    Image(systemName: "crown.fill").font(.system(size: 30))
                    Text("Premium").font(.system(size: 17, weight: .semibold))
                }
            }
        }.cornerRadius(26).foregroundColor(.white)
    }

    /// Check if the layout type is premium
    private func isPremium(_ type: WidgetLayoutType) -> Bool {
        !manager.isPremiumUser && !AppConfig.freeLayoutStyles.contains(type)
    }

    /// Widget preview header
    private var WidgetPreviewHeader: some View {
        ZStack {
            LinearGradient(colors: [Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))],
                           startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            LinearGradient(colors: [backgroundStartColor, backgroundEndColor],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea().opacity(widgetLocation == .light ? 0.6 : 0.0)
            VStack {
                Spacer()
                
                TabView {
                    WidgetPreview(currentStyle: $widgetLayout, eventTitle: $eventTitle,
                                  eventDate: $eventDate, eventTime: $eventTime,
                                  backgroundColorStart: $backgroundStartColor,
                                  backgroundColorEnd: $backgroundEndColor,
                                  selectedIconName: $selectedIconName,
                                  fontColor: $fontColor, location: $widgetLocation)
                    .cornerRadius(26).frame(width: 165, height: 165).offset(y: 10)
                    .shadow(color: .black.opacity(0.12), radius: 15, y: 5)
                    
                    WidgetPreview(currentStyle: $widgetLayout, eventTitle: $eventTitle,
                                  eventDate: $eventDate, eventTime: $eventTime,
                                  backgroundColorStart: $backgroundStartColor,
                                  backgroundColorEnd: $backgroundEndColor,
                                  selectedIconName: $selectedIconName,
                                  fontColor: $fontColor, location: $widgetLocation)
                    .cornerRadius(26).frame(width: 300, height: 165).offset(y: 10)
                    .shadow(color: .black.opacity(0.12), radius: 15, y: 5)
                    
                    WidgetPreview(currentStyle: $widgetLayout, eventTitle: $eventTitle,
                                  eventDate: $eventDate, eventTime: $eventTime,
                                  backgroundColorStart: $backgroundStartColor,
                                  backgroundColorEnd: $backgroundEndColor,
                                  selectedIconName: $selectedIconName,
                                  fontColor: $fontColor, location: $widgetLocation)
                    .cornerRadius(26).frame(width: 220, height: 220).offset(y: 10)
                    .shadow(color: .black.opacity(0.12), radius: 15, y: 5)
                }
                .padding(.bottom, -30)
                .tabViewStyle(.page)
                
//                Spacer()
                HStack {
                    ForEach(WidgetLocation.allCases) { location in
                        WidgetLocationButton(type: location)
                    }
                }.frame(height: 50.0).padding()
            }
            CustomNavigationBarButtons
        }.frame(height: 400.0)
    }
    
    
    /// Navigation bar custom buttons
    private var CustomNavigationBarButtons: some View {
        VStack {
            HStack {
                Button { 
                    dismissAction()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        Interstitial.shared.showInterstitialAds()
//                    }
                } label: {
                    ZStack {
                        Circle().foregroundColor(.white).opacity(0.6)
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black).opacity(0.7)
                    }
                }.frame(width: 30, height: 30)
                Spacer()
                Button {
                    hideKeyboard()
                    if self.selectedWidgetId.count > 0{
                        manager.updateEventData(withData: [
                            .title: eventTitle,
                            .icon: selectedIconName,
                            .date: eventDate.shortFormat,
                            .time: eventTime.shortTimeFormat,
                            .backgroundColorStart: backgroundStartColor.string,
                            .backgroundColorEnd: backgroundEndColor.string,
                            .layoutStyle: widgetLayout.rawValue,
                            .fontColor: fontColor.string
                        ], widgetID: self.selectedWidgetId)
                    }else{
                        manager.saveEvent(withData: [
                            .title: eventTitle,
                            .icon: selectedIconName,
                            .date: eventDate.shortFormat,
                            .time: eventTime.shortTimeFormat,
                            .backgroundColorStart: backgroundStartColor.string,
                            .backgroundColorEnd: backgroundEndColor.string,
                            .layoutStyle: widgetLayout.rawValue,
                            .fontColor: fontColor.string
                        ])
                    }
                    dismissAction()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white).opacity(0.6)
                        Text("Save").foregroundColor(.black).opacity(0.7)
                    }
                }.frame(width: 70, height: 30)
            }.padding(.horizontal)
            Spacer()
        }
    }

    /// Widget preview location (Home Screen or StandBy)
    private func WidgetLocationButton(type: WidgetLocation) -> some View {
        Button {
            widgetLocation = type
        } label: {
            ZStack {
                Color.white.opacity(type == widgetLocation ? 0.4 : 0.2)
                HStack(spacing: 5) {
                    Image(systemName: type.icon).font(.system(size: 18))
                    Text(type.rawValue).font(.system(size: 15))
                }
                .foregroundStyle(.black).opacity(0.7)
                .opacity(type == widgetLocation ? 1 : 0.2)
            }
        }.cornerRadius(10)
    }
}

// MARK: - Preview UI
#Preview {
    WidgetCreatorContentView()
}
