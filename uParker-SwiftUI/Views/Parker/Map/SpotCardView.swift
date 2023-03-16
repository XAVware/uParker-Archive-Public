//
//  SpotCardView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/16/23.
//

import SwiftUI

struct SpotCardView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var vm: MapViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Image("driveway")
                .resizable()
                .scaledToFill()
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Spot Name")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text("State College, Pennsylvania")
                        .modifier(TextMod(.body, .semibold, .gray))
                        .padding(.bottom, 1)
                    
                    Text("$3.00 / Day")
                        .modifier(TextMod(.callout, .semibold))
                } //: VStack
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14)
                        
                        Text("4.92")
                            .modifier(TextMod(.callout, .regular))
                    } //: HStack
                    
                    Spacer()
                } //: VStack
            } //: HStack
        } //: VStack
        .onTapGesture {
            vm.isShowingSpot.toggle()
        }
    } //: Body
}

struct SpotCardView_Previews: PreviewProvider {
    static var previews: some View {
        SpotCardView()
    }
}
