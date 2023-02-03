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
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThickMaterial)
                                } //: VStack
                            } //: ZStack
                            .frame(width: geo.size.width / 2 - 24, height: (geo.size.width / 2 - 24) * 0.66)
                            .padding(.vertical)
                            
                            
                            
                        } //: ForEach
                    } //: VGrid
                    
                } //: Scroll
                
                Spacer()
            } //: VStack
            .padding(.horizontal)
        } //: Geometry Reader
    }
}

struct MapSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MapSettingsView()
    }
}

//struct MapStyle {
//    let name: String
//    let uri: String
//    let imageName: String
//
//    var style: StyleURI {
//        switch name {
//        case "Streets":
//            return StyleURI.streets
//        case "Outdoors":
//            return StyleURI.streets
//        case "Light":
//            return StyleURI.streets
//        case "Dark":
//            return StyleURI.streets
//        case "Satellite":
//            return StyleURI.streets
//        default:
//            return StyleURI.streets
//        }
//    }
//}
