//
//  SignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct SignUpView: View {
    // MARK: - PROPERTEIS
    @EnvironmentObject var sessionManager: SessionManager
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusField: FocusText?
    enum FocusText { case email }
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 32) {
            HeaderView(leftItem: .xmark, title: "Sign Up", rightItem: nil)
                .padding(.top)
                .ignoresSafeArea(.keyboard)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    AnimatedTextField(boundTo: $firstName, placeholder: "First Name")
                    
                    AnimatedTextField(boundTo: $lastName, placeholder: "Last Name")
                } //: HStack
                
                AnimatedTextField(boundTo: $email, placeholder: "Email Address")
                    .modifier(EmailFieldMod())
                    .focused($focusField, equals: .email)
                
                AnimatedTextField(boundTo: $password, placeholder: "Password", isSecure: true)
            } //: VStack
            
            ContinueButton(text: "Continue") {
                focusField = nil
            }
            .padding(.vertical)
            
            Spacer()
            
        } //: VStack
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(SessionManager())
    }
}
