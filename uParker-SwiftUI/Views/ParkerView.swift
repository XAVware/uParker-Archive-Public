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
    let searchBarHeight: CGFloat = 50
    
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            TabView {
                ZStack {
                    MapViewWrapper()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: geo.safeAreaInsets.top)
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .frame(height: searchBarHeight)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                            .overlay(
                                HStack() {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)
                                        .padding(.horizontal)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Where to?")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                        
                                        Text("Beaver Stadium - Today")
                                            .font(.caption)
                                    } //: VStack
                                    
                                    Spacer()
                                    
                                    Button {
                                        //
                                    } label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .padding(.horizontal)
                                    }
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Circle()
                                            .stroke(.gray)
                                    )
                                    .padding(.trailing)
                                    

                                } //: HStack
                                    .frame(maxWidth: .infinity)
                                    .frame(height: searchBarHeight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: searchBarHeight)
                                            .stroke(.gray)
                                    )
                                    .padding(.horizontal)
                                    .background(.white)
                                    .shadow(radius: 5)
                            )
                        
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
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 46 + geo.safeAreaInsets.bottom + tabViewDividerPadding)
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
