//
//  LoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct LoginView: View {
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
        VStack(spacing: 24) {
            HeaderView(leftItem: .xmark, title: "Log In", rightItem: nil)
            
            VStack {
                AnimatedTextField(boundTo: $email, placeholder: "Email Address")
                    .modifier(EmailFieldMod())
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = nil
                    }
                    .onTapGesture {
                        focusField = .email
                }
                
                AnimatedTextField(boundTo: $password, placeholder: "Password", isSecure: true)
            } //: VStack
            .padding(.vertical)
            
            Button {
                focusField = nil
                sessionManager.logIn()
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
