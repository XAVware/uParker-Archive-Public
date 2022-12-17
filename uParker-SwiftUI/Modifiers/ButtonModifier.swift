//
//  ButtonModifier.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/17/22.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    // MARK: - PROPERTIES
    enum ButtonType { case primaryFill, primaryBorder, secondaryFill, secondaryBorder }
    
    @State var type: ButtonType
    @State var minWidth: CGFloat
    @State var idealWidth: CGFloat
    @State var maxWidth: CGFloat
    @State var minHeight: CGFloat
    @State var idealHeight: CGFloat
    @State var maxHeight: CGFloat
    @State var alignment: Alignment
    
    // MARK: - DEFAULT VALUES
    let defaultBorderWidth: CGFloat = 3
    let defaultShadowRadius: CGFloat = 5
    let defaultShadowY: CGFloat = 5
    
    // MARK: - COMPUTED PROPERTIES
    var backgroundColor: some View {
        switch type {
        case .primaryFill, .primaryBorder:
            return AnyView(primaryColor)
        case .secondaryFill, .secondaryBorder:
            return AnyView(secondaryColor)
        }
    }
    
    var rectangle: some Shape {
        switch type {
        case .primaryFill, .secondaryFill:
            return AnyShape(RoundedRectangle(cornerRadius: self.idealHeight / 2))
        case .primaryBorder, .secondaryBorder:
            return AnyShape(RoundedRectangle(cornerRadius: self.idealHeight / 2)
                .stroke(lineWidth: defaultBorderWidth))
        }
    }

    var buttonBackground: some View {
//        var color: Color
//
//        switch type {
//        case .primaryFill, .primaryBorder:
//            color = primaryColor
//        case .secondaryFill, .secondaryBorder:
//            color = secondaryColor
//        }
        
        return AnyView(backgroundColor.clipShape(self.rectangle))
    }
    
    // MARK: - BODY
    func body(content: Content) -> some View {
        content
            .frame(minWidth: self.minWidth, idealWidth: self.idealWidth, maxWidth: self.maxWidth, minHeight: self.minHeight, idealHeight: self.idealHeight, maxHeight: self.maxHeight, alignment: self.alignment)
            .background(buttonBackground)
            .shadow(radius: defaultShadowRadius, y: defaultShadowY)
        
    }
}
