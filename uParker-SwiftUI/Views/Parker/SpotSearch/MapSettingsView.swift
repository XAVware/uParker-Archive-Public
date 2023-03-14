//
//  MapSettingsView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/3/23.
//

import SwiftUI
import MapboxMaps

//struct MapSettingsView: View {
//    // MARK: - PROPERTIES
//    @Environment(\.dismiss) var dismiss
//    @Binding var mapStyle: StyleURI
//    
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
//    
//    // MARK: - BODY
//    var body: some View {
//        GeometryReader { geo in
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Map Settings")
//                        .modifier(TextMod(.title, .semibold))
//                    
//                    Spacer()
//                    
//                    Button {
//                        self.dismiss.callAsFunction()
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20)
//                            .foregroundColor(Color(.systemGray4))
//                    }
//
//                } //: HStacl
//                
//                
//                ScrollView(showsIndicators: false) {
//                    LazyVGrid(columns: columns, spacing: 20) {
//                        ForEach(mapStyles) { style in
//                            ZStack {
//                                Image(style.imageName)
//                                    .resizable()
//                                    .scaledToFill()
//
//                                VStack {
//                                    Spacer()
//
//                                    Text(style.labelName)
//                                        .modifier(TextMod(.callout, self.mapStyle == style.styleURI ? .bold : .regular))
//                                        .padding()
//                                        .frame(height: 45)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(.ultraThickMaterial)
//                                } //: VStack
//
//                            } //: ZStack
//                            .frame(width: geo.size.width / 2 - 24, height: (geo.size.width / 2 - 24) * 0.70)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryColor, lineWidth: self.mapStyle == style.styleURI ? 1 : 0))
//                            .onTapGesture {
//                                self.mapStyle = style.styleURI
//                            }
//
//                        } //: ForEach
//                    } //: VGrid
//                    .padding(.top,8)
//                } //: Scroll
//                
//                Spacer()
//            } //: VStack
//            .padding(.horizontal)
//            .padding(.top)
//        } //: Geometry Reader
//    }
//}
//
//let mapStyles: [MapStyle] = [
//    MapStyle(labelName: "Streets", imageName: "Style.streets"),
//    MapStyle(labelName: "Satellite", imageName: "Style.satellite"),
//    MapStyle(labelName: "Outdoors", imageName: "Style.outdoors"),
//    MapStyle(labelName: "Light", imageName: "Style.light"),
//    MapStyle(labelName: "Dark", imageName: "Style.dark")
//]
//
//struct MapStyle: Identifiable {
//    let id: UUID = UUID()
//    let labelName: String
//    let imageName: String
//    
//    var styleURI: StyleURI {
//        switch labelName {
//        case "Streets":
//            return StyleURI.streets
//        case "Outdoors":
//            return StyleURI.outdoors
//        case "Light":
//            return StyleURI.light
//        case "Dark":
//            return StyleURI.dark
//        case "Satellite":
//            return StyleURI.satellite
//        default:
//            return StyleURI.streets
//        }
//    }
//}

// MARK: - PREVEIW
//struct MapSettingsView_Previews: PreviewProvider {
//    @State static var style: StyleURI = StyleURI.streets
//    static var previews: some View {
//        MapSettingsView(mapStyle: $style)
//    }
//}
