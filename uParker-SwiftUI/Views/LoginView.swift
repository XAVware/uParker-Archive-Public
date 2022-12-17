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
            
            VStack {
                Image("uParker-Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding()
                
                UnderlinedTextField(text: $username, placeholder: "Username", icon: "person.fill")
                    
                UnderlinedTextField(text: $password, placeholder: "Password", icon: "lock", isSecure: true)
                    
                
                
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
