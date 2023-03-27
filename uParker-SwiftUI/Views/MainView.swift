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
        
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
                titleFont = UIFont(descriptor: titleFont.fontDescriptor.withDesign(.rounded)?.withSymbolicTraits(.traitBold) ?? titleFont.fontDescriptor, size: titleFont.pointSize)
                
                UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }
    
    // MARK: - BODY
    var body: some View {
        if sessionManager.userType == .parker {
            ParkerView()
                .environmentObject(sessionManager)
                .fullScreenCover(isPresented: $sessionManager.isShowingLoginView) {
                    LoginView()
                        .environmentObject(sessionManager)
                        .ignoresSafeArea(.keyboard)
                }
//                .sheet(isPresented: $sessionManager.isShowingLoginView) {
//                    SignUpView()
//                        .environmentObject(sessionManager)
//                        .ignoresSafeArea(.keyboard)
//                }

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
