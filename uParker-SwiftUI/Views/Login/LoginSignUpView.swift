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
    @State private var isShowingConfirmation: Bool = false
    
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
            
            Divider()
                        
            // MARK: - TOP TEXTFIELD
            VStack {
                switch(loginMethod) {
                case .phone:
                    AnimatedTextField(boundTo: $phoneNumber, placeholder: "Phone Number")
                        .padding(.top, 20)
                        .keyboardType(.numberPad)
                        .focused($focusField, equals: .phoneEmail)
                        .submitLabel(.continue)
                        .onChange(of: phoneNumber, perform: {
                            phoneNumber = String($0.prefix(14)).applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                        })
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
                    focusField = nil
                    print(email)
                    isShowingConfirmation = true
                }
                
                // MARK: - DIVIDER
                HStack {
                    Rectangle()
                        .frame(height: 1)
                    
                    Text("OR")
                        .font(.footnote)
                        .fontDesign(.rounded)
                    
                    Rectangle()
                        .frame(height: 1)
                } //: HStack
                .frame(height: 10)
                .foregroundColor(.gray)
                .padding(20)
                
                // MARK: - AUTH W/ EMAIL/PHONE
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
                
                // MARK: - AUTH W/ APPLE BTN
                ContinueWithButton(icon: Image(systemName: "apple.logo"), text: "Continue with Apple") {
                    //
                }
                .padding(.vertical, 4)
                
                // MARK: - AUTH W/ GOOGLE BTN
                ContinueWithButton(icon: Image("GoogleIcon"), text: "Continue with Google") {
                    //
                }
                .padding(.vertical, 4)
                    
                Spacer()
                
            } //: VStack - Main Stack
            .padding()
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
            
        } //: VStack
        .onTapGesture {
            focusField = nil
        }
        .sheet(isPresented: $isShowingConfirmation) {
            if self.loginMethod == .phone {
                ConfirmPhoneView(phoneNumber: phoneNumber)
                    .environmentObject(sessionManager)
            } else {
                ConfirmEmailView(email: email)
                    .environmentObject(sessionManager)
            }
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
