//
//  ParkerView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct ParkerMainView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var isShowingLoginModal: Bool = true
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text("Hello, Parker!")
            
            Button {
                self.isShowingLoginModal.toggle()
            } label: {
                Text("Logout")
            }
            
            Button {
                self.sessionManager.userType = .host
            } label: {
                Text("Change to host")
            }

        } //: VStack
        .sheet(isPresented: $isShowingLoginModal) {
            LoginModal()
        }
    }
}

// MARK: - PREVIEW
struct ParkerView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerMainView()
            .environmentObject(SessionManager())
    }
}
