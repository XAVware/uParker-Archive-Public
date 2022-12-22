//
//  SignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/17/22.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isShowingSignUp: Bool
    
    @State var firstName: String        = ""
    @State var email: String            = ""
    @State var optInNewsletter: Bool    = false
    @State var phoneNumber: String      = ""
    @State var password: String         = ""
    @State var confirmPassword: String  = ""
    @State var viewCounter: Int         = 1
    
    var headerText: String {
        switch (viewCounter) {
        case 0:
            return "What is your name?"
        case 1:
            return "What is your email?"
        case 2:
            return "What is your phone number?"
        case 3:
            return "Enter a password."
        default:
            return "Error"
        }
    }
    
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 70) {
                Text(headerText)
                    .foregroundColor(primaryColor)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack {
                    switch (viewCounter) {
                    case 0:
                        UnderlinedTextField(text: $firstName, placeholder: "First Name", icon: "person.fill", fgColor: primaryColor, showsIcon: false)
                    case 1:
                        UnderlinedTextField(text: $email, placeholder: "Email Address", icon: "person.fill", fgColor: primaryColor, showsIcon: false)
                        
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
                        }
                        .padding()
                        
                    case 2:
                        UnderlinedTextField(text: $phoneNumber, placeholder: "xxx-xxx-xxxx", icon: "person.fill", fgColor: primaryColor, showsIcon: false)

                    default:
                        UnderlinedTextField(text: $firstName, placeholder: "Error", icon: "person.fill", fgColor: primaryColor, showsIcon: false)

                    }
                }
                .padding()
                .frame(maxHeight: 500)
                
                Spacer()
                
                Button {
                    self.viewCounter += 1
                } label: {
                    Text("Next")
                        .font(.title)
                        .foregroundColor(secondaryColor)
                        .fontWeight(.light)
                        .padding()
                }
                .modifier(ButtonModifier(
                    type: .primaryFill,
                    minWidth: 150, idealWidth: 300, maxWidth: 350,
                    minHeight: 40, idealHeight: 50, maxHeight: 50,
                    alignment: .center)
                )

                Spacer()
                
            } //: VStack
            .frame(maxHeight: 400)
            .padding()
            .navigationTitle(Text("Sign Up"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewCounter == 0 {
                            self.isShowingSignUp.toggle()
                        } else if viewCounter == 3 {
                            self.isShowingSignUp.toggle()
                        } else {
                            viewCounter -= 1
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                        
                        Text("Back")
                    }
                }
            }
            .tint(primaryColor)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isShowingSignUp: Bool = true
    static var previews: some View {
        SignUpView(isShowingSignUp: $isShowingSignUp)
    }
}
