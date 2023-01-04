//
//  LoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

/*
 
 
import SwiftUI

struct LoginView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username: String = ""
    @State var password: String = ""
        
    var body: some View {
        ZStack {
            backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - LOGIN STACK
            VStack(spacing: 40) {
                //LOGO
                Image("uParker-Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding()
                
                Spacer()
                
                //USERNAME
                UnderlinedTextField(
                    text: $username,
                    placeholder: "Username",
                    icon: "person.fill"
                )
                
                //PASSWORD
                UnderlinedTextField(
                    text: $password,
                    placeholder: "Password",
                    icon: "lock",
                    isSecure: true
                )
                
                Spacer()
                
                //LOGIN
                Button {
                    sessionManager.isLoggedIn = true
                } label: {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(primaryColor)
                        .fontWeight(.light)
                        .padding()
                }
                .modifier(
                    ButtonModifier(
                        type: .secondaryFill,
                        minWidth: 150, idealWidth: 300, maxWidth: 350,
                        minHeight: 40, idealHeight: 50, maxHeight: 50,
                        alignment: .center)
                )
                
                //SIGN UP
                Button {
                    sessionManager.isShowingSignUp.toggle()
                } label: {
                    Text("Sign Up")
                        .font(.title)
                        .foregroundColor(secondaryColor)
                        .fontWeight(.light)
                        .padding()
                }
                .modifier(
                    ButtonModifier(
                        type: .secondaryBorder,
                        minWidth: 150, idealWidth: 200, maxWidth: 250,
                        minHeight: 40, idealHeight: 50, maxHeight: 50,
                        alignment: .center)
                )
                
                Button {
                    // Forgot Password
                } label: {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                        .fontWeight(.medium)
                        .padding()
                }
            } //: VStack
            .padding()
            
            if sessionManager.isShowingSignUp {
                SignUpView()
                    .environmentObject(sessionManager)
            }
        } //: ZStack
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionManager())
    }
}

*/