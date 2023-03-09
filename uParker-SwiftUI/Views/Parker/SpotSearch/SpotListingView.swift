//
//  SpotListingView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/8/23.
//

import SwiftUI
@MainActor class SpotListingViewModel: ObservableObject {
    @Published var scrollOffset: CGFloat = 0
    @Published var isFavorite: Bool = false
    
    let imageHeight: CGFloat = 260
    
    var topBarOpacity: CGFloat {
        let startingPoint: CGFloat = 80
        if scrollOffset < imageHeight - startingPoint {
            return 0
        } else if scrollOffset > imageHeight {
            return 1
        } else {
            let difference = imageHeight - scrollOffset
            return (startingPoint - difference) / (startingPoint / 2)
        }
    }
}

struct SpotListingView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: SpotListingViewModel = SpotListingViewModel()
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    // MARK: - BODY
    var body: some View {
        ObservableScrollView(scrollOffset: $vm.scrollOffset) { proxy in
            VStack {
                imageTabView
                VStack(alignment: .leading) {
                    Text("Spot Name")
                        .modifier(TextMod(.title, .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("State College, Pennsylvania")
                        .modifier(TextMod(.body, .semibold, .gray))
                    
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Text("4.92")
                            .modifier(TextMod(.footnote, .regular, .gray))
                        
                        dotSpacer
                        
                        Button {
                            //scroll to review section
                        } label: {
                            Text("17 Reviews")
                                .underline()
                                .modifier(TextMod(.footnote, .medium))
                        }
                        .foregroundColor(.black)
                        
                        dotSpacer
                        
                        Text("35 Total Reservations")
                            .modifier(TextMod(.footnote, .regular))
                    } //: HStack
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description:")
                            .modifier(TextMod(.title3, .semibold, .gray))
                        
                        Text("""
                        Looking for a safe and convenient place to park your car? Look no further than my private driveway! Located in a quiet and secure residential area, my driveway is the perfect spot for anyone in need of a reliable parking space. Whether you're a commuter looking for a regular spot to park during the work week, or you need a place to leave your car while you're away on vacation, my driveway is available for rent on a short-term or long-term basis. With 24/7 access, you can park your vehicle with peace of mind knowing it's in a safe and monitored location. Contact me today to secure your spot!
                        """)
                        .multilineTextAlignment(.leading)
                        .modifier(TextMod(.callout, .regular))
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amenities:")
                            .modifier(TextMod(.title3, .semibold, .gray))
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            //Gated, lighting, covered, available now,
                            ForEach(1..<7, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Image(systemName: "lightbulb.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12)
                                        .opacity(0.7)
                                    
                                    Text("Lighting")
                                        .modifier(TextMod(.headline, .regular))
                                } //: HStack
                            } //: For Each
                        } //: VGrid
                    } //: VStack
                    
                    Spacer().frame(height: 80)
                } //: VStack
                .padding()
            } //: VStack
            .edgesIgnoringSafeArea(.all)
        } //: Scroll
        .overlay(buttonOverlay)
        
    }
    
    // MARK: - VIEW VARIABLES
    private var dotSpacer: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 2)
            .padding(.horizontal, 2)
    }
    
    private var buttonOverlay: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(radius: vm.topBarOpacity > 0.85 ? 0 : 1)
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(radius: vm.topBarOpacity > 0.85 ? 0 : 1)
                
                Button {
                    vm.isFavorite.toggle()
                } label: {
                    Image(systemName: vm.isFavorite ? "heart.fill" : "heart")
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(radius: vm.topBarOpacity > 0.85 ? 0 : 1)
                
            } //: HStack
            .padding()
            .background(Color.white.opacity(vm.topBarOpacity))
            
            Divider().opacity(vm.topBarOpacity)
            
            Spacer()
            
            Button {
                //
            } label: {
                Text("Reserve for $3.00 / Day")
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .foregroundColor(.white)
            }
            .foregroundColor(.white)
            .modifier(TextMod(.title2, .semibold))
            .padding()
            .background(backgroundGradient)
            
        } //: VStack
    } //: Button Overlay
    
    private var imageTabView: some View {
        TabView {
            ForEach(1..<5) { spot in
                Image("driveway")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 500, maxHeight: .infinity)
                
            }
        } //: Tab
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: vm.imageHeight)
    }
}

// MARK: - PREVEIW
struct SpotListingView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListingView()
    }
}
