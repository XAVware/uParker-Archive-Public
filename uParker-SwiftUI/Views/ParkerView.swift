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
    
    let tabViewDividerPadding: CGFloat = 10
    let searchBarHeight: CGFloat = 40
    
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            TabView {
                ZStack {
                    MapViewWrapper()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: geo.safeAreaInsets.top + 90)
                            .foregroundColor(.white)
                        
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 30, y: 30))
                            path.addLine(to: CGPoint(x: geo.size.width - 30, y: 30))
                            path.addLine(to: CGPoint(x: geo.size.width, y: 0))
                        }
                        .fill(.white)
                        .shadow(radius: 5)
                        .mask(Rectangle().padding(.bottom, -20))
                        .frame(height: 30)
                        
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
                    } //: VStack
                    .frame(width: geo.size.width, height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
                    
                    Rectangle()
                        .frame(height: geo.size.height + geo.safeAreaInsets.bottom + tabViewDividerPadding)
                        .foregroundColor(.white)
                        .offset(y: geo.size.height - tabViewDividerPadding)
                        .opacity(0.9)
                        .shadow(radius: 2)
                        .onTapGesture {
                            print(geo.size.height + geo.safeAreaInsets.bottom + tabViewDividerPadding)
                        }
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
                    .offset(y: (geo.size.height / 2) - geo.safeAreaInsets.top - tabViewDividerPadding)
                    .foregroundColor(.gray)
                    .opacity(0.7)
                
            )
            
        } //: Geometry Reader
    }
}

// Helper bridge to UIViewController to access enclosing UITabBarController
// and thus its UITabBar
struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
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
