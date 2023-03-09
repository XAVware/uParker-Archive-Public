//
//  SpotMapView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI
import MapboxMaps

struct SpotMapView: View {
    // MARK: - PROPERTIES
    @StateObject var locationManager = LocationManager.shared
    
    @State var listHeight: CGFloat = 120
    @State var mapStyle: StyleURI = .streets
    @State var isShowingSettings: Bool = false
    @State var selectedSpotId: String?
    
    @State var spots: [Spot] = []
    
    @State var isShowingListing: Bool = false
    
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
                MapViewWrapper(center: $locationManager.location, mapStyle: $mapStyle, selectedSpotId: $selectedSpotId)
                
                SpotListView(viewHeight: $listHeight, minHeight: initialListHeight, maxHeight: geo.size.height)
                    .edgesIgnoringSafeArea(.bottom)
                
                
                VStack(spacing: 0) {
                    Spacer().frame(height: initialListHeight - geo.safeAreaInsets.top + searchBarHeight)
                        .padding(.top)
                    
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 10) {
                            Button {
                                LocationManager.shared.requestLocation()
                            } label: {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            }
                            .frame(width: 15)
                            
                            Divider()
                            
                            Button {
                                self.isShowingSettings.toggle()
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
                    
                    if selectedSpotId != nil {
                        TabView {
                            ForEach(1..<5) { spot in
                                SpotPageView()
                                    .padding()
                                    .onTapGesture {
                                        isShowingListing.toggle()
                                    }
                                
                            }
                        } //: Tab
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 130)
                    }
                } //: VStack
                .overlay(
                    SearchField()
                )
                .sheet(isPresented: $isShowingSettings) {
                    MapSettingsView(mapStyle: $mapStyle)
                        .presentationDetents([.fraction(0.65)])
                        .presentationDragIndicator(.hidden)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .sheet(isPresented: $isShowingListing) {
                    SpotListingView()
                }
                
            } //: ZStack
//            .onAppear{
//                self.spots = [Spot(streetAdress: "123 East Beaver Ave, State College, PA 16801", title: "Spot 1", price: 3.00, rating: 4.0),
//                                  Spot(streetAdress: "100 Waupelani Drive, State College, PA 16801", title: "Spot 2", price: 40.00, rating: 5.0)]
//                
//            }
            
        } //: Geometry Reader
    }
    
}

// MARK: - PREVIEW
struct SpotMapView_Previews: PreviewProvider {
    static var previews: some View {
        SpotMapView()
    }
}
