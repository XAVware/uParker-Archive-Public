//
//  NeedLoginView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct NeedLoginView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var isShowingLoginModal: Bool = false
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Profile")
                    .modifier(PageTitleModifier())
                
                Text("Login to reserve parking.")
                    .font(.title3)
            } //: VStack
            .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                ContinueButton(text: "Log In") {
                    self.isShowingLoginModal.toggle()
                }
                
                HStack {
                    Text("Don't have an account?")
                        .font(.callout)
                    
                    Button {
                        self.isShowingLoginModal.toggle()
                    } label: {
                        Text("Sign Up").underline()
                            .font(.callout)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } //: VStack
        } //: VStack
    }
}

// MARK: - PREVIEW
struct NeedLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NeedLoginView()
            .environmentObject(SessionManager())
    }
}
