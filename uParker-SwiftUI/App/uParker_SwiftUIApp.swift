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
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SessionManager())
                
                
        }
    }
}
