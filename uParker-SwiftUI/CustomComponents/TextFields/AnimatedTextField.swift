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
    
    @State var placeholderOffset: CGFloat = 0
    @State var textFieldOffset: CGFloat = 0
    @State var placeholderScale: CGFloat = 1
    
    @State var isSecure: Bool = false
    
    // MARK: - FUNCTIONS
    func setPlacholderSize() {
        if boundTo.isEmpty {
            withAnimation {
                placeholderOffset = 0
                placeholderScale = 1
                textFieldOffset = 0
            }
        } else {
            withAnimation {
                placeholderOffset = -20
                placeholderScale = 0.75
                textFieldOffset = 5
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundColor(.gray)
                .offset(y: placeholderOffset)
                .scaleEffect(placeholderScale, anchor: .leading)
            
            if isSecure {
                SecureField("", text: $boundTo)
                    .foregroundColor(.black)
                    .frame(height: 36)
                    .offset(y: textFieldOffset)
            } else {
                TextField("", text: $boundTo)
                    .foregroundColor(.black)
                    .frame(height: 36)
                    .offset(y: textFieldOffset)
            }

        } //: ZStack
        .onChange(of: boundTo.isEmpty, perform: { _ in
            setPlacholderSize()
        })
        .frame(height: 55)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        )
        .onAppear {
            setPlacholderSize()
        }
    }
}

// MARK: - PREVIEW
struct AnimatedTextField_Previews: PreviewProvider {
    @State static var username: String = ""
    static var previews: some View {
        AnimatedTextField(boundTo: $username, placeholder: "Username")
    }
}
