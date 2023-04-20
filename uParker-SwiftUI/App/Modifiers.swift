//
//  Modifiers.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

// MARK: - TEMPLATE
//struct Modifiers: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//
//    }
//}

struct SearchCardMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 4)
    }
}

// MARK: - Email Field Mod
struct EmailFieldMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .submitLabel(.continue)

    }
}

// MARK: - Settings Button Mod
struct SettingsButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.callout)
            .fontDesign(.rounded)
            .frame(height: 30)
    }
}

// MARK: - Rounded Button
struct RoundedButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .modifier(TextMod(.title2, .semibold))
            .padding()
            .frame(height: 50)
            .background(backgroundGradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
    
// MARK: - Rounded Image
struct RoundedImageMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.gray, lineWidth: 0.5)
            )
    }
}


// MARK: - OUTLINED BUTTON
struct OutlinedButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(TextMod(.title3, .regular))
            .frame(height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.gray)
            )
    }
}

    
