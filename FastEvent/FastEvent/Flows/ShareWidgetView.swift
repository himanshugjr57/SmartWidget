//
//  ShareWidgetView.swift
//  FastEvent
//
//  Created by Social Development on 06/12/23.
//

import SwiftUI

struct ShareWidgetView: View {
    
    @Binding var show: Bool
    @State var id: String?
    @State private var fullName = ""
    @State private var email = ""
    @State private var showErrorPopupTop: Bool = true
    let manager: EventModel

    var body: some View {
        if show {
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
                                
                                if let extractSharedUserName = self.email.lowercased().extractUsernameFromEmail(), let extractSharedCurrentUserName = DataManager().userEmail.lowercased().extractUsernameFromEmail() {
                                    AppDelegate.sharedInstance.sentNotificationToSharedUser(email: extractSharedUserName, userName: extractSharedCurrentUserName)
                                }
                                FirebaseEventModel().sendData(email: self.email.lowercased(), eventModel: manager)
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
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
        }
    }
    
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
}

#Preview {
    ShareWidgetView(show: .constant(true), manager: EventModel(data: [:]))
}

//MARK: - THIS IS FOR NORMAL TEXTFIELD
struct CustomTextField : View {
    @Binding var textVar : String
    var placeholder : String
    var keyBoardType: UIKeyboardType
    
    var body: some View {
        TextField(self.placeholder, text: self.$textVar)
            .padding()
            .keyboardType(self.keyBoardType)
            .foregroundColor(.black)
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.82, green: 0.89, blue: 0.92), lineWidth: 1)
            )
    }
}
