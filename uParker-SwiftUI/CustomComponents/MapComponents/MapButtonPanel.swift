//
//  MapButtonPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct MapButtonPanel: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 10) {
                Button {
                    //Ask for location or center on location
                } label: {
                    Image(systemName: "location.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                }
                .frame(width: 15)
                
                Divider()
                
                Button {
                    //Open Map Settings
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                }
                .frame(width: 15)
                
            } //: VStack
            .frame(width: 35, height: 70)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 5)
            .padding(.horizontal)
        } //: HStack
    }
}

struct MapButtonPanel_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonPanel()
    }
}
