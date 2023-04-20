//
//  Modifiers.swift
//  CogCalendar2023
//
//  Created by Smetana, Ryan on 4/4/23.
//

import SwiftUI

struct TextMod: ViewModifier {
    let font: Font
    let weight: Font.Weight
    let fgColor: Color
    
    init() {
        self.font = .body
        self.weight = .semibold
        self.fgColor = .black
    }
    
    init(_ font: Font, _ weight: Font.Weight) {
        self.font = font
        self.weight = weight
        self.fgColor = .black
    }
    
    init(_ font: Font, _ weight: Font.Weight, _ fgColor: Color) {
        self.font = font
        self.weight = weight
        self.fgColor = fgColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(self.font)
            .fontWeight(self.weight)
            .foregroundColor(self.fgColor)
            .fontDesign(.rounded)
    }
}
