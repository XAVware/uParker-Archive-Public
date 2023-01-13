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
            
            Text("Chat")
                .modifier(PageTitleModifier())
                .padding(.bottom, 20)
            
            if sessionManager.isLoggedIn == false {
                NeedLoginView(mainHeadline: "Login to view conversations", mainDetail: "Once you login, your message inbox will appear here.")
            }
            
            Spacer()
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEW
struct ParkerChatView_Previews: PreviewProvider {
    static var previews: some View {
        ParkerChatView()
            .environmentObject(SessionManager())
    }
}
