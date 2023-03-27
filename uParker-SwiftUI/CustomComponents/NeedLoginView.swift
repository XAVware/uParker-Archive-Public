//
//  NeedLoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct NeedLoginView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
//    let title: String
    let mainHeadline: String
    let mainDetail: String
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack(alignment: .leading, spacing: 10) {
//                Text(title)
//                    .modifier(TextMod(.largeTitle, .semibold))
//                    .padding(.bottom, 20)
                
                Text(mainHeadline)
                    .modifier(TextMod(.headline, .semibold))
                
                Text(mainDetail)
                    .modifier(TextMod(.callout, .regular))
            } //: VStack
            
            VStack(spacing: 20) {
                Button {
                    sessionManager.isShowingLoginView = true
                } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                
                HStack(spacing: 8) {
                    Text("Don't have an account?")
                        .modifier(TextMod(.callout, .regular))
                    
                    Button {
                        sessionManager.isShowingSignUpView = true
                    } label: {
                        Text("Sign Up").underline()
                            .modifier(TextMod(.callout, .regular))
                    }
                    .buttonStyle(PlainButtonStyle())
                } //: VStack - Sign Up
            } //: VStack - Login/Sign up
        } //: VStack
        .fullScreenCover(isPresented: $sessionManager.isShowingLoginView) {
            LoginView()
                .environmentObject(sessionManager)
                .ignoresSafeArea(.keyboard)
        }
//        .fullScreenCover(isPresented: $sessionManager.isShowingSignUpView) {
//            SignUpView()
//                .environmentObject(sessionManager)
//                .ignoresSafeArea(.keyboard)
//        }
    }
}

// MARK: - PREVIEW
struct NeedLoginView_Previews: PreviewProvider {
    static let title: String = "Profile"
    static let headline: String = "Tell us about yourself"
    static let subheadline: String = "You need to log in before you can reserve parking"
    
    static var previews: some View {
        NeedLoginView(mainHeadline: headline, mainDetail: subheadline)
            .environmentObject(SessionManager())
            .previewLayout(.sizeThatFits)
    }
}
