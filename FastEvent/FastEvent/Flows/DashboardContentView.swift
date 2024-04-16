//
//  DashboardContentView.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import SwiftUI
import RevenueCatUI
import WidgetKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import MessageUI

/// Main dashboard for the app
struct DashboardContentView: View {
    
    @ObservedObject var manager: DataManager
    @State private var showWidgetCreator: Bool = false
    @State private var searchQuery: String = ""
    @State private var showShareSheet = false
    @State private var isPaywallPresented = false
    @State private var showSheet = false
    @State private var fullName = ""
    @State private var description: String?
    @State private var email = ""
    @State private var showErrorPopupTop: Bool = false
    @State private var showErrorPopupForRatingReview: Bool = false
    @State private var starCount: CGFloat = 5
    @State private var value3: CGFloat = 1
    @State var currentNonce:String?
    @State var id: String = ""
    @State var model: EventModel = EventModel(id: "", data: [:])
    @State var show: Bool = false
    @State var showRatingDialogView: Bool = false
    @State var showDescription: Bool = true
    @Binding var rating: CGFloat
    @State private var showMailView = false

    private let tileCornerRadius: Double = 26.0
    private let padding: Double = 15.0
    
    // MARK: - Main rendering function
    var body: some View {
        NavigationStack {
            ZStack {
                Image("img_bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: columnsConfiguration, spacing: padding) {
                        AddWidgetButton
                        ForEach(filteredEvents) { model in
                            GridItemView(for: model)
                        }
                    }.padding(.horizontal)
                }
                .navigationTitle("Countdown")
                .searchable(text: $searchQuery)
                .navigationDestination(isPresented: $showWidgetCreator) {
                    WidgetCreatorContentView().environmentObject(manager)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !manager.isPremiumUser {
                            Button(action: {
                                isPaywallPresented = true
                            }) {
                                Image(systemName: "crown.fill")
                            }
                            .sheet(isPresented: $isPaywallPresented) {
                                PaywallDemoView(isPresented: $isPaywallPresented)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showSheet = true
                        }) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                        }
                        .sheet(isPresented: $showSheet) {
                            signWithAppleView()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $show){
            shareDialogView()
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.height(340)])
                .presentationCornerRadius(20)
        } 
        .sheet(isPresented: $showRatingDialogView){
            let maxHeight: CGFloat = showDescription ? 340 : 240
            reviewDialogView()
                .presentationDetents([.height(maxHeight)])
                .presentationCornerRadius(20)
        }
        .popup(isPresented: $showErrorPopupTop) {
            ZStack {
                Text(self.determineMessage())
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 60, leading: 32, bottom: 16, trailing: 32))
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
            }
            
            let _ = DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.showErrorPopupTop = false
            }
        } customize: {
            $0.type(.toast).position(.top)
        }
        .popup(isPresented: $showErrorPopupForRatingReview) {
            ZStack(alignment: .leading) {
                Text(self.determineMessageForRatingReview())
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 60, leading: 32, bottom: 16, trailing: 32))
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .multilineTextAlignment(.leading)
            }
            
            let _ = DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.showErrorPopupForRatingReview = false
            }
        } customize: {
            $0.type(.toast).position(.top)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.openReviewPopup()
            }
        }
    }
    
    private func signWithAppleView() -> some View{
        VStack {
            
            HStack(alignment: .center) {
                                
                Spacer()
                
                Button {
                    withAnimation {
                        showSheet.toggle()
                    }
                } label: {
                    Image("img_close")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding([.top, .trailing], 15)
            }
            
            if manager.userEmail.count == 0{
                
                Image(.icAppLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding()
                
                Text("Configure your Countdown Account.")
                    .padding(.bottom)
                
                SignInWithAppleButton(.signIn) { request in
                    let nonce = randomNonceString()
                    currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    
                    switch result {
                    case .success(let authResults):
                        showSheet.toggle()
                        print("Authorisation successful", authResults)
                        self.CompleteSignInWithApple(authResults: authResults)
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(width: 280, height: 45, alignment: .center)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.height(250)])
            }else{
                
                Image(.icAppLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding([.bottom])
                
                VStack(alignment: .leading) {
                    
                    Text("Email ")
                      .font(Font.custom("SF Pro Text", size: 18))
                      .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                    
                    Rectangle()
                        .overlay(alignment: .leading, content: {
                            HStack {
                                Text(manager.userEmail)
                                    .padding([.leading], 10)
                                    .foregroundStyle(.black)
                                Spacer()
                                Button(action: {
                                    self.showShareSheet = true
                                }) {
                                    Image("img_share")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding([.trailing], 20)
                                }
                                .sheet(isPresented: $showShareSheet) {
                                    ShareSheet(activityItems: [manager.userEmail])
                                }
                                
                            }
                        })
                        .foregroundStyle(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(9)
                        .frame(height: 50, alignment: .center)
//                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .padding([.bottom], 10)
                                        
                    Button(action: {
                        showSheet.toggle()
                        AppDelegate.sharedInstance.unsubscribe(topic: self.manager.userEmail.extractUsernameFromEmail() ?? "")
                        self.manager.userEmail = ""
                        AppDelegate.sharedInstance.logoutSetup()
                        try! Auth.auth().signOut()
                    }) {
                        Rectangle()
                            .overlay {
                                Text("Log out")
                                  .font(
                                    Font.custom("SF Pro Text", size: 17)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(.white)
                            }
                            .foregroundStyle(.black)
                            .cornerRadius(12)
                            .frame(height: 50, alignment: .center)
                    }
                    
                    Button(action: {
                        if let user = Auth.auth().currentUser{
                            showSheet.toggle()
                            AppDelegate.sharedInstance.unsubscribe(topic: self.manager.userEmail)
                            FirebaseEventModel().deleteUser(email: self.manager.userEmail)
                            self.manager.userEmail = ""
                            AppDelegate.sharedInstance.logoutSetup()
                            user.delete()
                        }
                    }) {
                        Rectangle()
                            .overlay {
                                Text("Delete Account")
                                  .font(
                                    Font.custom("SF Pro Text", size: 17)
                                      .weight(.semibold)
                                  )
                                  .foregroundColor(.red)
                                  .underline()
                                  .baselineOffset(4)
                            }
                            .foregroundStyle(.clear)
                            .cornerRadius(12)
                            .frame(height: 50, alignment: .center)
                    }
                }
                .padding([.leading, .trailing], 20)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.height(350)])
            }
            
        }
    }
    
    
    //ShareDialog
    private func shareDialogView() -> some View{
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        
                        Spacer()
                        
                        VStack(){
                            Text("Share your widget ")
                              .font(
                                Font.custom("SF Pro Text", size: 20)
                                  .weight(.bold)
                              )
                              .foregroundColor(.black)
                              .padding([.bottom], 5)
                            Text("Invite your friends to share reminder for your widget")
                              .font(
                                Font.custom("SF Pro Text", size: 13)
                                  .weight(.light)
                              )
                              .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                self.show = false
                            }
                        } label: {
                            Image("ic_close")
                            .frame(width: 27, height: 27)
                        }
                    }
                    .padding([.leading,.trailing])
                    .padding(.top, 30)

                    VStack(alignment: .leading, spacing: 5){
                        Text("Name")
                            .font(.title3)
                          .foregroundColor(Color(red: 0.41, green: 0.43, blue: 0.43))
                        CustomTextField(textVar: self.$fullName, placeholder: "Please enter your name", keyBoardType: .default)
                    }
                    .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("Email")
                            .font(.title3)
                          .foregroundColor(Color(red: 0.41, green: 0.43, blue: 0.43))
                        CustomTextField(textVar: self.$email, placeholder: "Please enter email", keyBoardType: .emailAddress)
                            
                    }
                    .padding([.leading, .trailing])

                    Button {
                        print("--- name : ", self.fullName)
                        print("--- email : ", self.email)
                        
                        if self.determineMessage().count == 0 {
                            self.showErrorPopupTop = false
                            
                            if let extractSharedUserName = self.email.lowercased().extractUsernameFromEmail(), 
                                let extractSharedCurrentUserName = manager.userEmail.lowercased().extractUsernameFromEmail() {
                                AppDelegate.sharedInstance.sentNotificationToSharedUser(email: extractSharedUserName, userName: extractSharedCurrentUserName)
                            }
                            FirebaseEventModel().sendData(email: self.email.lowercased(), eventModel: model)
                            self.fullName = ""
                            self.email = ""
                            withAnimation {
                                self.show = false
                            }
                        } else {
                            self.showErrorPopupTop = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9)
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.5, green: 0.81, blue: 1), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0, green: 0.56, blue: 0.91), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0),
                                        endPoint: UnitPoint(x: 0.5, y: 1)
                                    )
                                )
                            Text("Share")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                
                        }
                    }
                    .frame(width: 120, height: 50)
                    .padding(.bottom)
                }
                .background(Color.white)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)

    }
    
    private func reviewDialogView() -> some View {
        let titleFont = Font.system(size: 24).weight(.medium)
        
        let headerView = HStack(alignment: .top) {
            Spacer()
            
            VStack(spacing: 10) {
                Text("Rate us")
                    .font(titleFont)
                    .foregroundColor(.black)
                
                Text("Enjoying the Countdown App?")
                    .font(.system(size: 16).weight(.medium))
                    .foregroundColor(.black)
                
                Text("If you are enjoying our app. Please rate us")
                    .font(.system(size: 14).weight(.medium))
                    .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
            }
            .padding(.trailing)
            
            Button {
                withAnimation {
                    self.showRatingDialogView = false
                }
            } label: {
                Image("ic_close")
                .frame(width: 27, height: 27)
            }
        }
        .padding([.leading,.trailing])
        .padding(.top, 30)
        
        let contactUsButton = Button {
            if self.value3 <= 3 {
                if let description = self.description, description.trimmingCharacters(in: .whitespaces).count > 0 {
                    self.showMailView = true
                    let _ = Defaults[.isFirstReviewDone] = true
                } else {
                    self.showErrorPopupForRatingReview = true
                }
            } else {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6471045592" + "/?action=write-review") {
                    UIApplication.shared.open(url)
                    let _ = Defaults[.isFirstReviewDone] = true
                }
            }
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.5, green: 0.81, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0, green: 0.56, blue: 0.91), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                Text("Contact Us")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 120, height: 50)
        .padding(.bottom)
        
        return Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack(spacing: 20) {
                    headerView
                    content
                    if showDescription {
                        descriptionView
                    }
                    contactUsButton
                }
                .background(Color.white)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .sheet(isPresented: $showMailView) {
                MailView(content: "Rating : \(value3) \n\n\(description ?? "")", to: AdUnitId.feedbackEmailId)
            }
    }
    
    private var content: some View {
        let constant3 = ARConstant(rating: 5,
                                   size: CGSize(width: 30, height: 30),
                                   spacing: 10,
                                   fillMode: .half,
                                   axisMode: .horizontal,
                                   valueMode: .point)

        return Group {
            Group {
                VStack {
                    AxisRatingBar(value: $value3, constant: constant3) {
                        ARStar(count: round(starCount), innerRatio: 1)
                            .stroke()
                            .fill(Color.blue.opacity(0.6))
                    } foreground: {
                        ARStar(count: round(starCount), innerRatio: 1)
                            .fill(Color.blue)
                    }
                    .onChange(of: value3) {
                        showDescription = value3 <= 3
                    }
                }
            }
        }
    }
    
    private var descriptionView: some View {
        return ZStack(alignment: .topLeading) {
            Text(description ?? "Write review here...")
                .padding()
                .opacity(description == nil ? 1 : 0)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
            TextEditor(text: Binding($description, replacingNilWith: ""))
                .frame(minHeight: 30, alignment: .leading)
                .cornerRadius(6.0)
                .multilineTextAlignment(.leading)
                .padding(9)
                .foregroundStyle(.black)
                .scrollContentBackground(.hidden)
                .font(.system(size: 14))
        }
        .frame(height: 100)
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.82, green: 0.89, blue: 0.92), lineWidth: 1)
        )
        .padding([.leading, .trailing])
        .frame(height: 100)
    }
    
    private func openReviewPopup() {
        let currentDate = Date()
        
        let lastReviewDate = Calendar.current.date(byAdding: .day, value: Defaults[.ReviewCount], to: Defaults[.InstalationDate].toDate(dateFormate: "dd/MM/yy")) ?? Date()
        
        let lastReReviewDate = Calendar.current.date(byAdding: .day, value: Defaults[.ReReviewCount], to: Defaults[.InstalationDate].toDate(dateFormate: "dd/MM/yy")) ?? Date()

        print("AdUnitId.Review_Count : \(Defaults[.ReviewCount]), AdUnitId.Re_Review_Count : \(Defaults[.ReReviewCount])")
        print("currentDate: \(currentDate.shortDate)\nlastReviewDate: \(lastReviewDate.shortDate)\nlastReReviewDate: \(lastReReviewDate.shortDate)")
        if Defaults[.isFirstReviewDone] == false && currentDate > lastReviewDate {
            Defaults[.InstalationDate] = Date().shortDate
            self.showRatingDialogView = true
        } else if currentDate > lastReReviewDate {
            Defaults[.InstalationDate] = Date().shortDate
            self.showRatingDialogView = true
        }
    }
    
    /// Widget grid item preview
    private func GridItemView(for model: EventModel) -> some View {
        WidgetView(model: model)
            .cornerRadius(tileCornerRadius)
            .contentShape(.contextMenuPreview,
                          RoundedRectangle(cornerRadius: tileCornerRadius))
            .frame(height: tileHeight).overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: tileCornerRadius)
                        .opacity(manager.selectedWidgetId == model.id ? 0.4 : 0.0)
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30)).foregroundColor(.white)
                                .background(Circle().padding(5))
                                .opacity(manager.selectedWidgetId == model.id ? 1.0 : 0.0)
                        }
                        Spacer()
                    }.padding(10)
                }
            ).contextMenu {
                VStack {
                    
                    Button(role: .cancel) {
                        if manager.userEmail.count == 0 {
                            self.showSheet = true
                        } else {
                            self.id = model.id
                            self.model = model
                            self.show.toggle()
                        }
                        //                        self.shareWidgetPopUp = true
                        
                    } label: {
                        Label("Share Widget", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        manager.deleteWidget(withId: model.id)
                    } label: {
                        Label("Delete Widget", systemImage: "trash")
                    }
                }
            }.onTapGesture {
                manager.selectedWidgetId = model.id
                WidgetCenter.shared.reloadAllTimelines()
            }
    }
    
    /// Show the widget creator flow
    private var AddWidgetButton: some View {
        Button {
            if !manager.isPremiumUser && manager.createdWidgetsCount >= AppConfig.freeWidgetsCount {
                manager.fullScreenMode = .premium
            } else {
                showWidgetCreator = true
            }
        } label: {
            ZStack {
                LinearGradient(colors: [.gray.opacity(0.7), .gray], startPoint: .top, endPoint: .bottom)
                VStack {
                    Image(systemName: "plus")
                        .font(.system(size: 42, weight: .semibold))
                    Text("Create\nWidget Event").font(.system(size: 18))
                }.foregroundColor(.white)
            }.cornerRadius(tileCornerRadius)
        }.frame(height: tileHeight)
    }
        
    /// Filter widget events based on the search query
    private var filteredEvents: [EventModel] {
        guard !searchQuery.isEmpty else { return manager.eventsArr }
        return manager.eventsArr.filter({ $0.title.lowercased().starts(with: searchQuery.lowercased()) })
    }
    
    
    //Error Message
    private func determineMessage() -> String {
        if self.fullName.isEmpty && self.email.isEmpty {
            return "In order to share a widget with your friend, please enter your name and email."
        } else if self.fullName.isEmpty {
            return "In order to share a widget with your friend, please enter your name."
        } else if self.email.isEmpty {
            return "In order to share a widget with your friend, please enter your email."
        } else if !self.email.isValidEmail() {
            return "Please enter a valid email."
        } else {
            return ""
        }
    }
    
    private func determineMessageForRatingReview() -> String {
        if self.description == nil {
            return "Please enter your review!"
        } else if let description = self.description, description.trimmingCharacters(in: .whitespaces).count == 0 {
            return "Please enter your review!"
        }else {
            return ""
        }
    }
    
    /// Columns configuration for the grid
    private var columnsConfiguration: [GridItem] {
        Array(repeating: GridItem(spacing: padding), count: 2)
    }
    
    /// Grid tile/widget height
    private var tileHeight: Double {
        (UIScreen.main.bounds.width / 2.0) - (padding * 2.0) + padding / 2.0
    }
    
    func actionSheet(email: String) {
        let av = UIActivityViewController(activityItems: [email], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func CompleteSignInWithApple(authResults: ASAuthorization){
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                if let result = authResult, let email = result.user.email, email.count > 0{
                    if let atIndex = email.firstIndex(of: "@") {
                        let username = String(email.prefix(upTo: atIndex))
                        print("--- email : ", username)
                        AppDelegate.sharedInstance.subscribe(topic: username)
                    }
                    manager.userEmail = email
                    FirebaseEventModel().createUser(email: manager.userEmail)
                    FirebaseEventModel().fetchData(email: manager.userEmail, manager: manager)
                }
                
            }
            
            print("\(String(describing: Auth.auth().currentUser?.uid))")
        default:
            break
            
        }
    }
}

// MARK: - Preview UI
struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manage = DataManager()
        manage.getAllObjects()
        return DashboardContentView(manager: manage, rating: .constant(0.0))
    }
}

struct ShareSheet: UIViewControllerRepresentable {

    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
