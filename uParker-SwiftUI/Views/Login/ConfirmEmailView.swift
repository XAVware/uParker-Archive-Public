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
    @FocusState private var focusField: FocusText?
    @State var email: String
    @State var password: String = ""
    
    enum FocusText { case confirmationCode }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HeaderView(leftItem: .chevron, title: "Log In", rightItem: nil)
            
            VStack {
                Text("We found your account!")
                    .font(.callout)
                    .fontDesign(.rounded)
                
                Text("Please sign in.")
                    .font(.footnote)
                    .fontDesign(.rounded)
            }
            .padding(.vertical)
            
            AnimatedTextField(boundTo: $email, placeholder: "Email")
            
            AnimatedTextField(boundTo: $password, placeholder: "Password", isSecure: true)
            
            Spacer()
            
            
        }
        .padding()
    }
}

// MARK: - PREVIEW
struct ConfirmEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmEmailView(email: "ryansmetana@gmail.com")
    }
}
