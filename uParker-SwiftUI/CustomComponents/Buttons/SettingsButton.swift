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
            if image != nil {
                image!
            }
            
            Text(text)
                
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .buttonStyle(PlainButtonStyle())
        .font(.title3)
        .fontDesign(.rounded)
        .frame(height: 40)
    }
}

// MARK: - PREVIEW
struct SettingsButton_Previews: PreviewProvider {
    static let image: Image = Image(systemName: "info.circle")
    
    static var previews: some View {
        SettingsButton(image: nil, text: "More Info")
            .previewLayout(.sizeThatFits)
    }
}
