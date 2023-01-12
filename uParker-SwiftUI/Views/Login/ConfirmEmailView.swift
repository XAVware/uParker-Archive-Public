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
            
            VStack {
                Text("We found your account!")
                    .font(.callout)
                    .fontDesign(.rounded)
                
                Text("Please sign in. \(emailAddress)")
                    .font(.footnote)
                    .fontDesign(.rounded)
            } //: VStack
            .padding(.vertical)
            
            AnimatedTextField(boundTo: $emailAddress, placeholder: "Email Address")
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
