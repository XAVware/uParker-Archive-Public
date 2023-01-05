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
    
    let tabBarHeight: CGFloat = 60
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ZStack {
                    ParkingMapViewWrapper()
                    Rectangle()
                        .frame(width: geometry.size.width, height: tabBarHeight)
                        .foregroundColor(.white)
                }
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
                
                Text("Chat")
                    .tabItem {
                        Text("Chat")
                        
                        Image(systemName: "bubble.left.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.top)
                    }
                
                
                VStack {
                    Text("Login/Profile/Settings View")
                    Button {
                        self.sessionManager.userType = .host
                    } label: {
                        Text("Change to host")
                    }
                    
                } //: VStack
                .tabItem {
                    Text("Login")
                    
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
