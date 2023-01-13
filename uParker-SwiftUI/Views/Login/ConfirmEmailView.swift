//
//  ConfirmEmailView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/12/23.
//

import SwiftUI

struct ConfirmEmailView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var emailAddress: String
    @State var password: String = ""
    
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HeaderView(leftItem: .chevron, title: "Log In", rightItem: nil)
            
            VStack(alignment: .leading) {
                Text("Email Address:")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(emailAddress)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
            } //: VStack
            .padding()
            
//            AnimatedTextField(boundTo: $emailAddress, placeholder: "Email Address")
            
            AnimatedTextField(boundTo: $password, placeholder: "Password", isSecure: true)
            
            Spacer()
        } //: VStack
        .padding()
    }
}

struct ConfirmEmailView_Previews: PreviewProvider {
    @State static var email: String = "ryansmetana@gmail.com"
    static var previews: some View {
        ConfirmEmailView(emailAddress: $email)
    }
}
