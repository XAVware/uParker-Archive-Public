//
//  ReservationPanelButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/14/23.
//

import SwiftUI

struct ReservationPanelButton: View {
    // MARK: - PROPERTIES
    let iconName: String
    let text: String
    let action: () -> Void
    
    // MARK: - BODY
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                
                Text(text)
                    .modifier(TextMod(.subheadline, .semibold))
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white)
    }
}

struct ReservationPanelButton_Previews: PreviewProvider {
    static func action() {
        //
    }
    static var previews: some View {
        ReservationPanelButton(iconName: "arrow.up.arrow.down.square", text: "Directions", action: action)
    }
}
