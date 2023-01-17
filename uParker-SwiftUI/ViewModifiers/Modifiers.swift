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
struct SettingsButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
}

struct SettingsCategoryHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .padding(.top, 30)
    }
}

