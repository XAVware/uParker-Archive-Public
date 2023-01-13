//
//  MainView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

import SwiftUI

struct MainView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
        
    // MARK: - BODY
    var body: some View {
        if sessionManager.userType == .parker {
            ParkerView()
                .sheet(isPresented: $sessionManager.isShowingLoginModal) {
                    LoginSignUpView()
                        .environmentObject(sessionManager)
                        .ignoresSafeArea(.keyboard)
                }

        } else {
            HostView()
                .environmentObject(sessionManager)
        }
    }
}

// MARK: - PREVIEW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionManager())
    }
}
