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
        TabView {
            Text("Map View")
                .tabItem {
                    Text("Park")
                    
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            
            Text("Events")
                .tabItem {
                    Text("Events")
                    
                    Image(systemName: "flag.2.crossed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            
            Text("List View")
                .tabItem {
                    Text("List View")
                    
                    Image(systemName: "list.bullet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            
            Text("Chat")
                .tabItem {
                    Text("Chat")
                    
                    Image(systemName: "bubble.left.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
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
            }
            
            
        }
    }
}

// MARK: - PREVIEW
struct ParkerView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerView()
            .environmentObject(SessionManager())
    }
}
