//
//  uParker_SwiftUIApp.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI
import FirebaseCore

@main
struct uParker_SwiftUIApp: App {
    @EnvironmentObject var sessionManager: SessionManager
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SessionManager())
            
        }
    }
}
