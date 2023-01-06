//
//  ProfileView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 50) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Profile")
                        .modifier(PageTitleModifier())
                    
                    Text("Login to reserve parking.")
                        .font(.title3)
                } //: VStack
                .padding(.top)
                
                
                
                if sessionManager.isLoggedIn {
                    Text("Is Logged In")
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        ContinueButton(text: "Log In") {
                            //
                        }
                        
                        HStack {
                            Text("Don't have an account?")
                                .font(.callout)
                            
                            Button {
                                
                            } label: {
                                Text("Sign Up").underline()
                                    .font(.callout)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } //: VStack
                    
                    
                    
                }
                
                Spacer()
            } //: VStack
            .padding()
            .navigationBarBackButtonHidden()
        } //: Navigation View
    }
}
// MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionManager())
    }
}
