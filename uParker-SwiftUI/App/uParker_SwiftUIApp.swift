//
//  uParker_SwiftUIApp.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

@main
struct uParker_SwiftUIApp: App {
    @State var isShowingLoginModal: Bool = true
    @State var userType: UserType = .parker
    
    enum UserType { case parker, host}
    
    var body: some Scene {
        WindowGroup {
            if userType == .parker {
                ParkerMainView()
                    .sheet(isPresented: $isShowingLoginModal) {
                        LoginModal()
                    }
            } else {
                HostMainView()
            }
        }
        
    }
}
