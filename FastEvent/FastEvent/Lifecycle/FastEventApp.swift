//
//  FastEventApp.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import TipKit
import SwiftUI
import WidgetKit
@main
struct FastEventApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var manager: DataManager = DataManager()
    @Environment(\.scenePhase) var scenePhase

    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
            DashboardContentView(manager: manager, rating: .constant(0))
                .environmentObject(manager)
                .onChange(of: scenePhase) { _, _ in WidgetCenter.shared.reloadAllTimelines() }
                .task {
                    try? Tips.configure([.displayFrequency(.immediate), .datastoreLocation(.applicationDefault)])
                }
                .onAppear(perform: {
                    if manager.userEmail.count > 0{
                        FirebaseEventModel().fetchData(email: manager.userEmail, manager: manager)
                    }
                })
        }
    }
}

/// Root controller for the app
var rootController: UIViewController? {
    var root = UIApplication.shared.connectedScenes
        .filter({ $0.activationState == .foregroundActive })
        .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: { $0.isKeyWindow })?.rootViewController
    while root?.presentedViewController != nil {
        root = root?.presentedViewController
    }
    return root
}

/// Hide keyboard from any view
extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
