//
//  SpotMapView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI
//The final version needs to be removed from tabview and vstack
struct SpotMapView: View {
    // MARK: - PROPERTIES
    @ObservedObject var locationManager: LocationManager = LocationManager()
    
    @State var listHeight: CGFloat = 120
    
    
    private let initialListHeight: CGFloat = 120
    
    private var buttonPanelOpacity: CGFloat {
        if listHeight == initialListHeight {
            return 1
        } else {
            return 1 - ((listHeight - initialListHeight) / 10)
        }
    }
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MapViewWrapper(center: $locationManager.location)
                
                SpotListView(viewHeight: $listHeight, minHeight: initialListHeight, maxHeight: geo.size.height)
                    .edgesIgnoringSafeArea(.bottom)
                

                VStack(spacing: 0) {
                    Spacer().frame(height: initialListHeight - geo.safeAreaInsets.top + searchBarHeight)
                        .padding(.top)
                        
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
                        .opacity(buttonPanelOpacity)
                    } //: HStack
                    Spacer()
                } //: VStack
                .overlay(
                    SearchField()
                        .environmentObject(locationManager), alignment: .top
                )
                 
                
            } //: ZStack
            
        } //: Geometry Reader
    }
    
}

// MARK: - PREVIEW
struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView()
    }
}
