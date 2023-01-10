//
//  SearchField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SearchField: View {
    // MARK: - PROPERTIES
    let iconSize: CGFloat = 15
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
            
            VStack(alignment: .leading) {
                Text("Where to?")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Beaver Stadium - Today")
                    .font(.caption)
            } //: VStack
            .fontDesign(.rounded)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                //
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize)
            }
            .frame(width: 35, height: 35)
            .overlay(Circle().stroke(.gray))
        } //: HStack
        .padding(.horizontal)
        .frame(height: searchBarHeight)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(radius: 4)
        .overlay(
            RoundedRectangle(cornerRadius: searchBarHeight)
                .stroke(.gray, lineWidth: 0.5)
        )
        .onTapGesture {
            print("Search Field Clicked")
        }
        
    }
}

// MARK: - PREVIEW
struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField()
            .previewLayout(.sizeThatFits)
//            .background(.blue)
            .padding()
    }
}
