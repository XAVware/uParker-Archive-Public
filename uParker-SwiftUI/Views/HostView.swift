//
//  HostMainView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct HostView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text("Hello, Host!")
            
            Button {
                self.sessionManager.userType = .parker
            } label: {
                Text("Change to parker")
            }
        }
    }
}

// MARK: - PREVIEW
struct HostMainView_Previews: PreviewProvider {
    static var previews: some View {
        HostView()
            .environmentObject(SessionManager())
    }
}
