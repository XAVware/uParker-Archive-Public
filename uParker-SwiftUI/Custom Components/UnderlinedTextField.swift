//
//  UnderlinedTextField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

struct UnderlinedTextField: View {
    // MARK: - Properties
    @Binding var text: String
    @State var placeholder: String
    @State var icon: String
    @State var fontType: Font
    @State var fgColor: Color
    @State var showsIcon: Bool
    @State var isSecure: Bool
    
    // MARK: - Initializers
    //Default
    init(text: Binding<String>, placeholder: String, icon: String) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.fontType = .title3
        self.fgColor = secondaryColor
        self.showsIcon = true
        self.isSecure = false
    }
    
    
    //Include Font Type
    init(text: Binding<String>, placeholder: String, icon: String, fontType: Font) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.fontType = fontType
        self.fgColor = secondaryColor
        self.showsIcon = true
        self.isSecure = false
    }
    
    //Include isSecure
    init(text: Binding<String>, placeholder: String, icon: String, isSecure: Bool) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.fontType = .title3
        self.fgColor = secondaryColor
        self.showsIcon = true
        self.isSecure = isSecure
    }
    
    //Include showsIcon
    init(text: Binding<String>, placeholder: String, icon: String, showsIcon: Bool) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.fontType = .title3
        self.fgColor = secondaryColor
        self.showsIcon = showsIcon
        self.isSecure = false
    }
    
    
    //Include all
    init(text: Binding<String>, placeholder: String, icon: String, fontType: Font, fgColor: Color, showsIcon: Bool, isSecure: Bool) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.fontType = fontType
        self.fgColor = fgColor
        self.showsIcon = showsIcon
        self.isSecure = isSecure
    }
    

    var body: some View {
        HStack(spacing: 20) {
            if showsIcon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            
            VStack(spacing: 10) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(fontType)
                    }
                    
                    if isSecure {
                        SecureField("", text: $text)
                            .font(fontType)
                    } else {
                        TextField("", text: $text)
                            .font(fontType)
                    }
                    
                } //: ZStack
                
                Rectangle().frame(height: 1)
            } //: VStack
        } //: HStack
        .foregroundColor(fgColor)
    }

}

struct UnderlinedTextField_Previews: PreviewProvider {
    @State static var username: String = ""
    static var previews: some View {
        UnderlinedTextField(text: $username, placeholder: "Username", icon: "person.fill")
            .previewLayout(.sizeThatFits)
            .background(primaryColor)
    }
}
