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
    @State var isShowingLoginModal: Bool = false
    
    let title: String
    let mainHeadline: String
    let mainDetail: String
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .modifier(PageTitleModifier())
                    .padding(.bottom, 20)
                
                Text(mainHeadline)
                    .font(.headline)
                    .fontDesign(.rounded)
                
                Text(mainDetail)
                    .font(.subheadline)
                    .fontDesign(.rounded)
            } //: VStack
            
            VStack(spacing: 20) {
                ContinueButton(text: "Log In") {
                    self.isShowingLoginModal.toggle()
                }
                
                HStack(spacing: 8) {
                    Text("Don't have an account?")
                        .font(.callout)
                        .fontDesign(.rounded)
                    
                    Button {
                        self.isShowingLoginModal.toggle()
                    } label: {
                        Text("Sign Up").underline()
                            .font(.callout)
                            .fontDesign(.rounded)
                    }
                    .buttonStyle(PlainButtonStyle())
                } //: VStack - Sign Up
            } //: VStack - Login/Sign up
        } //: VStack
        .sheet(isPresented: self.$isShowingLoginModal) {
            LoginSignUpView()
                .environmentObject(sessionManager)
        }
    }
}

// MARK: - PREVIEW
struct NeedLoginView_Previews: PreviewProvider {
    static let title: String = "Profile"
    static let headline: String = "Tell us about yourself"
    static let subheadline: String = "You need to log in before you can reserve parking"
    
    static var previews: some View {
        NeedLoginView(title: title, mainHeadline: headline, mainDetail: subheadline)
            .environmentObject(SessionManager())
            .previewLayout(.sizeThatFits)
    }
}
