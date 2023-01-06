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
    
    @State var isShowingLoginModal: Bool = true
    
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ZStack {
                    ParkingMapViewWrapper()
                        .edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .frame(width: geometry.size.width, height: (geometry.size.height + geometry.safeAreaInsets.bottom))
                        .foregroundColor(.white)
                        .offset(y: geometry.size.height - 8)
                        .blur(radius: 8)
                        .opacity(0.9)
                } //: ZStack
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Text("Park")
                    
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.top)
                    
                }
                
                Text("Reservations")
                    .tabItem {
                        Text("Reservations")
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    }
                
                Text("List View")
                    .tabItem {
                        Text("List View")
                        
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    }
                
                VStack {
                    Text("Chat")
                    Button {
                        self.sessionManager.userType = .host
                    } label: {
                        Text("Change to host")
                    }
                    
                } //: VStack
                .tabItem {
                    Text("Chat")
                    
                    Image(systemName: "bubble.left.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.top)
                }
                
                
                ProfileView()
                    .environmentObject(sessionManager)
                    .tabItem {
                        Text(sessionManager.isLoggedIn ? "Profile" : "Login")
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    }
                
            }
        } //: TabView
        
    }
}

// MARK: - PREVIEW
struct ParkerView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerView()
            .environmentObject(SessionManager())
    }
}
