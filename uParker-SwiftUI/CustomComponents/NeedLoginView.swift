//
//  NeedLoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct NeedLoginView: View {
//    @EnvironmentObject var sessionManager: SessionManager
    
    enum Sources { case reservations, chat, profile }
    let source: Sources
    
    @Binding var isShowingLoginView: Bool
    
//    let title: String
    var mainHeadline: String {
        switch source {
        case .reservations:
            return "Login to view your reservations"
        case .chat:
            return "Login to view conversations"
        case .profile:
            return "Tell us about yourself"
        }
    }
    
    var mainDetail: String {
        switch source {
        case .reservations:
            return "Once you login, your upcoming and past reservations will appear here."
        case .chat:
            return "Once you login, your message inbox will appear here."
        case .profile:
            return "You need to log in before you can reserve parking"
        }
    }
    
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
                    isShowingLoginView = true
                } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                
                HStack(spacing: 8) {
                    Text("Don't have an account?")
                        .modifier(TextMod(.callout, .regular))
                    
                    Button {
                        isShowingLoginView = true
                    } label: {
                        Text("Sign Up").underline()
                            .modifier(TextMod(.callout, .regular))
                    }
                    .buttonStyle(PlainButtonStyle())
                } //: VStack - Sign Up
            } //: VStack - Login/Sign up
        } //: VStack
//        .fullScreenCover(isPresented: $sessionManager.isShowingLoginView) {
//            LoginView()
//                .environmentObject(sessionManager)
//                .ignoresSafeArea(.keyboard)
//        }
    }
}

// MARK: - PREVIEW
struct NeedLoginView_Previews: PreviewProvider {
    @State static var isShowing: Bool = false
    static var previews: some View {
        NeedLoginView(source: .profile, isShowingLoginView: $isShowing)
//            .environmentObject(SessionManager())
            .previewLayout(.sizeThatFits)
    }
}
