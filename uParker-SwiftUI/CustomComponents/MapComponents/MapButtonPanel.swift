//
//  MapButtonPanel.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct MapButtonPanel: View {
    // MARK: - PROPERTIES
    @StateObject var locationManager: LocationManager
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 10) {
                Button {
                    locationManager.requestLocation()
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

// MARK: - PREVIEW
struct MapButtonPanel_Previews: PreviewProvider {
    @StateObject static var locationManager: LocationManager = LocationManager()
    static var previews: some View {
        MapButtonPanel(locationManager: locationManager)
    }
}
