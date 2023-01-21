//
//  SearchField.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/9/23.
//

import SwiftUI
import MapboxSearch
import MapboxSearchUI

struct SearchField: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var locationManager: LocationManager
    let iconSize: CGFloat = 15
    
    @State private var searchIsExpanded: Bool = false
    @State private var destinationIsExpanded = true
    @State private var dateIsExpanded = false
    @State private var destination: String = "Beaver Stadium"
    @State private var date: Date = Date()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 180, to: Date())!
        return min...max
    }
    
    var dateText: String {
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    // MARK: - FUNCTIONS
    private func searchBarTapped() {
        withAnimation {
            self.searchIsExpanded = true
        }
    }
    
    private func closeSearch() {
        withAnimation {
            self.searchIsExpanded = false
        }
        self.destinationIsExpanded = true
        self.dateIsExpanded = false
    }
    
    private func searchTapped() {
        closeSearch()
    }
    
    private func resetTapped() {
        self.destination = "Beaver Stadium"
        self.date = Date()
        
        withAnimation {
            self.destinationIsExpanded = true
            self.dateIsExpanded = false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        if self.searchIsExpanded {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        closeSearch()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                    }
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(.gray))
                    
                    Text("Search")
                        .modifier(SmallTitleMod())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(width: 30)
                } //: HStack
                
                // MARK: - DESTINATION
                
                VStack {
                    Text("Where to?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    AnimatedTextField(boundTo: $destination, placeholder: "Destination")
                        .padding(.top)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                    
                    SearchViewWrapper(searchText: $destination)
                    
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 500)
                .background(.white)
                
//                DisclosureGroup(isExpanded: $destinationIsExpanded) {
//                    AnimatedTextField(boundTo: $destination, placeholder: "Destination")
//                        .padding(.top)
//                        .padding(.horizontal, 8)
//                        .padding(.bottom, 8)
//                } label: {
//                    HStack {
//                        Text("Where to?")
//                            .font(.headline)
//                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        if !destinationIsExpanded {
//                            Text(destination)
//                                .font(.footnote)
//                        }
//                    } //: HStack
//                } //: Disclosure Group
//                .modifier(SearchCardMod())
                
                // MARK: - DATE
                DisclosureGroup(isExpanded: $dateIsExpanded) {
                    DatePicker( "Pick a date", selection: $date, in: dateClosedRange, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.top)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .clipped()
                } label: {
                    HStack {
                        Text("When?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !dateIsExpanded {
                            Text(dateText)
                                .font(.footnote)
                        }
                    } //: HStack
                } //: Disclosure Group
                .modifier(SearchCardMod())
                
                Spacer()
            } //: VStack
            .padding()
            .background(.ultraThinMaterial)
            .opacity(self.searchIsExpanded ? 1 : 0)
            .overlay(
                HStack {
                    Button {
                        resetTapped()
                    } label: {
                        Text("Reset")
                            .underline()
                            .font(.callout)
                            .padding()
                    }
                    .frame(maxWidth: 100)
                    
                    Spacer()
                    
                    Button {
                        searchTapped()
                    } label: {
                        HStack(spacing: 15) {
                            Text("Search")
                            
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize)
                        }
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(width: 150, height: 45)
                    .background(backgroundGradient)
                    .clipShape(Capsule())
                    .shadow(radius: 4)
                    
                } //: HStack
                    .padding()
                , alignment: .bottom)
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
                            .modifier(SmallTitleMod())
                        
                        Text("\(destination) - \(dateText)")
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
                .clipShape(RoundedRectangle(cornerRadius: searchBarHeight))
                .shadow(radius: 4)
                .onTapGesture {
                    searchBarTapped()
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
            .padding()
    }
}

