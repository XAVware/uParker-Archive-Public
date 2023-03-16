//
//  SpotMapView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/14/23.
//

import SwiftUI
import MapboxMaps
import MapboxSearch
import MapboxSearchUI
import CoreLocation
import CoreLocationUI
import MapKit

@MainActor class SpotMapViewModel: NSObject, ObservableObject {
//    static let shared = SpotMapViewModel()
    @Published var listHeight: CGFloat = 120
    @Published var isShowingSettings: Bool = false
    @Published var isShowingSpot: Bool = false
    @Published var isShowingListing: Bool = false
    @Published var mapStyle: StyleURI = .streets
    
    @Published var selectedSpotId: String?
    
    let initialListHeight: CGFloat = 120
    @Published var maxListHeight: CGFloat = 0
    @Published var isListExpanded: Bool = false
    @Published var isListDragging = false
    @Published var prevDragTranslation: CGSize = CGSize.zero
    @Published var velocity: CGFloat = 0
    @GestureState var isDetectingLongPress = false
    
    @Published var location: CLLocation = CLLocation(latitude: 40.7934, longitude: -77.8600)
    @Published var region = MKCoordinateRegion()
    @Published var suggestionList: [SearchSuggestion] = []
    @Published var lastSelectedSuggestion: SimpleSuggestion?
    
    private let locationManager = CLLocationManager()
    
    let searchEngine = SearchEngine()
    var searchText: String = ""
    let mapSettingsColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var listCornerRad: CGFloat {
        if listHeight == initialListHeight {
            return 30
        } else if listHeight < maxListHeight {
            return 30 * (initialListHeight / listHeight)
        } else {
            return 0
        }
    }
    
    var threshold: CGFloat {
        return (maxListHeight - initialListHeight) / 2
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !self.isListDragging {
                    self.isListDragging = true
                }
                
                self.velocity = val.predictedEndLocation.y - val.location.y
                
                let dragAmount = val.translation.height - self.prevDragTranslation.height
                
                if self.listHeight >= self.maxListHeight && dragAmount > 0 {
                    self.listHeight += 0
                } else if self.listHeight < self.initialListHeight {
                    self.listHeight += dragAmount / 10
                } else {
                    self.listHeight += dragAmount
                }
                
                self.prevDragTranslation = val.translation
            }
            .onEnded { val in
                self.prevDragTranslation = CGSize.zero
                self.isListDragging = false
                
                if self.velocity > 200 {
                    self.expandList()
                } else if self.velocity < -200 {
                    self.compressList()
                }
                
                if self.listHeight >= self.threshold {
                    self.expandList()
                } else if self.listHeight < self.threshold {
                    self.compressList()
                }
            }
    }
    
    let mapStyles: [MapStyle] = [
        MapStyle(labelName: "Streets", imageName: "Style.streets"),
        MapStyle(labelName: "Satellite", imageName: "Style.satellite"),
        MapStyle(labelName: "Outdoors", imageName: "Style.outdoors"),
        MapStyle(labelName: "Light", imageName: "Style.light"),
        MapStyle(labelName: "Dark", imageName: "Style.dark")
    ]

    struct MapStyle: Identifiable {
        let id: UUID = UUID()
        let labelName: String
        let imageName: String
        
        var styleURI: StyleURI {
            switch labelName {
            case "Streets":
                return StyleURI.streets
            case "Outdoors":
                return StyleURI.outdoors
            case "Light":
                return StyleURI.light
            case "Dark":
                return StyleURI.dark
            case "Satellite":
                return StyleURI.satellite
            default:
                return StyleURI.streets
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        searchEngine.delegate = self
    }
    
    //May not need
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expandList() {
        withAnimation {
            listHeight = maxListHeight
            self.isListExpanded = true
        }
    }
    
    func compressList() {
        withAnimation {
            listHeight = initialListHeight
            self.isListExpanded = false
        }
    }
        
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setCenter(newLocation: CLLocation) {
        self.location = newLocation
    }
}

extension SpotMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        //5000 is a little over 3 miles
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
}

extension SpotMapViewModel: SearchEngineDelegate {
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

struct SpotMapView: View {
    // MARK: - PROPERTIES
    @StateObject var vm: SpotMapViewModel = SpotMapViewModel()
        
    @State private var originalDestination: String = "Beaver Stadium"
    
    @State private var searchIsExpanded: Bool = false
    @State private var destinationIsExpanded = true
    @State private var dateIsExpanded = false
    @State var destination: String = "Beaver Stadium"
    @State private var date: Date = Date()
    @State private var isShowingSuggestions: Bool = false {
        willSet(newValue) {
            if newValue == false && selectedSuggestion == nil && vm.suggestionList.count > 0 {
                vm.selectSuggestion(vm.suggestionList[0]) { sug in
                    selectedSuggestion = sug
                    destination = selectedSuggestion?.name ?? "Empty"
                }
            }
        }
    }
    
    @State var selectedSuggestion: SimpleSuggestion?
    
    @FocusState private var focusField: FocusText?
    
    
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
        if selectedSuggestion == nil && vm.suggestionList.count > 0 {
            vm.selectSuggestion(vm.suggestionList[0]) { sug in
                self.selectedSuggestion = sug
            }
        }
        
        guard self.selectedSuggestion != nil else {
            return
        }
        
        let location: CLLocation = CLLocation(latitude: selectedSuggestion!.coordinate.latitude, longitude: selectedSuggestion!.coordinate.longitude)
        vm.location = location
        closeSearch()
    }
    
    private func resetTapped() {
        self.destination = self.originalDestination
        self.date = Date()
        
        withAnimation {
            self.destinationIsExpanded = true
            self.dateIsExpanded = false
        }
    }

    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MapViewWrapper(center: $vm.location, mapStyle: $vm.mapStyle)
                    .environmentObject(vm)
                
                spotListView
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: vm.initialListHeight - geo.safeAreaInsets.top + searchBarHeight)
                        .padding(.top)
                    
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 10) {
                            Button {
                                vm.requestLocation()
                            } label: {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            }
                            .frame(width: 15)
                            
                            Divider()
                            
                            Button {
                                vm.isShowingSettings.toggle()
                            } label: {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            }
                            .frame(width: 15)
                            
                        } //: VStack
                        .frame(width: 35, height: 70)
                        .background(.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .opacity(vm.listHeight == vm.initialListHeight ? 1 : (1 - 0.1 * (vm.listHeight - vm.initialListHeight)))
                    } //: HStack
                    
                    Spacer()
                    
                    if vm.selectedSpotId != nil && vm.listHeight < 200 {
                        TabView {
                            ForEach(1..<5) { spot in
                                SpotPageView()
                                    .padding()
                                    .onTapGesture {
                                        vm.isShowingListing.toggle()
                                    }
                                
                            }
                        } //: Tab
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 130)
                    }
                } //: VStack
                .overlay(searchView)
                .sheet(isPresented: $vm.isShowingSettings) {
                    mapSettingsView
//                    MapSettingsView(mapStyle: $vm.mapStyle)
                        .presentationDetents([.fraction(0.65)])
                        .presentationDragIndicator(.hidden)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .fullScreenCover(isPresented: $vm.isShowingListing) {
                    SpotListingView()
                }
                .onAppear {
                    vm.maxListHeight = geo.size.height
                }
                
            } //: ZStack
        } //: Geometry Reader
    }
    
    @ViewBuilder private var searchView: some View {
        if searchIsExpanded {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        closeSearch()
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
                                    ForEach(vm.suggestionList, id: \.id) { suggestion in
                                        Button {
                                            vm.selectSuggestion(suggestion) { sug in
                                                self.selectedSuggestion = sug
                                            }
                                            destination = suggestion.name
                                            focusField = nil
                                        } label: {
                                            VStack(alignment: .leading) {
                                                Text(suggestion.name)
                                                    .modifier(TextMod(.footnote, .semibold))
                                                
                                                Text("\(suggestion.address?.formattedAddress(style: .medium) ?? "")")
                                                    .modifier(TextMod(.caption, .regular, .gray))
                                            }
                                            .background(.white)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        }
                                        
                                        Divider()
                                        
                                    } //: ForEach
                                } //: VStack
                                .padding(.horizontal, 8)
                                Spacer()
                            } //: ScrollView
                            
                        } //: VStack
                        .frame(height: 260)
                        .padding(.horizontal)
                    } //: If-Else
                    
                } label: {
                    SearchGroupHeader(header: "Where to?", isExpanded: $destinationIsExpanded, subtitle: $destination)
                } //: Disclosure Group
                .modifier(SearchCardMod())
                .onChange(of: destination, perform: { newValue in
                    vm.updateQuery(text: newValue)
                })
                .onChange(of: focusField) { newValue in
                    if newValue == .destination {
                        withAnimation {
                            isShowingSuggestions = true
                            dateIsExpanded = false
                        }
                        vm.updateQuery(text: destination)
                    } else if newValue == nil {
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
                            .modifier(TextMod(.headline, .semibold))
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
        } else {
            VStack {
                CompressedSearchBar(destination: $destination, date: $date)
                    .onTapGesture { searchBarTapped() }
                Spacer()
            } //: VStack
            .padding()
            .opacity(self.searchIsExpanded ? 0 : 1)
        }
    }
    
    
    private var spotListView: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                Spacer()
                
                if vm.listHeight < vm.threshold {
                    Text("List View")
                        .modifier(TextMod(.footnote, .semibold))
                        .opacity(vm.listHeight < vm.threshold ? ((vm.threshold - vm.listHeight) / (vm.threshold - vm.initialListHeight)) : ((vm.listHeight - vm.threshold) / (vm.maxListHeight - vm.threshold)))
                        .onTapGesture {
                            vm.expandList()
                        }
                        .gesture(vm.dragGesture)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(1..<6) { spot in
                                spotListItem
                            } //: ForEach
                        } //: VStack
                    } //: Scroll
                    .padding(.top, searchBarHeight)
                    .overlay (
                        Button {
                            vm.compressList()
                        } label: {
                            Image(systemName: "map.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                            
                            Text("Map")
                                .modifier(TextMod(.footnote, .semibold, .white))
                        }
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .frame(height: 35)
                            .background(backgroundGradient)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                            .opacity(vm.listHeight < vm.threshold ? ((vm.threshold - vm.listHeight) / (vm.threshold - vm.initialListHeight)) : ((vm.listHeight - vm.threshold) / (vm.maxListHeight - vm.threshold)))
                            .padding(.bottom)
                        , alignment: .bottom)
                }
                
                if vm.listHeight < vm.maxListHeight {
                    Capsule()
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 6)
                        .opacity(vm.isListDragging ? 1.0 : 0.6)
                        .padding(.bottom, 10)
                        .gesture(vm.isListExpanded ? nil : vm.dragGesture)
                }
                
            } //: VStack
            .frame(height: vm.listHeight)
            .frame(maxWidth: .infinity)
            .background (
                Color.white
                    .cornerRadius(vm.listCornerRad, corners: [.bottomLeft, .bottomRight])
                    .shadow(radius: vm.listHeight == vm.maxListHeight ? 0 : 5)
                    .mask(Rectangle().padding(.bottom, -20))
            )
            .transition(.move(edge: .top))
            .gesture(vm.isListExpanded ? nil : vm.dragGesture)
            .animation(.linear, value: true)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $vm.isShowingSpot) {
            SpotListingView()
        }
    }
    
    private var spotListItem: some View {
        VStack(alignment: .leading) {
            Image("driveway")
                .resizable()
                .scaledToFill()
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Spot Name")
                        .modifier(TextMod(.title3, .semibold))
                    
                    Text("State College, Pennsylvania")
                        .modifier(TextMod(.body, .semibold, .gray))
                        .padding(.bottom, 1)
                    
                    Text("$3.00 / Day")
                        .modifier(TextMod(.callout, .semibold))
                } //: VStack
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14)
                        
                        Text("4.92")
                            .modifier(TextMod(.callout, .regular))
                    } //: HStack
                    
                    Spacer()
                } //: VStack
            } //: HStack
        } //: VStack
        .padding()
        .padding(.horizontal)
        .onTapGesture {
            vm.isShowingSpot.toggle()
        }
    }
    
    private var mapSettingsView: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    Text("Map Settings")
                        .modifier(TextMod(.title, .semibold))
                    
                    Spacer()
                    
                    Button {
                        vm.isShowingSettings.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color(.systemGray4))
                    }
                    
                } //: HStack
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: vm.mapSettingsColumns, spacing: 20) {
                        ForEach(vm.mapStyles) { style in
                            ZStack {
                                Image(style.imageName)
                                    .resizable()
                                    .scaledToFill()
                                
                                VStack {
                                    Spacer()
                                    
                                    Text(style.labelName)
                                        .modifier(TextMod(.callout, vm.mapStyle == style.styleURI ? .bold : .regular))
                                        .padding()
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.ultraThickMaterial)
                                } //: VStack
                                
                            } //: ZStack
                            .frame(width: geo.size.width / 2 - 24, height: (geo.size.width / 2 - 24) * 0.70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryColor, lineWidth: vm.mapStyle == style.styleURI ? 1 : 0))
                            .onTapGesture {
                                vm.mapStyle = style.styleURI
                            }
                            
                        } //: ForEach
                    } //: VGrid
                    .padding(.top,8)
                } //: Scroll
                
                Spacer()
            } //: VStack
            .padding(.horizontal)
            .padding(.top)
        } //: Geometry Reader
    }
}

// MARK: - COMPRESSED SEARCH BAR
struct CompressedSearchBar: View {
    @Binding var destination: String
    @Binding var date: Date
    
    let iconSize: CGFloat = 15
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var dateText: String {
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Where to?")
                    .modifier(TextMod(.headline, .semibold))
                
                Text("\(destination) - \(dateText)")
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
        
    }
}

struct SpotPageView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Image("driveway")
                .resizable()
                .scaledToFill()
                .frame(width: 140, alignment: .center)
                .frame(maxHeight: .infinity)
                .clipped()
            
            
            VStack(alignment: .leading) {
                Text("$8.00 / Day")
                    .modifier(TextMod(.footnote, .semibold))
                    .frame(maxWidth: .infinity, alignment:.leading)
                
                Text(" 4.5 Stars")
                    .modifier(TextMod(.footnote, .semibold))
                    .frame(maxWidth: .infinity, alignment:.leading)
                
                Spacer()
                
                Text("Spot Name")
                    .modifier(TextMod(.caption, .regular))
                
            } //: VStack
            .padding(8)
            
            Spacer()
        } //: HStack
        .frame(height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}


// MARK: - VIEW WRAPPER
struct MapViewWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var vm: SpotMapViewModel
    @Binding var center: CLLocation
    @Binding var mapStyle: StyleURI
    
    var selectedPin: PinView? {
        willSet {
            if let newPin = newValue {
                guard vm.selectedSpotId != newPin.data.id else { print("Issue"); return }
                let newCenter = CLLocation(latitude: newPin.data.coordinate.coordinates.latitude, longitude: newPin.data.coordinate.coordinates.longitude)
                vm.setCenter(newLocation: newCenter)
            } else {
                print("Nil New Value")
            }
        }
    }

    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext< MapViewWrapper >) -> MapViewController {
        let mapView = MapViewController(center: center, mapStyle: mapStyle)

        mapView.delegate = self.makeCoordinator()
        return mapView
    }
    
    //From SwiftUI to UIKit
    func updateUIViewController(_ mapViewController: MapViewController, context: UIViewControllerRepresentableContext< MapViewWrapper >) {
        mapViewController.centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        mapViewController.changeMapStyle(to: mapStyle)
    }
    
    class Coordinator: NSObject, MapViewDelegate {
        var parent: MapViewWrapper

        init(_ parent: MapViewWrapper) {
            self.parent = parent
        }
        
        func selectPin(_ pin: PinView) {
            if let previousPin = parent.selectedPin {
                previousPin.isSelected = false
                previousPin.updateUI()
            }
            
            parent.selectedPin = pin
        }
    }
    
     //From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - CONTROLLER
public class MapViewController: UIViewController {
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    var selectedPin: PinView?
    var mapStyle: StyleURI
    var delegate: MapViewDelegate?
    let markers: [PinModel] = [
        PinModel(id: "Spot_ID", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)), price: 3.00),
        PinModel(id: "Spot_ID2", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7820, longitude: -77.8505)), price: 40.00)
    ]
    
    var cameraOptions: CameraOptions {
        return CameraOptions(center: centerLocation, zoom: 12, bearing: -17.6, pitch: 0)
    }
    
    var centerLocation: CLLocationCoordinate2D {
        didSet { mapView.camera.fly(to: cameraOptions, duration: 1) }
    }
    
    // MARK: - INITIALIZER
    init(center: CLLocation, mapStyle: StyleURI) {
        centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        self.mapStyle = mapStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
        
        self.markers.forEach { marker in
            let options = ViewAnnotationOptions(
                geometry: marker.coordinate,
                allowOverlap: true,
                visible: true,
                //                anchor: .bottom,
                offsetY: 0)
            
            let pin = PinView(pin: marker)
            pin.delegate = self.delegate
            try? mapView.viewAnnotations.add(pin, options: options)
        }
    }
    
    func changeMapStyle(to style: StyleURI) {
        self.mapStyle = style
        mapView.mapboxMap.loadStyleURI(mapStyle)
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions, styleURI: self.mapStyle)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
    }
    
}

public protocol MapViewDelegate: AnyObject {
    func selectPin(_ pin: PinView)
}


// MARK: - ANNOTATION VIEW
public class PinView: UIView {
    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 26)
    var isSelected: Bool = false
    weak var delegate: MapViewDelegate?
    let data: PinModel
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: annotationFrame)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func getFormattedPrice(price: Double) -> NSMutableAttributedString {
        let dollarSignFont: UIFont = UIFont.systemFont(ofSize: 10)
        let spaceFont: UIFont = UIFont.systemFont(ofSize: 6)
        let priceFont: UIFont = UIFont.boldSystemFont(ofSize: price < 100.0 ? 14 : 12)
        
        let labelText = "$ \(String(format: "%.2f", price))"
        
        let attString = NSMutableAttributedString(string: labelText)
        attString.addAttribute(.font, value: dollarSignFont, range: NSRange(location: 0, length: 1))
        attString.addAttribute(.font, value: spaceFont, range: NSRange(location: 1, length: 1))
        attString.addAttribute(.font, value: priceFont, range: NSRange(location: 2, length: labelText.count - 2))
        attString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: 1))
        
        return attString
    }
    
    func initializeBackground() {
        self.backgroundColor = UIColor(named: "uParkerBlue")!
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = annotationFrame.height / 2
        self.layer.borderColor = UIColor(named: "uParkerBlue")!.cgColor
        self.layer.borderWidth = 1
    }
    
    init(pin: PinModel) {
        data = pin
        super.init(frame: annotationFrame)
        initializeBackground()
        
        priceLabel.attributedText = getFormattedPrice(price: data.price)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        self.addSubview(priceLabel)
        
    }
    
    func updateUI() {
        self.backgroundColor = isSelected ? UIColor.white : UIColor(named: "uParkerBlue")!
        self.priceLabel.textColor = isSelected ? UIColor(named: "uParkerBlue")! : UIColor.white
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard delegate != nil else {
            print("No PinView Delegate Found")
            return
        }
        
        self.delegate?.selectPin(self)

        self.isSelected.toggle()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
