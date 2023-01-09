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
    
    let tabBarHeight: CGFloat = 49
    let tabViewDividerPadding: CGFloat = 10
    let searchBarHeight: CGFloat = 50
    
    
    // MARK: - BODY
    var body: some View {

        GeometryReader { geo in
            TabView {
                ZStack {
                    MapViewWrapper()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Color.white
                            .frame(height: geo.safeAreaInsets.top)
                            
                        ZStack {
                            Color.white
                                .frame(height: searchBarHeight + 30)
                            
                                SearchField()
                                    .padding(.horizontal)
                                    .padding(.top)
                        }
                            
                        ZStack {
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: 30, y: 30))
                                path.addLine(to: CGPoint(x: geo.size.width - 30, y: 30))
                                path.addLine(to: CGPoint(x: geo.size.width, y: 0))
                            }
                            .fill(.white)
                            .frame(height: 30)
                            .shadow(radius: 5)
                            .mask(Rectangle().padding(.bottom, -20))
                            
                            Button {
                                //
                            } label: {
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                                    
                                Spacer().frame(width: 12)
                                
                                Text("List View")
                                    .font(.footnote)
                            }
                            .frame(width: geo.size.width - 100, height: 20)
                            .background(Color.white)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        }
                        
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 10) {
                                Button {
                                    //Ask for location or center on location
                                } label: {
                                    Image(systemName: "location.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)
                                }
                                .frame(width: 15)
                                
                                Divider()
                                
                                Button {
                                    //Open Map Settings
                                } label: {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)
                                }
                                .frame(width: 15)
                                
                                
                            } //: VStack
                            .frame(width: 35, height: 70)
                            .background(Color.white)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                            .padding()
                            
                            
                        }
                        
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: tabBarHeight + tabViewDividerPadding + geo.safeAreaInsets.bottom)
                    } //: VStack
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(width: geo.size.width, height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
                    
                } //: ZStack
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Text("Park")
                    
                    Image(systemName: "car.fill")
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
                Rectangle()
                    .frame(height: 1)
                    .offset(y: (geo.size.height / 2) - geo.safeAreaInsets.top - tabViewDividerPadding - 1)
                    .foregroundColor(.gray)
                    .opacity(0.7)
                
            )
            
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
