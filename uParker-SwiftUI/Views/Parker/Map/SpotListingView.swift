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
    
    let imageHeight: CGFloat = 340
    
    var topBarOpacity: CGFloat {
        let startingPoint: CGFloat = imageHeight / 2.5
        if scrollOffset < imageHeight - startingPoint {
            return 0
        } else if scrollOffset > imageHeight {
            return 1
        } else {
            let difference = imageHeight - scrollOffset
            return (startingPoint - difference) / (startingPoint / 2)
        }
    }
    
    let amenities: [AmenityDetail] = [
        AmenityDetail(title: "Lighting", imageName: "lightbulb.fill"),
        AmenityDetail(title: "Covered", imageName: "umbrella.fill"),
        AmenityDetail(title: "Gated", imageName: "pedestrian.gate.closed"),
        AmenityDetail(title: "Camera", imageName: "camera.fill"),
        AmenityDetail(title: "Verified", imageName: "checkmark.shield.fill")
    ]
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
                    infoSection
                    Divider().padding(.vertical)
                    descriptionSection
                    Divider().padding(.vertical)
                    
                    amenitiesSection
                    
                    Divider().padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            
                            Text("4.92")
                                .modifier(TextMod(.title3, .semibold))
                            
                            dotSpacer.scaleEffect(2)
                            
                            Text("17 Reviews")
                                .modifier(TextMod(.title3, .semibold))
                        } //: HStack
                        
                        TabView {
                            ForEach(1..<4) { review in
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .padding(10)
                                            .foregroundColor(.gray)
                                            .frame(width: 55, height: 55, alignment: .center)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(.gray, lineWidth: 0.5)
                                            )
                                        
                                        VStack(alignment: .leading) {
                                            Text("Rachel")
                                                .modifier(TextMod(.body, .semibold))
                                            
                                            Text("2 Weeks Ago")
                                                .modifier(TextMod(.callout, .semibold, .gray))
                                        } //: VStack
                                        
                                        Spacer()
                                    } //: HStack
                                    .frame(height: 40)
                                    
                                    Text("The driveway was spacious and well-maintained. We had no trouble parking our SUV and the host was friendly and accommodating. Would definitely use again!")
                                        .frame(height: 100)
                                    
                                    Button {
                                        //
                                    } label: {
                                        Text("See More")
                                            .modifier(TextMod(.callout, .semibold))
                                            .underline()
                                            .frame(maxHeight: .infinity)
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 10)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .offset(y: 1)
                                    }
                                    
                                } //: VStack
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.gray)
                                )
                                .padding()
                            } //: For Each
                        } //: Tab View
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .padding()
                        .frame(height: 260)
                        
                        Button {
                            //
                        } label: {
                            Text("See All Reviews")
                                .modifier(TextMod(.title3, .semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .modifier(OutlinedButtonMod())
                        .padding(.top, 8)

                    } //: VStack
                    
                    Spacer().frame(height: 80)
                } //: VStack
                .padding()
            } //: VStack
            
        } //: Scroll
        .edgesIgnoringSafeArea(.top)
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
    } //: Image Tab View
    
    private var infoSection: some View {
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
        } //: VStack
    } //: Info Section
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description:")
                .modifier(TextMod(.title3, .semibold, .gray))
            
            Text("""
            Looking for a safe and convenient place to park your car? Look no further than my private driveway! Located in a quiet and secure residential area, my driveway is the perfect spot for anyone in need of a reliable parking space. Whether you're a commuter looking for a regular spot to park during the work week, or you need a place to leave your car while you're away on vacation, my driveway is available for rent on a short-term or long-term basis. With 24/7 access, you can park your vehicle with peace of mind knowing it's in a safe and monitored location. Contact me today to secure your spot!
            """)
            .multilineTextAlignment(.leading)
            .modifier(TextMod(.callout, .regular))
        } //: VStack
    } //: Description Section
    
    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amenities:")
                .modifier(TextMod(.title3, .semibold, .gray))
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.amenities) { amenity in
                    HStack(spacing: 8) {
                        Image(systemName: amenity.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16, alignment: .center)
                            .opacity(0.7)
                        
                        Text(amenity.title)
                            .modifier(TextMod(.headline, .regular))
                            .frame(width: 100, alignment: .leading)
                    } //: HStack
                } //: For Each
            } //: VGrid
        } //: VStack
    }
}

// MARK: - PREVEIW
struct SpotListingView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListingView()
    }
}

struct AmenityDetail: Identifiable {
    let id: UUID = UUID()
    let title, imageName: String
}
