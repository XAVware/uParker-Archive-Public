//
//  OrDivider.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/10/23.
//

import SwiftUI

struct OrDivider: View {
    var body: some View {
        // MARK: - DIVIDER
        HStack {
            Rectangle().frame(height: 0.5)
            
            Text("OR")
                .modifier(TextMod(.footnote, .light, .gray))
            
            Rectangle().frame(height: 0.5)
        } //: HStack
        .foregroundColor(.gray)
    }
}

struct OrDivider_Previews: PreviewProvider {
    static var previews: some View {
        OrDivider()
    }
}
