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
    
    
    
    // MARK: - ACCOUNT SECTION
    private var accountSection: some View {
        VStack(alignment: .leading) {
            Text("Account")
                .modifier(TextMod(.title2, .semibold))
            
            //Payment Methods
            NavigationLink {
                //
            } label: {
                Image(systemName: "creditcard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Payment Methods")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
                        
            Divider()
            
            //Vehicles
            NavigationLink {
                //
            } label: {
                Image(systemName: "car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Vehicles")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
                        
            Divider()
            
            //Notifications
            NavigationLink {
                //
            } label: {
                Image(systemName: "bell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Notifications")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
        } //: VStack
    } //: Account Section
    
    // MARK: - FOOTER SECTION
    private var footerSection: some View {
        VStack(spacing: 20) {
            if self.sessionManager.isLoggedIn {
                Button {
                    self.sessionManager.logOut()
                } label: {
                    Text("Log Out").underline()
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("Version 2.0.1")
                .modifier(TextMod(.footnote, .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
        } //: VStack
        .padding(.top)
    } //: FooterSection
    
    // MARK: - HOST SECTION
    private var hostSection: some View {
        VStack(alignment: .leading) {
            Text("Host")
                .modifier(TextMod(.title2, .semibold))
            
            //Switch to Hosting
            NavigationLink {
                //
            } label: {
                Image(systemName: "arrowshape.zigzag.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Switch to Hosting")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
            
            Divider()
            
            //Host your Spot
            NavigationLink {
                //
            } label: {
                Image(systemName: "car.rear.road.lane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .offset(x: -2)
                
                Text("Host your Spot")
                    .padding(.leading, 6)
                    .padding(.trailing, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
        } //: VStack
    } //: HostSection
    
    private var legalSection: some View {
        VStack(alignment: .leading) {
            Text("Legal")
                .modifier(TextMod(.title2, .semibold))

            //Privacy Policy
            NavigationLink {
                //
            } label: {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Privacy Policy")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
            
            Divider()

            //Terms & Conditions
            NavigationLink {
                //
            } label: {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Terms & Conditions")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
                        
            Divider()
        } //: VStack
    } //: LegalSection
    
    // MARK: - PROFILE SECTION
    private var profileSection: some View {
        VStack(alignment: .leading) {
            Text("Profile")
                .modifier(TextMod(.largeTitle, .semibold))
            
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
                
                VStack(alignment: .leading) {
                    Text("Ryan")
                        .modifier(TextMod(.title3, .regular))
                    
                    Text("Show Profile")
                        .font(.callout)
                        .foregroundColor(.gray)
                } //: VStack
                .padding(.horizontal, 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            } //: NavLink
        } //: VStack
    } //: ProfileSection
    
    // MARK: - SUPPORT SECTION
    private var supportSection: some View {
        VStack(alignment: .leading) {
            Text("Support")
                .modifier(TextMod(.title2, .semibold))

            //More Info
            NavigationLink {
                
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("More Info")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())

            Divider()

            //Contact Support
            NavigationLink {
                //
            } label: {
                Image(systemName: "phone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Contact Support")
                    .padding(.horizontal, 8)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .modifier(SettingsButtonMod())
        } //: VStack
    } //: SupportSection
    
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
                        profileSection
                                                
                        accountSection
                            .padding(.top)
                        
                        hostSection
                            .padding(.top)
                    } //: If Is logged in
                    
                    supportSection
                        .padding(.top)
                    
                    legalSection
                        .padding(.top)
                    
                    footerSection
                        .padding(.top)
                        
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
