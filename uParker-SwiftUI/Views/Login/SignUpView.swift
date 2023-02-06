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
        NavigationView {
            VStack(spacing: 24) {
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
                .padding(.vertical)
                
                NavigationLink {
                    AddPhoneView()
                        .environmentObject(sessionManager)
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                
                AuthOptionsPanel()
                
                Spacer()
                
            } //: VStack
            .padding(.horizontal)
            .onTapGesture {
                focusField = nil
            }
        } //: NavigationView
    }
}

// MARK: - PREVIEW
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(SessionManager())
    }
}
