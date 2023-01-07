//
//  LoginViewDivider.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

import SwiftUI

struct LoginViewDivider: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
            
            Text("OR")
                .font(.footnote)
                .fontDesign(.rounded)
            
            Rectangle()
                .frame(height: 1)
        } //: HStack
        .frame(height: 10)
        .foregroundColor(.gray)
    }
}

struct LoginViewDivider_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewDivider()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
