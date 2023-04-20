//
//  ParkerSettingsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ParkerSettingsView: View {
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                        profileSection
                        
                        accountSection
                            .padding(.top)
                        
                        hostSection
                            .padding(.top)
                    
                    SupportSettings()
                        .padding(.top)
                    
                        Button {
                            UserManager.shared.signOut()
                        } label: {
                            Text("Log Out").underline()
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                } //: VStack
            } //: ScrollView
            .navigationTitle("Profile")
            .padding()
        } //: Navigation View
    }
    
    // MARK: - PROFILE
    private var profileSection: some View {
        VStack(alignment: .leading) {
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
    
    // MARK: - ACCOUNT
    private var accountSection: some View {
        VStack(alignment: .leading) {
            Text("Account")
                .modifier(TextMod(.title2, .semibold))
            
            //Payment Methods
            NavigationLink {
                PaymentMethodsView()
            } label: {
                HStack {
                    Image(systemName: "creditcard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Payment Methods")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            //Vehicles
            NavigationLink {
                VehiclesView()
            } label: {
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Vehicles")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            //Notifications
            NavigationLink {
                NotificationsView()
            } label: {
                HStack {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Notifications")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
        } //: VStack
    } //: Account Section
    
    // MARK: - HOST
    private var hostSection: some View {
        VStack(alignment: .leading) {
            Text("Host")
                .modifier(TextMod(.title2, .semibold))
            
            //Switch to Hosting
            NavigationLink {
                //
            } label: {
                HStack {
                    Image(systemName: "arrowshape.zigzag.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Switch to Hosting")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            //Host your Spot
            NavigationLink {
                //
            } label: {
                HStack {
                    Image(systemName: "car.rear.road.lane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                        .offset(x: -2)
                    
                    Text("Host your Spot")
                        .padding(.leading, 6)
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
        } //: VStack
    } //: HostSection
}

// MARK: - PREVIEW
struct ParkerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ParkerSettingsView()
                .environmentObject(SessionManager())
        }
    }
}

struct SupportSettings: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Support")
                .modifier(TextMod(.title2, .semibold))
            
            //More Info
            NavigationLink {
                MoreInfoView()
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("More Info")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            //Contact Support
            NavigationLink {
                //
            } label: {
                HStack {
                    Image(systemName: "phone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    
                    Text("Contact Support")
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                } //: HStack
                .modifier(SettingsButtonMod())
            }
            .buttonStyle(PlainButtonStyle())
        } //: VStack
    }
}
