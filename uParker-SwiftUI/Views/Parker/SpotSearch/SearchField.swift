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
    @State var destination: String = "Beaver Stadium"
    @State private var date: Date = Date()
    @State private var isShowingSuggestions: Bool = false
    
    var selectedSuggestion: SimpleSuggestion?
    
    @FocusState private var focusField: FocusText?
    
    @ObservedObject var suggestionController: SuggestionController = SuggestionController()
    
    enum FocusText { case destination }
    
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
        print(suggestionController.lastSelectedSuggestion)
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
                
                DisclosureGroup(isExpanded: $destinationIsExpanded) {
                    AnimatedTextField(boundTo: $destination, placeholder: "Destination")
                        .padding(8)
                        .focused($focusField, equals: .destination)
                    
                    if isShowingSuggestions {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Suggestions")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Divider()
                                .padding(.bottom, 5)
                            
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading) {
                                    ForEach(suggestionController.suggestionList, id: \.id) { suggestion in
                                        Button {
                                            suggestionController.selectSuggestion(suggestion)
                                            destination = suggestion.name
                                            focusField = nil
                                        } label: {
                                            VStack(alignment: .leading) {
                                                Text(suggestion.name)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)
                                                
                                                Text("\(suggestion.address?.formattedAddress(style: .medium) ?? "")")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            .background(.white)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        }
                                        
                                        Divider()
                                        
                                    } //: ForEach
                                }
                                .padding(.horizontal, 8)
                                Spacer()
                            }
                            
                        } //: VStack
                        .frame(height: 260)
                        .padding(.horizontal)
                    } //: If-Else
                    
                } label: {
                    SearchGroupHeader(header: "Where to?", isExpanded: $destinationIsExpanded, subtitle: $destination)
                } //: Disclosure Group
                .modifier(SearchCardMod())
                .onChange(of: destination, perform: { newValue in
                    suggestionController.updateQuery(text: newValue)
                })
                .onChange(of: focusField) { newValue in
                    if newValue == .destination {
                        withAnimation {
                            isShowingSuggestions = true
                            dateIsExpanded = false
                        }
                        suggestionController.updateQuery(text: destination)
                    } else if newValue == nil {
                        print(suggestionController.lastSelectedSuggestion?.name)
                        withAnimation {
                            isShowingSuggestions = false
                        }
                    } else {
                        print("Error: Different focusField value in Search field.")
                    }
                }
                
                
                // MARK: - DATE
                DisclosureGroup(isExpanded: $dateIsExpanded) {
                    DatePicker("", selection: $date, in: dateClosedRange, displayedComponents: [.date])
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
                .onChange(of: dateIsExpanded) { newValue in
                    if newValue == true {
                        focusField = nil
                    }
                }
                
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
            .ignoresSafeArea(.keyboard)
            .animation(.linear, value: true)
        } else {
            // MARK: - SEARCH BAR
            VStack {
                CompressedSearchBar(destination: $destination, date: $date)
                    .onTapGesture { searchBarTapped() }
                Spacer()
            } //: VStack
            .padding()
            .opacity(self.searchIsExpanded ? 0 : 1)
        }
        
    }
}

// MARK: - PREVIEW
//struct SearchField_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchField()
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
