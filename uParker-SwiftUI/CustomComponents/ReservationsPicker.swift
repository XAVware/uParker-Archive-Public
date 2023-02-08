//
//  ReservationsPicker.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/14/23.
//

import SwiftUI

struct ReservationsPicker: View {
    @Binding var selectedIndex: Int
    var options: [String]
    
    let color = Color.red
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(primaryColor.opacity(0.2))
                    
                    Rectangle()
                        .fill(primaryColor)
                        .cornerRadius(18)
                        .padding(2)
                        .opacity(selectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                selectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .modifier(TextMod(.body, selectedIndex == index ? .semibold : .regular, selectedIndex == index ? .white : .black))
                )
            }
        }
        .frame(height: 36)
        .cornerRadius(18)
    }
}

struct ReservationsPicker_Previews: PreviewProvider {
    @State static var selection: Int = 1
    static var options: [String] = ["Past", "Current", "Upcoming"]
    static var previews: some View {
        ReservationsPicker(selectedIndex: $selection, options: options)
    }
}
