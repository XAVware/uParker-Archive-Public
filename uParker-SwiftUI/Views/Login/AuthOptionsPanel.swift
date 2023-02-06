//
//  AuthOptionsPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct AuthOptionsPanel: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - DIVIDER
            HStack {
                Rectangle().frame(height: 1)
                
                Text("OR")
                    .modifier(FootTextMod())
                
                Rectangle().frame(height: 1)
            } //: HStack
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // MARK: - AUTH W/ APPLE BTN
            ContinueWithButton(icon: Image(systemName: "apple.logo"), text: "Continue with Apple") {
                //
            }
            
            // MARK: - AUTH W/ GOOGLE BTN
            ContinueWithButton(icon: Image("GoogleIcon"), text: "Continue with Google") {
                //
            }
        } //: VStack
    }
}

// MARK: - PREVIEW
struct AuthOptionsPanel_Previews: PreviewProvider {
    static var previews: some View {
        AuthOptionsPanel()
    }
}
