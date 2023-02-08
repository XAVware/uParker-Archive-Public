//
//  SettingsButton.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI

struct SettingsButton: View {
    // MARK: - PROPERTIES
    let image: Image?
    let text: String
    let showsChevron: Bool = true
    let destination: AnyView? = nil
    
    // MARK: - BODY
    var body: some View {
        NavigationLink {
            if destination != nil {
                destination
            }
        } label: {
            HStack(spacing: 12) {
                if image != nil {
                    image!
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                }
                
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fontDesign(.rounded)
        .frame(height: 40)
    }
}

// MARK: - PREVIEW
struct SettingsButton_Previews: PreviewProvider {
    static let image: Image = Image(systemName: "info.circle")
    
    static var previews: some View {
        SettingsButton(image: image, text: "More Info")
            .previewLayout(.sizeThatFits)
    }
}
