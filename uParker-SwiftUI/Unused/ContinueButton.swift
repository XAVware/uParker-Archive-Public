//
//  ContinueButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//
//
//import SwiftUI
//
//struct ContinueButton: View {
//    // MARK: - PROPERTIES
//    let text: String
//    let action: () -> Void
//    private let haptic = UIImpactFeedbackGenerator(style: .medium)
//    
//    // MARK: - BODY
//    var body: some View {
//        Button {
//            self.haptic.impactOccurred()
//            self.action()
//        } label: {
//            Text(text)
//                .frame(maxWidth: .infinity)
//        }
//        .foregroundColor(.white)
//        .modifier(MidTitleMod())
//        .padding()
//        .frame(height: 50)
//        .background(backgroundGradient)
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}
//
//// MARK: - PREVIEW
//struct ContinueButton_Previews: PreviewProvider {
//    static let text: String = "Continue"
//    static func action() {
//        //
//    }
//    
//    static var previews: some View {
//        ContinueButton(text: text, action: action)
//    }
//}
