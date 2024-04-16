//
//  PaywallView.swift
//  FastEvent
//
//  Created by RaviPadshala on 21/11/23.
//

import SwiftUI
import RevenueCatUI
import RevenueCat

struct PaywallDemoView: View {
    
    @EnvironmentObject var manager: DataManager
    @Binding var isPresented: Bool
    
    var body: some View {
//        presentPaywallIfNeeded(
//            requiredEntitlementIdentifier: "pro",
//            purchaseCompleted: { customerInfo in
//                print("Purchase completed: \(customerInfo.entitlements)")
//            },
//            restoreCompleted: { customerInfo in
//                // Paywall will be dismissed automatically if "pro" is now active.
//                print("Purchases restored: \(customerInfo.entitlements)")
//            }
//        )
        PaywallView()
            .onPurchaseCompleted { customerInfo in
                print("customerInfo", customerInfo)
                manager.isPremiumUser = true
                isPresented = false
            }
            .onRestoreCompleted { customerInfo in
                print("customerInfo", customerInfo)
                manager.isPremiumUser = true
                isPresented = false
            }
    }
}

#Preview {
    PaywallDemoView(isPresented: .constant(false))
}
