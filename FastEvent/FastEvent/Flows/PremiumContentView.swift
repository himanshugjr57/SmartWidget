//
//  PremiumContentView.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import PurchaseKit

/// Shows the in-app purchases flow
struct PremiumContentView: View {

    var title: String
    var subtitle: String
    var features: [String]
    var productIds: [String]
    var exitFlow: () -> Void
    @State var completion: PKCompletionBlock?

    // MARK: - Privacy Policy, Terms & Conditions URLs
    // NOTE: You must provide these 2 URLs
    private let privacyPolicyURL: URL = AppConfig.privacyURL
    private let termsAndConditionsURL: URL = AppConfig.termsAndConditionsURL

    /// If you don't have the URLs mentioned above, you can hide the buttons by setting this to `true`
    private let hidePrivacyPolicyTermsButtons: Bool = false

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HeaderSectionView

                VStack {
                    FeaturesListView
                    ProductsListView
                }.padding(.top, 40).padding(.bottom, 20)

                RestorePurchases
                PrivacyPolicyTermsSection
                DisclaimerTextView
            }

            CloseButtonView
        }
    }

    /// Header view
    private var HeaderSectionView: some View {
        VStack(spacing: 0) {
            Image(systemName: "crown.fill").font(.system(size: 100)).padding(20)
            VStack {
                Text(title).font(.largeTitle).bold()
                Text(subtitle).font(.headline)
            }
        }.foregroundColor(.primaryText)
    }

    /// Features scroll list view
    private var FeaturesListView: some View {
        VStack {
            ForEach(features, id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.circle").resizable()
                        .frame(width: 25, height: 25)
                    Text(feature).font(.system(size: 22))
                    Spacer()
                }
            }.padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 45)
        }.foregroundColor(.primaryText)
    }

    /// List of products
    private var ProductsListView: some View {
        VStack(spacing: 10) {
            ForEach(productIds, id: \.self) { product in
                Button(action: {
                    PKManager.purchaseProduct(identifier: product, completion: self.completion)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28.5)
                            .foregroundColor(.accentColor).frame(height: 57)
                        VStack {
                            Text(PKManager.formattedProductTitle(identifier: product))
                                .foregroundColor(.secondaryText).bold()
                        }
                    }
                })
            }
        }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 10)
    }

    /// Close button on the top header
    private var CloseButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button { exitFlow() } label: {
                    Image(systemName: "xmark").padding(8)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .background(Circle().foregroundStyle(.primaryText))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }.padding(.horizontal).padding(.top, 5)
    }

    /// Restore purchases button
    private var RestorePurchases: some View {
        Button(action: {
            PKManager.restorePurchases { (error, status, id) in
                self.completion?((error, status, id))
            }
        }, label: {
            Text("Restore Purchases")
        }).opacity(0.7).foregroundColor(.primaryText)
    }

    /// Privacy Policy, Terms & Conditions section
    private var PrivacyPolicyTermsSection: some View {
        HStack(spacing: 20) {
            if hidePrivacyPolicyTermsButtons == false {
                Button(action: {
                    UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Privacy Policy")
                })
                Button(action: {
                    UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Terms & Conditions")
                })
            }
        }.font(.system(size: 10)).padding().foregroundColor(.primaryText)
    }

    /// Disclaimer text view at the bottom
    private var DisclaimerTextView: some View {
        VStack {
            Text(PKManager.disclaimer).font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 50)
        }.opacity(0.2).foregroundColor(.primaryText)
    }
}
