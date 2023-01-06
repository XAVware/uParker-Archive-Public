//
//  ContinueButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct ContinueButton: View {
    // MARK: - PROPERTIES
    let text: String
    let action: () -> Void
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - BODY
    var body: some View {
        Button {
            self.haptic.impactOccurred()
        } label: {
            Text(text)
                .foregroundColor(.white)
                .font(.title2)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(height: 50)
        .background(backgroundGradient)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


//struct ContinueButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ContinueButton()
//    }
//}
