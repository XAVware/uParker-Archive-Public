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
                Rectangle().frame(height: 0.5)
                
                Text("OR")
                    .modifier(TextMod(.footnote, .light, .gray))
                
                Rectangle().frame(height: 0.5)
            } //: HStack
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // MARK: - AUTH W/ APPLE BTN
            Button {
                //
            } label: {
                Text("Continue with Apple")
                    .modifier(TextMod(.title3, .regular))
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.gray)
            )
            .overlay(
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
            // MARK: - AUTH W/ GOOGLE BTN
            Button {
                //
            } label: {
                Text("Continue with Google")
                    .modifier(TextMod(.title3, .regular))
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.gray)
            )
            .overlay(
                Image("GoogleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
        } //: VStack
    }
}

// MARK: - PREVIEW
struct AuthOptionsPanel_Previews: PreviewProvider {
    static var previews: some View {
        AuthOptionsPanel()
    }
}
