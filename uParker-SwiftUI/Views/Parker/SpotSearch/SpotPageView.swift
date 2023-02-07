//
//  SpotPageView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct SpotPageView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        
        HStack {
            Image("driveway")
                .resizable()
                .scaledToFill()
                .frame(width: 140, alignment: .center)
                .frame(maxHeight: .infinity)
                .clipped()
                

            VStack(alignment: .leading) {
                Text("$8.00 / Day")

                Text(" 4.5 Stars")
                
                Spacer()

                Text("Spot Name")
                    .font(.caption)

            } //: VStack
            .padding(8)
            
            Spacer()
        } //: HStack
        .frame(height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

struct SpotPageView_Previews: PreviewProvider {
    static var previews: some View {
        SpotPageView()
            .padding()
    }
}
