//
//  ParkerChatView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ParkerChatView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager

    // MARK: - BODY
    var body: some View {
        VStack {
            HeaderView(leftItem: nil, title: nil, rightItem: nil)
            
            NeedLoginView(title: "Chat", headline: "Login to view conversations", subheadline: "Once you login, your message inbox will appear here.")
            
            Spacer()
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEWS
struct ParkerChatView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerChatView()
            .environmentObject(SessionManager())
    }
}
