//
//  SpotMapView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI
//The final version needs to be removed from tabview and vstack
struct SpotMapView: View {
    
    @State var displayMode: DisplayMode = .map
    enum DisplayMode { case map, list }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MapViewWrapper()
                
                VStack(spacing: 0) {
                    Color.white
                        .frame(height: searchBarHeight + 30)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: self.displayMode == .map ? 30 : 0, y: self.displayMode == .map ? 30 : geo.size.height))
                        path.addLine(to: CGPoint(x: self.displayMode == .map ? (geo.size.width - 30) : geo.size.width, y: self.displayMode == .map ? 30 : geo.size.height))
                        path.addLine(to: CGPoint(x: geo.size.width, y: 0))
                    }
                    .fill(.white)
                    .frame(height: self.displayMode == .map ? 30 : geo.size.height - (searchBarHeight + 30))
                    .shadow(radius: 5)
                    .mask(Rectangle().padding(.bottom, -20))
                    
                    Spacer()
                    
                } //: VStack - Background Colors
                
                VStack(spacing: 12) {
                    SearchField()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if self.displayMode == .map {
                        Button {
                            withAnimation {
                                self.displayMode = .list
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                            
                            Spacer().frame(width: 12)
                            
                            Text("List View")
                                .font(.footnote)
                        }
                        .frame(height: 20)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        
                        MapButtonPanel()
                        
                        Spacer()
                    } else {
                        Spacer()
                        
                        Button {
                            self.displayMode = .map
                        } label: {
                            Image(systemName: "map.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                            
                            Text("Map")
                                .font(.footnote)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .frame(height: 30)
                        .background(backgroundGradient)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                        .padding(.bottom, 30)
                        
                    }
                    
                } //: VStack - Map Components
            }
            
        } //: Geometry Reader
    }
    
}

struct SpotsView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView()
    }
}
