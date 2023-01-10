//
//  AnimatedTextField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/4/23.
//

import SwiftUI

struct AnimatedTextField: View {
    // MARK: - PROPERTIES
    @Binding var boundTo: String
    @State var placeholder: String
    @State private var isSelected: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundColor(.gray)
                .offset(y: self.isSelected ? -14 : 0)
                .font(self.isSelected ? .footnote : .body)
                
            TextField("", text: $boundTo) { isSelected in
                withAnimation { self.isSelected = isSelected }
            }
                .foregroundColor(.black)
                .frame(height: 36)
                .offset(y: 7)
            
        } //: ZStack
        .frame(height: 60)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        )
    }
}

// MARK: - PREVIEW
struct AnimatedTextField_Previews: PreviewProvider {
    @State static var username: String = ""
    static var previews: some View {
        AnimatedTextField(boundTo: $username, placeholder: "Username")
    }
}
