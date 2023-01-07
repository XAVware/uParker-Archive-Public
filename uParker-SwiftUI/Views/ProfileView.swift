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
            VStack {
                HeaderView(leftItem: nil, title: nil, rightItem: nil)
                
                NeedLoginView(title: "Profile", mainHeadline: "Tell us about yourself", mainDetail: "You need to log in before you can reserve parking")
                
                Spacer().frame(maxHeight: .infinity)
                
                Group {
                    SettingsButton(image: Image(systemName: "info.circle"), text: "More Info")
                    
                    Divider()
                    
                    SettingsButton(image: nil, text: "Privacy Policy")
                    
                    Divider()
                    
                    SettingsButton(image: nil, text: "Terms & Conditions")
                    
                    Divider()
                    
                    Text("Version 2.0.1")
                        .modifier(SettingsButtonModifier())
                        .frame(height: 50)
                    
                }
                
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
