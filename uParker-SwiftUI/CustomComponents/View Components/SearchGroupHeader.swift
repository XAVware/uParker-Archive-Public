//
//  SearchGroupHeader.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/22/23.
//

import SwiftUI

struct SearchGroupHeader: View {
    @State var header: String
    @Binding var isExpanded: Bool
    @Binding var subtitle: String
    
    var body: some View {
        HStack {
            Text(header)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(primaryColor)
            
            if !isExpanded {
                Text(subtitle)
                    .font(.footnote)
            }
        } //: HStack
    }
}

struct SearchGroupHeader_Previews: PreviewProvider {
    @State static var expanded: Bool = true
    @State static var sub: String = "Beaver Stadium"
    static var previews: some View {
        SearchGroupHeader(header: "Where to?", isExpanded: $expanded, subtitle: $sub)
    }
}
