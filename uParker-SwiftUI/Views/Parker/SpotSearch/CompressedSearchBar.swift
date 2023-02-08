//
//  CompressedSearchBar.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/22/23.
//

import SwiftUI

struct CompressedSearchBar: View {
    @Binding var destination: String
    @Binding var date: Date
    
    let iconSize: CGFloat = 15
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var dateText: String {
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Where to?")
                    .modifier(TextMod(.headline, .semibold))
                
                Text("\(destination) - \(dateText)")
                    .modifier(TextMod(.caption, .regular))
            } //: VStack
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
        .clipShape(RoundedRectangle(cornerRadius: searchBarHeight))
        .shadow(radius: 4)
        
    }
}

struct CompressedSearchBar_Previews: PreviewProvider {
    @State static var destination: String = ""
    @State static var date: Date = Date()
    
    static var previews: some View {
        CompressedSearchBar(destination: $destination, date: $date)
    }
}
