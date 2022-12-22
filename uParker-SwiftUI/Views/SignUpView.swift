//
//  SignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/17/22.
//

import SwiftUI

struct SignUpView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
//    @Binding var isShowingSignUp: Bool
    
    enum SignUpViews { case name, email, phone, password}
    
    @State var currentView: SignUpViews = .name
    
    @State var firstName: String        = ""
    @State var lastName: String         = ""
    @State var email: String            = ""
    @State var optInNewsletter: Bool    = false
    @State var phoneNumber: String      = ""
    @State var password: String         = ""
    @State var confirmPassword: String  = ""
    
    var body: some View {
        NavigationView {
            VStack {
                switch (currentView) {
                // MARK: - NAME
                case .name:
                    VStack(spacing: 60) {
                        Text("What is your name?")
                            .foregroundColor(primaryColor)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        UnderlinedTextField(text: $firstName, placeholder: "First Name", fgColor: primaryColor)
                        
                        UnderlinedTextField(text: $lastName, placeholder: "Last Name", fgColor: primaryColor)
                        
                        Spacer()
                    } //: VStack
                    .padding()
                    
                // MARK: - EMAIL
                case .email:
                    VStack(spacing: 60) {
                        Text("What is your email?")
                            .foregroundColor(primaryColor)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        UnderlinedTextField(text: $email, placeholder: "Email Address", fgColor: primaryColor)
                        
                        Button {
                            self.optInNewsletter.toggle()
                        } label: {
                            Image(systemName: optInNewsletter ? "checkmark.square.fill" : "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(primaryColor)
                            
                            Text("I want to receive newsletters")
                                .font(.subheadline)
                                .foregroundColor(primaryColor)
                        } //: Opt In Button
                        
                        Spacer()
                    } //: VStack
                    .padding()
                    
                // MARK: - PHONE NUMBER
                case .phone:
                    VStack(spacing: 60) {
                        Text("What is your phone number?")
                            .multilineTextAlignment(.center)
                            .foregroundColor(primaryColor)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        UnderlinedTextField(text: $phoneNumber, placeholder: "xxx-xxx-xxxx", fgColor: primaryColor)
                        
                        Spacer()
                    } //: VStack
                    .padding()
                    
                // MARK: - PASSWORD
                case .password:
                    VStack(spacing: 60) {
                        Text("Enter a Password")
                            .foregroundColor(primaryColor)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        UnderlinedTextField(text: $password, placeholder: "Password", fgColor: primaryColor)
                        
                        UnderlinedTextField(text: $confirmPassword, placeholder: "Confirm Password", fgColor: primaryColor)
                        
                        Spacer()
                    } //: VStack
                    .padding()
                    
                } //: Switch
                                
                Button {
                    nextTapped()
                } label: {
                    Text("Next")
                        .font(.title)
                        .foregroundColor(secondaryColor)
                        .fontWeight(.light)
                }
                .modifier(ButtonModifier(
                    type: .primaryFill,
                    minWidth: 150, idealWidth: 300, maxWidth: 350,
                    minHeight: 40, idealHeight: 50, maxHeight: 50,
                    alignment: .center)
                )
                .padding()
                                
            } //: VStack
            .padding()
            .navigationTitle(Text("Sign Up"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.backTapped()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                        
                        Text("Back")
                    }
                } //: Back Button
            } //: Toolbar
            .tint(primaryColor)
        }
    } //: Body
    
    
    // MARK: - FUNCTIONS
    func nextTapped() {
        switch (currentView) {
        case .name:
            currentView = .email
        case .email:
            //If opts in to newsletter, add email to email list. Not included in User table
            currentView = .phone
        case .phone:
            currentView = .password
        case .password:
            sessionManager.isShowingSignUp.toggle()
        }
    }
    
    func backTapped() {
        switch (currentView) {
        case .name:
            sessionManager.isShowingSignUp.toggle()
        case .email:
            currentView = .name
        case .phone:
            currentView = .email
        case .password:
            currentView = .phone
        }
    }
    
} //: Struct


// MARK: - PREVIEW
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(SessionManager())
    }
}
