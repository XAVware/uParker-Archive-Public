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


// MARK: - PAGE TITLE MOD
struct PageTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

// MARK: - SETTINGS BUTTON LABEL MOD
struct SettingsButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct SettingsCategoryHeaderMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .padding(.top, 30)
    }
}

struct SearchCardMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 4)
    }
}

struct BigTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}


struct MidTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}


struct SmallTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct FootTextMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct CaptionTextMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct CalloutTextMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct HeadlineMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct LargeTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
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
    

// MARK: - Rounded Button
struct RoundedButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .modifier(MidTitleMod())
            .padding()
            .frame(height: 50)
            .background(backgroundGradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
    
