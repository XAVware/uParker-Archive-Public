//
//  SearchField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI

struct SearchField: View {
    // MARK: - PROPERTIES
    let iconSize: CGFloat = 15
    
    @State private var searchIsExpanded: Bool = false
    @State private var destinationIsExpanded = true
    @State private var dateIsExpanded = false
    @State private var destination: String = "Beaver Stadium"
    @State private var date: String = "Today"
    
    // MARK: - BODY
    var body: some View {
        if self.searchIsExpanded {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        withAnimation {
                            self.searchIsExpanded = false
                        }
                        self.destinationIsExpanded = true
                        self.dateIsExpanded = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                    }
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(.gray))
                    
                    Text("Search")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(width: 30)
                } //: HStack
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Where to?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !destinationIsExpanded {
                            Text(destination)
                                .font(.footnote)
                        }
                    }
                    
                    if destinationIsExpanded {
                        AnimatedTextField(boundTo: $destination, placeholder: "Destination")
                    }
                } //: VStack
                .padding(.horizontal)
                .frame(height: self.destinationIsExpanded ? 140 : 60)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                .shadow(radius: 4)
                .onTapGesture {
                    withAnimation {
                        self.destinationIsExpanded = true
                        self.dateIsExpanded = false
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("When?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(date)
                            .font(.footnote)
                    }
                    
                } //: VStack
                .padding(.horizontal)
                .frame(height: self.dateIsExpanded ? 140 : 60)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                .shadow(radius: 4)
                .onTapGesture {
                    withAnimation {
                        self.destinationIsExpanded = false
                        self.dateIsExpanded = true
                    }
                }
                
                Spacer()
            } //: VStack
            .padding()
            .animation(.linear, value: true)
            .background(.ultraThinMaterial)
            .opacity(self.searchIsExpanded ? 1 : 0)
        } else {
            // MARK: - SEARCH BAR
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize)
                    
                    VStack(alignment: .leading) {
                        Text("Where to?")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("\(destination) - \(date)")
                            .font(.caption)
                    } //: VStack
                    .fontDesign(.rounded)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                    }
                    .frame(width: 35, height: 35)
                    .overlay(Circle().stroke(.gray))
                } //: HStack
                .padding(.horizontal)
                .frame(height: searchBarHeight)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: searchBarHeight)
                )
                .shadow(radius: 4)
                .onTapGesture {
                    withAnimation {
                        self.searchIsExpanded = true
                    }
                }
                
                Spacer()
            } //: VStack
            .padding()
            .opacity(self.searchIsExpanded ? 0 : 1)
        }
        
    }
}

// MARK: - PREVIEW
struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField()
            .previewLayout(.sizeThatFits)
        //            .background(.blue)
            .padding()
    }
}
