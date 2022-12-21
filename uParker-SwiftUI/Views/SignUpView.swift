//
//  SignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/17/22.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isShowingSignUp: Bool
    
    @State var firstName: String = ""
    
    var viewCounter: Int = 0
    
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 70) {
                Text("What is your name?")
                    .foregroundColor(primaryColor)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    
                switch (viewCounter) {
                case 0:
                    UnderlinedTextField(text: $firstName, placeholder: "First Name", icon: "person.fill", fgColor: primaryColor, showsIcon: false)
                    
                default:
                    UnderlinedTextField(text: $firstName, placeholder: "First Name", icon: "person.fill", fgColor: primaryColor, showsIcon: false)
                }
                
                
                Button {
                    
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
                        self.isShowingSignUp.toggle()
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
