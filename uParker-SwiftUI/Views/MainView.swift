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
    
    @State var isShowingLoginModal: Bool = true
    
    // MARK: - BODY
    var body: some View {
        if sessionManager.userType == .parker {
            ParkerView()
                .sheet(isPresented: $isShowingLoginModal) {
                    LoginSignUpView()
                        .environmentObject(sessionManager)
                        .ignoresSafeArea(.keyboard)
                }
                .onChange(of: sessionManager.isLoggedIn) { loggedIn in
                    if loggedIn {
                        self.isShowingLoginModal = false
                    }
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
