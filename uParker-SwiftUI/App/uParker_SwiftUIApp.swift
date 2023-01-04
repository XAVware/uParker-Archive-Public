//
//  uParker_SwiftUIApp.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

@main
struct uParker_SwiftUIApp: App {
    @ObservedObject var sessionManager: SessionManager
    
    @State var isShowingLoginModal: Bool = true
    @State var userType: UserType = .parker
    
    enum UserType { case parker, host}
    
    init() {
        sessionManager = SessionManager()
    }
    
    var body: some Scene {
        WindowGroup {
            if userType == .parker {
                ParkerMainView()
                    .environmentObject(sessionManager)
                    .sheet(isPresented: $isShowingLoginModal) {
                        LoginModal()
                    }
            } else {
                HostMainView()
            }
        }
        
    }
}
