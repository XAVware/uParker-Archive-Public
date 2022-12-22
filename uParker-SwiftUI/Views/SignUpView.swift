//
//  SignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/17/22.
//

import SwiftUI

struct SignUpView: View {
    // MARK: - PROPERTIES
    @Binding var isShowingSignUp: Bool
    
    @State var firstName: String        = ""
    @State var lastName: String         = ""
    @State var email: String            = ""
    @State var optInNewsletter: Bool    = false
    @State var phoneNumber: String      = ""
    @State var password: String         = ""
    @State var confirmPassword: String  = ""
    @State var viewCounter: Int         = 2
    
    
    var body: some View {
        NavigationView {
            VStack {
                switch (viewCounter) {
                // MARK: - NAME
                case 0:
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
                case 1:
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
                case 2:
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
                case 3:
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
                    
                default:
                    UnderlinedTextField(text: $firstName, placeholder: "Error", icon: "person.fill", fgColor: primaryColor, showsIcon: false)
                    
                }
                                
                Button {
                    self.viewCounter += 1
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
                        backTapped()
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
        
    }
    
    func backTapped() {
        if viewCounter == 0 {
            self.isShowingSignUp.toggle()
        } else if viewCounter == 3 {
            self.isShowingSignUp.toggle()
        } else {
            viewCounter -= 1
        }
    }
} //: Struct


// MARK: - PREVIEW
struct SignUpView_Previews: PreviewProvider {
    @State static var isShowingSignUp: Bool = true
    static var previews: some View {
        SignUpView(isShowingSignUp: $isShowingSignUp)
    }
}
