//
//  HostMainView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/3/23.
//

import SwiftUI

struct HostMainView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    // MARK: - BODY
    var body: some View {
        Text("Hello, Host!")
    }
}

// MARK: - PREVIEW
struct HostMainView_Previews: PreviewProvider {
    static var previews: some View {
        HostMainView()
            .environmentObject(SessionManager())
    }
}
