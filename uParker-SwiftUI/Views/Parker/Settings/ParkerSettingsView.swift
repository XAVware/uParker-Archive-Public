//
//  ParkerSettingsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ParkerSettingsView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderView(leftItem: nil, title: nil, rightItem: nil)
                    
                    if !sessionManager.isLoggedIn {
                        NeedLoginView(title: "Profile", mainHeadline: "Tell us about yourself", mainDetail: "You need to log in before you can reserve parking")
                    }
                    
                    if sessionManager.isLoggedIn {
                        // MARK: - PROFLIE
                        Group {
                            Text("Profile")
                                .modifier(PageTitleModifier())
                            
                            NavigationLink {
                                ProfileView()
                            } label: {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .padding(10)
                                    .foregroundColor(.gray)
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.gray, lineWidth: 0.5)
                                    )
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Ryan")
                                        .font(.title3)
                                    
                                    
                                    
                                    Text("Show Profile")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                } //: VStack
                                .padding(.horizontal, 10)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal)
                            
                            Divider()
                        } //: Group - Profile
                        
                        // MARK: - ACCOUNT
                        Group {
                            Text("Account")
                                .modifier(SettingsCategoryHeaderMod())
                            
                            SettingsButton(image: Image(systemName: "dollarsign.circle"), text: "Payment Methods")
                            
                            Divider()
                            
                            SettingsButton(image: Image(systemName: "car"), text: "Vehicles")
                            
                            Divider()
                            
                            SettingsButton(image: Image(systemName: "bell"), text: "Notifications")
                        } //: Group - Account
                        
                        // MARK: - HOST
                        Group {
                            Text("Host")
                                .modifier(SettingsCategoryHeaderMod())
                            
                            SettingsButton(image: Image(systemName: "arrowshape.zigzag.right"), text: "Switch to Hosting")
                            
                            Divider()
                            
                            SettingsButton(image: Image(systemName: "car.rear.road.lane"), text: "Host your spot")
                        } //: Group - Host
                        
                    } //: If Is logged in
                    
                    // MARK: - SUPPORT
                    Group {
                        Text("Support")
                            .modifier(SettingsCategoryHeaderMod())

                        SettingsButton(image: Image(systemName: "info.circle"), text: "More Info")

                        Divider()

                        SettingsButton(image: Image(systemName: "phone"), text: "Contact Support")
                    } //: Group - Support
                    
                    // MARK: - LEGAL
                    Group {
                        Text("Legal")
                            .modifier(SettingsCategoryHeaderMod())

                        SettingsButton(image: Image(systemName: "doc.text.magnifyingglass"), text: "Privacy Policy")

                        Divider()

                        SettingsButton(image: Image(systemName: "doc.text.magnifyingglass"), text: "Terms & Conditions")
                        
                        Divider()
                        
                        if self.sessionManager.isLoggedIn {
                            Button {
                                self.sessionManager.logOut()
                            } label: {
                                Text("Log Out").underline()
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Text("Version 2.0.1")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    } //: Group - Legal
                    
                } //: VStack
                .padding()
            } //: ScrollView
        } //: Navigation View
    }
}
// MARK: - PREVIEW
struct ParkerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerSettingsView()
            .environmentObject(SessionManager())
    }
}
