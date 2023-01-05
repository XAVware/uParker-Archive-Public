//
//  uParker_SwiftUIApp.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

@main
struct uParker_SwiftUIApp: App {
    @EnvironmentObject var sessionManager: SessionManager
    
//    @State var isShowingLoginModal: Bool = true
//    @State var userType: UserType = .parker
//    
//    enum UserType { case parker, host}
    
//    init() {
//        sessionManager = SessionManager()
//    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SessionManager())
//            if userType == .parker {
//                ParkerMainView()
//                    .environmentObject(sessionManager)
//
//            } else {
//                HostMainView()
//            }
        }
        
    }
}
