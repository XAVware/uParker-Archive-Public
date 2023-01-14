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
            VStack(alignment: .leading) {
                HeaderView(leftItem: nil, title: nil, rightItem: nil)

                
                if sessionManager.isLoggedIn == false {
                    NeedLoginView(title: "Profile", mainHeadline: "Tell us about yourself", mainDetail: "You need to log in before you can reserve parking")
                    
                    Spacer().frame(maxHeight: .infinity)
                    
                    Group {
                        SettingsButton(image: Image(systemName: "info.circle"), text: "More Info")
                        
                        Divider()
                        
                        SettingsButton(image: Image(systemName: "doc.text.magnifyingglass"), text: "Privacy Policy")
                        
                        Divider()
                        
                        SettingsButton(image: Image(systemName: "doc.text.magnifyingglass"), text: "Terms & Conditions")
                        
                        Divider()
                        
                        Text("Version 2.0.1")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        
                        
                    } //: Group
                } else {
                    Spacer()
                }
                    
            } //: VStack
            .padding()
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
