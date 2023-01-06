//
//  ContinueWithButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

import SwiftUI

struct ContinueWithButton: View {
    let icon: Image
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .padding(.leading)
                                
            Text(text)
                .foregroundColor(.black)
                .font(.title3)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(width: 22)
                .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray)
        )
    }
}

//struct ContinueWithButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ContinueWithButton()
//    }
//}
