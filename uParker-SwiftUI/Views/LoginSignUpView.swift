//
//  LoginSignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct LoginSignUpView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @FocusState private var focusField: FocusText?
    
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var loginMethod: LoginMethod = .phone
    
    enum FocusText { case phoneEmail }
    enum LoginMethod { case phone, email }
    
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var isOptingPhone: Bool {
        return loginMethod == .phone ? true : false
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HeaderView(leftItem: .xmark, title: "Log In or Sign Up", rightItem: nil)
                .padding(.horizontal)
                .padding(.top)
                .ignoresSafeArea(.keyboard)

            
//            HStack(alignment: .center) {
//                Button {
//                    dismiss.callAsFunction()
//                } label: {
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .scaledToFit()
//                        .fontWeight(.light)
//                        .frame(width: 16)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .padding(.horizontal)
//
//
//                Text("Log In or Sign Up")
//                    .font(.title3)
//                    .fontDesign(.rounded)
//                    .frame(maxWidth: .infinity)
//
//
//                Spacer()
//                    .frame(width: 16)
//                    .padding(.horizontal)
//
//            } //: HStack
//            .frame(height: 30)
            
            Divider()
                        
            // MARK: - MAIN STACK
            VStack {
                switch(loginMethod) {
                case .phone:
                    AnimatedTextField(boundTo:$phoneNumber, placeholder: "Phone Number")
                        .padding(.top, 20)
                        .keyboardType(.numberPad)
                        .focused($focusField, equals: .phoneEmail)
                        .submitLabel(.continue)
                        .onSubmit {
                            focusField = nil
                        }
                        .onTapGesture {
                            focusField = .phoneEmail
                        }
                    
                    Text("We'll call or text to confirm your number. Standard message and data rates apply.")
                        .font(.caption)
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    
                case .email:
                    AnimatedTextField(boundTo: $email, placeholder: "Email Address")
                        .padding(.vertical, 20)
                        .keyboardType(.emailAddress)
                        .focused($focusField, equals: .phoneEmail)
                        .submitLabel(.continue)
                        .onSubmit {
                            focusField = nil
                        }
                        .onTapGesture {
                            focusField = .phoneEmail
                        }
                }
                
                ContinueButton(text: "Continue") {
                    //
                }
                
                
                LoginViewDivider()
                    .padding(20)
                
                ContinueWithButton(icon: Image(systemName: loginMethod == .phone ? "envelope" : "phone.fill"), text: loginMethod == .phone ? "Continue with Email" : "Continue with Phone") {
                    self.haptic.impactOccurred()
                    withAnimation {
                        if self.loginMethod == .phone {
                            self.loginMethod = .email
                        } else {
                            self.loginMethod = .phone
                        }
                    }
                }
                .padding(.vertical, 4)
                
                ContinueWithButton(icon: Image(systemName: "apple.logo"), text: "Continue with Apple") {
                    //
                }
                .padding(.vertical, 4)
                
                ContinueWithButton(icon: Image("GoogleIcon"), text: "Continue with Google") {
                    //
                }
                .padding(.vertical, 4)
                    
                Spacer()
                
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("You can ")
                        
                        Button {
                            self.dismiss.callAsFunction()
                        } label: {
                            Text("skip this").underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text(" for now, but")

                    }
                    
                    Text("you will need to log in to reserve parking.")
                }
                .font(.footnote)
                    
            } //: VStack - Main Stack
            .padding()
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
            
        } //: VStack
        .onTapGesture {
            focusField = nil
        }
    } //: Body
} //: Struct

// MARK: - PREVIEW
struct LoginSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpView()
            .environmentObject(SessionManager())
    }
}
