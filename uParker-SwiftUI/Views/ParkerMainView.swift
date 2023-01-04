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
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text("Hello, Parker!")
            
            Button {
                sessionManager.isShowingLoginModal.toggle()
            } label: {
                Text("Logout")
            }

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
