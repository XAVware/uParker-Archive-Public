//
//  MapSettingsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/3/23.
//

import SwiftUI
import MapboxMaps

struct MapSettingsView: View {
    let stylesDict: [String : String] = ["Streets" : "Style.streets", "Outdoors" : "Style.outdoors", "Light" : "Style.light", "Dark" : "Style.dark", "Satellite" : "Style.satellite"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("Map Settings")
                    .modifier(BigTitleMod())
                
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(stylesDict.sorted(by: >), id: \.key) { styleName, imageName in

                            ZStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()

                                VStack {
                                    Spacer()

                                    Text(styleName)
                                        .font(.callout)
                                        .padding()
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.ultraThickMaterial)
                                } //: VStack

                            } //: ZStack
                            .frame(width: geo.size.width / 2 - 24, height: (geo.size.width / 2 - 24) * 0.70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            //If selected 1 else 0
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryColor, lineWidth: 1))

                        } //: ForEach
                    } //: VGrid
                    .padding(.top,8)
                } //: Scroll
                
                Spacer()
            } //: VStack
            .padding(.horizontal)
            .padding(.top)
        } //: Geometry Reader
    }
}

struct MapSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MapSettingsView()
    }
}

let mapStyles: [MapStyle] = [
    MapStyle(labelName: "Streets", imageName: "Style.streets"),
    MapStyle(labelName: "Satellite", imageName: "Style.satellite"),
    MapStyle(labelName: "Outdoors", imageName: "Style.outdoors"),
    MapStyle(labelName: "Light", imageName: "Style.light"),
    MapStyle(labelName: "Dark", imageName: "Style.dark"),
    MapStyle(labelName: "Satellite Streets", imageName: "Style.streets")
]

struct MapStyle {
    let labelName: String
    let imageName: String
    
    var style: StyleURI {
        switch labelName {
        case "Streets":
            return StyleURI.streets
        case "Outdoors":
            return StyleURI.outdoors
        case "Light":
            return StyleURI.light
        case "Dark":
            return StyleURI.dark
        case "Satellite":
            return StyleURI.satellite
        default:
            return StyleURI.streets
        }
    }
}
