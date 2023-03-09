//
//  SpotListingView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/8/23.
//

import SwiftUI

struct SpotListingView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        VStack {
            TabView {
                ForEach(1..<5) { spot in
//                    SpotPageView()
//                        .padding()
//                        .onTapGesture {
//                            isShowingListing.toggle()
//                        }
                    
                }
            } //: Tab
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 130)
        }
    }
}

// MARK: - PREVEIW
struct SpotListingView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListingView()
    }
}
