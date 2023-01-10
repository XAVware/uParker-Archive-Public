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
                MapViewWrapper()
                
                SpotListView(viewHeight: $listHeight, minHeight: initialListHeight, maxHeight: geo.size.height)
                    .edgesIgnoringSafeArea(.bottom)
                

                VStack(spacing: 0) {
                    SearchField()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Spacer().frame(height: initialListHeight - geo.safeAreaInsets.top)

                    MapButtonPanel()
                        .opacity(buttonPanelOpacity)
                    
                    
                    Spacer()
                } //: VStack

                 
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
