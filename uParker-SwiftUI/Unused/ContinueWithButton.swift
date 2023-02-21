//
//  ContinueWithButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

//import SwiftUI
//
//struct ContinueWithButton: View {
//    // MARK: - PROPERTIES
//    let icon: Image
//    let text: String
//    let action: () -> Void
//    
//    // MARK: - BODY
//    var body: some View {
//        Button {
//            action()
//        } label: {             
//            Text(text)
//                .modifier(TextMod(.title3, .regular))
//                .frame(maxWidth: .infinity)
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: 45)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(.gray)
//        )
//        .overlay(
//            icon
//                .resizable()
//                .scaledToFit()
//                .frame(width: 22, height: 22)
//                .padding(.leading), alignment: .leading
//        )
//    }
//}
//
//// MARK: - PREVIEW
//struct ContinueWithButton_Previews: PreviewProvider {
//    static let icon: Image = Image(systemName: "envelope")
//    static let text: String = "Continue"
//    static func action() {
//        //
//    }
//    
//    static var previews: some View {
//        ContinueWithButton(icon: icon, text: text, action: action)
//    }
//}