//
//  SearchView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/16/23.
//

import SwiftUI
import MapboxSearch
import MapboxSearchUI
import CoreLocation
import CoreLocationUI
import MapKit

@MainActor class SearchViewModel: NSObject, ObservableObject {
    let searchEngine = SearchEngine()
    var searchText: String = ""
    
    @Published var originalDestination: String = "Beaver Stadium"
    @Published var destination: String = "Beaver Stadium" {
        willSet(newDestination) {
            updateQuery(text: newDestination)
        }
    }
    @Published var searchIsExpanded: Bool = false
    @Published var destinationIsExpanded = true
    @Published var dateIsExpanded = false
    @Published var priceIsExpanded = false
    @Published var date: Date = Date() {
        didSet {
            if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
                dateText = "Today"
            } else {
                dateText = dateFormatter.string(from: date)
            }
        }
    }
    
    @Published var suggestionList: [SearchSuggestion] = []
    @Published var lastSelectedSuggestion: SimpleSuggestion?
    @Published var selectedSuggestion: SimpleSuggestion?
    @Published var isShowingSuggestions: Bool = false {
        willSet(newValue) {
            if newValue == false && selectedSuggestion == nil && suggestionList.count > 0 {
                selectSuggestion(suggestionList[0]) { sug in
                    self.selectedSuggestion = sug
                    self.destination = self.selectedSuggestion?.name ?? "Empty"
                }
            }
        } didSet {
            if isShowingSuggestions == true {
                updateQuery(text: destination)
            }
        }
    }
    
    @Published var selectedMinPrice: String = "No Min"
    @Published var selectedMaxPrice: String = "No Max"
    let minPrices: [String] = ["No Min", "$5.00", "$10.00", "$15.00", "$20.00", "$30.00", "$40.00", "$50.00", "$60.00", "$70.00", "$90.00", "$100.00"]
    let maxPrices: [String] = ["$5.00", "$10.00", "$15.00", "$20.00", "$30.00", "$40.00", "$50.00", "$60.00", "$70.00", "$90.00", "$100.00", "No Max"]
    
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
    
    @Published var dateText: String = "Today"
    @Published var priceText: String = "No Min - No Max"
    @Published var amenityOptions: [AmenityDetail]
//    var dateText: String {
//        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
//            return "Today"
//        } else {
//            return dateFormatter.string(from: date)
//        }
//    }
    
    override init() {
        amenityOptions = spotAmenities
        super.init()
        searchEngine.delegate = self
        
    }
    
    //May not need
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBarTapped() {
        withAnimation {
            self.searchIsExpanded = true
        }
    }
    
    func closeSearch() {
        withAnimation {
            self.searchIsExpanded = false
        }
        self.destinationIsExpanded = true
        self.dateIsExpanded = false
    }
    
    func searchTapped() -> CLLocation {
        if selectedSuggestion == nil && suggestionList.count > 0 {
            selectSuggestion(suggestionList[0]) { sug in
                self.selectedSuggestion = sug
            }
        }
        
        guard self.selectedSuggestion != nil else {
            print("No Suggestion Selected, returning default penn state")
            return CLLocation(latitude: 40.7934, longitude: -77.8600)
        }
        
        closeSearch()
        return CLLocation(latitude: selectedSuggestion!.coordinate.latitude, longitude: selectedSuggestion!.coordinate.longitude)
    }
    
    func resetTapped() {
        self.destination = self.originalDestination
        self.date = Date()
        
        withAnimation {
            self.destinationIsExpanded = true
            self.dateIsExpanded = false
        }
    }
}


extension SearchViewModel: SearchEngineDelegate {
    func selectSuggestion(_ suggestion: SearchSuggestion, completion: @escaping (SimpleSuggestion?) -> Void) {
        searchEngine.select(suggestion: suggestion)
        
        DispatchQueue.main.async {
            guard self.lastSelectedSuggestion != nil else {return}
            completion(self.lastSelectedSuggestion)
        }
    }
    
    @objc func updateQuery(text: String) {
        searchEngine.query = text
    }

    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        self.suggestionList = suggestions
    }
     
    // MARK: - SEARCH ENGINE DELEGATE METHODS
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        dumpSuggestions(suggestions, query: searchEngine.query)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        lastSelectedSuggestion = SimpleSuggestion(name: result.name, address: result.address, coordinate: result.coordinate, categories: result.categories)
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
}

struct SearchView: View {
    // MARK: - PROPERTIES
    @ObservedObject var observedVM: MapViewModel
    @StateObject var vm: SearchViewModel = SearchViewModel()
    @FocusState private var focusField: FocusText?
    @ObservedObject var slider = CustomSlider(start: 10, end: 100)
    enum FocusText { case destination }
    
    var body: some View {
        VStack {
            if vm.searchIsExpanded {
                searchView
            } else {
                VStack {
                    compressedSearchBar
                        .onTapGesture {
                            observedVM.selectedSpotId = nil
                            vm.searchBarTapped()
                        }
                    Spacer()
                } //: VStack
                .padding()
                .opacity(vm.searchIsExpanded ? 0 : 1)
            } //: If-Else
        } //: VStack
    } //: Body

    private var searchView: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    vm.closeSearch()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                }
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(.gray))
                
                Text("Search")
                    .modifier(TextMod(.title3, .semibold, .gray))
                    .frame(maxWidth: .infinity)
                
                Spacer().frame(width: 30)
            } //: HStack
            
            // MARK: - DESTINATION
            DisclosureGroup(isExpanded: $vm.destinationIsExpanded) {
                AnimatedTextField(boundTo: $vm.destination, placeholder: "Destination")
                    .padding(8)
                    .focused($focusField, equals: .destination)
                
                if vm.isShowingSuggestions {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Suggestions")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Divider()
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(vm.suggestionList, id: \.id) { suggestion in
                                    Button {
                                        vm.selectSuggestion(suggestion) { sug in
                                            vm.selectedSuggestion = sug
                                        }
                                        vm.destination = suggestion.name
                                        focusField = nil
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(suggestion.name)
                                                .modifier(TextMod(.footnote, .semibold))
                                            
                                            Text("\(suggestion.address?.formattedAddress(style: .medium) ?? "") \(suggestion.address?.region ?? "")")
                                                .modifier(TextMod(.caption, .regular, .gray))
                                        }
                                        .background(.white)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    }
                                    
                                    Divider()
                                    
                                } //: ForEach
                            } //: VStack
                            .padding(.top, 8)
//                            .padding(.horizontal, 8)
                            Spacer()
                        } //: ScrollView
                        
                    } //: VStack
                    .frame(height: 260)
                    .padding(.horizontal)
                } //: If-Else
                
            } label: {
                SearchGroupHeader(header: "Where to?", isExpanded: $vm.destinationIsExpanded, subtitle: $vm.destination)
            } //: Disclosure Group
            .modifier(SearchCardMod())
            .onChange(of: focusField) { newValue in
                withAnimation {
                    switch newValue {
                    case .destination:
                        vm.isShowingSuggestions = true
                        vm.dateIsExpanded = false
                    case .none:
                        vm.isShowingSuggestions = false
                    }
                }
            }
            .animation(.linear, value: true)
            
            
            // MARK: - DATE
            DisclosureGroup(isExpanded: $vm.dateIsExpanded) {
                DatePicker("", selection: $vm.date, in: vm.dateClosedRange, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding(.top)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    .clipped()
                
            } label: {
                SearchGroupHeader(header: "When?", isExpanded: $vm.dateIsExpanded, subtitle: $vm.dateText)
            } //: Disclosure Group
            .modifier(SearchCardMod())
            .onChange(of: vm.dateIsExpanded) { newValue in
                if newValue == true {
                    focusField = nil
                }
            }
            
            // MARK: - PRICE RANGE
            DisclosureGroup(isExpanded: $vm.priceIsExpanded) {
                HStack(alignment: .center) {
                    Picker("", selection: $vm.selectedMinPrice) {
                        ForEach(vm.minPrices, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Text("-")
                    
                    Picker("", selection: $vm.selectedMaxPrice) {
                        ForEach(vm.maxPrices, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                } //: HStack
                .frame(height: 150)
            } label: {
                SearchGroupHeader(header: "Price Range", isExpanded: $vm.priceIsExpanded, subtitle: $vm.priceText)
            } //: Disclosure Group
            .modifier(SearchCardMod())
            .onChange(of: vm.dateIsExpanded) { newValue in
                if newValue == true {
                    focusField = nil
                }
            }
            .onChange(of: vm.selectedMinPrice) { newMin in
                vm.priceText = "\(newMin) - \(vm.selectedMaxPrice)"
            }
            .onChange(of: vm.selectedMaxPrice) { newMax in
                vm.priceText = "\(vm.selectedMinPrice) - \(newMax)"
            }
            
            Spacer()
        } //: VStack
        .padding()
        .background(.ultraThinMaterial)
        .opacity(vm.searchIsExpanded ? 1 : 0)
        .overlay(
            HStack {
                Button {
                    vm.resetTapped()
                } label: {
                    Text("Reset")
                        .underline()
                        .font(.callout)
                        .padding()
                }
                .frame(maxWidth: 100)
                
                Spacer()
                
                Button {
                    
                    observedVM.location = vm.searchTapped()
//                    vm.searchTapped()
                } label: {
                    HStack(spacing: 15) {
                        Text("Search")
                            .modifier(TextMod(.callout, .semibold, .white))
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    }
                }
                .foregroundColor(.white)
                .frame(width: 150, height: 45)
                .background(backgroundGradient)
                .clipShape(Capsule())
                .shadow(radius: 4)
                
            } //: HStack
                .padding()
            , alignment: .bottom)
        .ignoresSafeArea(.keyboard)
        .animation(.linear, value: true)
    }
    
    private var compressedSearchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Where to?")
                    .modifier(TextMod(.headline, .semibold))
                
                Text("\(vm.destination) - \(vm.dateText)")
                    .modifier(TextMod(.caption, .regular))
            } //: VStack
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                //
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
            }
            .frame(width: 35, height: 35)
            .overlay(Circle().stroke(.gray))
        } //: HStack
        .padding(.horizontal)
        .frame(height: searchBarHeight)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: searchBarHeight))
        .shadow(radius: 4)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(observedVM: MapViewModel())
    }
}
