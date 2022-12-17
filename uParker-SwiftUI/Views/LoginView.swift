//
//  LoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            primaryColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Image("uParker-Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding()
                
                UnderlinedTextField(text: $username, placeholder: "Username", icon: "person.fill")
                    
                UnderlinedTextField(text: $password, placeholder: "Password", icon: "lock", isSecure: true)
                    
                Button {
                    //
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
                        minWidth: 150,
                        idealWidth: 300,
                        maxWidth: 350,
                        minHeight: 40,
                        idealHeight: 50,
                        maxHeight: 50,
                        alignment: .center)
                )

                Button {
                    //
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
                        minWidth: 150,
                        idealWidth: 200,
                        maxWidth: 250,
                        minHeight: 40,
                        idealHeight: 50,
                        maxHeight: 50,
                        alignment: .center)
                )
                
                Spacer()
                
            } //: VStack
            .padding()
        } //: ZStack
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
