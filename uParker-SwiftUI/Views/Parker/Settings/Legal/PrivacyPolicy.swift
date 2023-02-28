//
//  PrivacyPolicy.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/28/23.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Private things here...")
                .modifier(TextMod(.title3, .ultraLight))
            
            Text("shhhh")
                .modifier(TextMod(.caption, .light))
        } //: VStack
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPolicy()
        }
    }
}
