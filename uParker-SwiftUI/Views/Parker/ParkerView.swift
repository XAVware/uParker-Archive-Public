//
//  ParkerView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct ParkerView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
        
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            TabView {
                SpotMapView()
                    .tabItem {
                        Text("Park")
                        
                        Image(systemName: "car")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    } //: Tab Item
                
                ParkerReservationsView()
                    .environmentObject(sessionManager)
                    .tabItem {
                        Text("Reservations")
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    } //: Tab Item
                
                ParkerChatView()
                    .environmentObject(sessionManager)
                    .tabItem {
                        Text("Chat")
                        
                        Image(systemName: "bubble.left.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    } //: Tab Item
                
                ProfileView()
                    .environmentObject(sessionManager)
                    .tabItem {
                        Text(sessionManager.isLoggedIn ? "Profile" : "Login")
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                        
                    } //: Tab Item
                
            } //: TabView
            .overlay(
                Color.gray
                    .frame(height: 1)
                    .offset(y: (geo.size.height / 2) - tabBarHeight - 0.5)
                    .opacity(0.7)
            )
            .ignoresSafeArea(.keyboard)
            
        } //: Geometry Reader
    }
}

// MARK: - PREVIEW
struct ParkerView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerView()
            .environmentObject(SessionManager())
    }
}
