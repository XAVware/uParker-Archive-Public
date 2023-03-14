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

@MainActor class SpotMapViewModel: ObservableObject {
    
}

struct SpotMapView: View {
    // MARK: - PROPERTIES
    @StateObject var locationManager = LocationManager.shared
    @StateObject var vm: SpotMapViewModel = SpotMapViewModel()
    
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
                    
                    if selectedSpotId != nil && listHeight < 200 {
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
                .fullScreenCover(isPresented: $isShowingListing) {
                    SpotListingView()
                }
                
            } //: ZStack
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

// MARK: - VIEW WRAPPER
struct MapViewWrapper: UIViewControllerRepresentable {
    @Binding var center: CLLocation
    @Binding var mapStyle: StyleURI
    @Binding var selectedSpotId: String?
    
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext< MapViewWrapper >) -> MapViewController {
        return MapViewController(center: center, mapStyle: mapStyle)
    }
    
    func updateUIViewController(_ mapViewController: MapViewController, context: UIViewControllerRepresentableContext< MapViewWrapper >) {
        mapViewController.centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        mapViewController.changeMapStyle(to: mapStyle)
        if let pin = mapViewController.selectedPin {
            guard self.selectedSpotId != pin.data.id else { return }
            self.selectedSpotId = pin.data.id
        }
    }
}

// MARK: - CONTROLLER
public class MapViewController: UIViewController {
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    var selectedPin: PinView?
    var mapStyle: StyleURI
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
                anchor: .bottom,
                offsetY: 0)
            
            let pin = PinView(pin: marker)
            pin.delegate = self
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

// MARK: - PIN VIEW DELEGATE
extension MapViewController: PinViewInteractionDelegate {
    public func didSelectPin(_ pin: PinView) {
        if let previousPin = self.selectedPin {
            previousPin.isSelected = false
            previousPin.updateUI()
        }
        
        self.selectedPin = pin
        let newCenter = CLLocation(latitude: pin.data.coordinate.coordinates.latitude, longitude: pin.data.coordinate.coordinates.longitude)
        LocationManager.shared.setCenter(newLocation: newCenter)
    }
}

public protocol PinViewInteractionDelegate: AnyObject {
    func didSelectPin(_ pin: PinView)
}

struct MapSettingsView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @Binding var mapStyle: StyleURI
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    Text("Map Settings")
                        .modifier(TextMod(.title, .semibold))
                    
                    Spacer()
                    
                    Button {
                        self.dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color(.systemGray4))
                    }

                } //: HStacl
                
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(mapStyles) { style in
                            ZStack {
                                Image(style.imageName)
                                    .resizable()
                                    .scaledToFill()

                                VStack {
                                    Spacer()

                                    Text(style.labelName)
                                        .modifier(TextMod(.callout, self.mapStyle == style.styleURI ? .bold : .regular))
                                        .padding()
                                        .frame(height: 45)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.ultraThickMaterial)
                                } //: VStack

                            } //: ZStack
                            .frame(width: geo.size.width / 2 - 24, height: (geo.size.width / 2 - 24) * 0.70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryColor, lineWidth: self.mapStyle == style.styleURI ? 1 : 0))
                            .onTapGesture {
                                self.mapStyle = style.styleURI
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

struct SearchField: View {
    // MARK: - PROPERTIES
    @State private var originalDestination: String = "Beaver Stadium"
    
    @State private var searchIsExpanded: Bool = false
    @State private var destinationIsExpanded = true
    @State private var dateIsExpanded = false
    @State var destination: String = "Beaver Stadium"
    @State private var date: Date = Date()
    @State private var isShowingSuggestions: Bool = false {
        willSet(newValue) {
            if newValue == false && selectedSuggestion == nil && LocationManager.shared.suggestionList.count > 0 {
                LocationManager.shared.selectSuggestion(LocationManager.shared.suggestionList[0]) { sug in
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
        if selectedSuggestion == nil && LocationManager.shared.suggestionList.count > 0 {
            LocationManager.shared.selectSuggestion(LocationManager.shared.suggestionList[0]) { sug in
                self.selectedSuggestion = sug
            }
        }
        
        guard self.selectedSuggestion != nil else {
            return
        }
        
        let location: CLLocation = CLLocation(latitude: selectedSuggestion!.coordinate.latitude, longitude: selectedSuggestion!.coordinate.longitude)
        LocationManager.shared.location = location
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
        if self.searchIsExpanded {
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
                                    ForEach(LocationManager.shared.suggestionList, id: \.id) { suggestion in
                                        Button {
                                            LocationManager.shared.selectSuggestion(suggestion) { sug in
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
                    LocationManager.shared.updateQuery(text: newValue)
                })
                .onChange(of: focusField) { newValue in
                    if newValue == .destination {
                        withAnimation {
                            isShowingSuggestions = true
                            dateIsExpanded = false
                        }
                        LocationManager.shared.updateQuery(text: destination)
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

struct SpotListView: View {
    // MARK: - PROPERTIES
    @State private var isExpanded: Bool = false
    @State private var isDragging = false
    @State private var prevDragTranslation: CGSize = CGSize.zero
    @State private var velocity: CGFloat = 0
    @State private var isShowingSpot: Bool = false
    @GestureState var isDetectingLongPress = false
    
    @Binding var viewHeight: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    private var viewButtonOpacity: CGFloat {
        if viewHeight < threshold {
            return (threshold - viewHeight) / (threshold - minHeight)
        } else {
            return (viewHeight - threshold) / (maxHeight - threshold)
        }
    }
    
    private var listCornerRad: CGFloat {
        if viewHeight == minHeight {
            return 30
        } else if viewHeight < maxHeight {
            
            return 30 * (minHeight / viewHeight)
        } else {
            return 0
        }
    }
    
    private var listShadowRad: CGFloat {
        if viewHeight == maxHeight {
            return 0
        } else {
            return 5
        }
    }
    
    private var threshold: CGFloat {
        return (maxHeight - minHeight) / 2
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    self.isDragging = true
                }
                
                velocity = val.predictedEndLocation.y - val.location.y

                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if viewHeight >= maxHeight && dragAmount > 0 {
                    viewHeight += 0
                } else if viewHeight < minHeight {
                    viewHeight += dragAmount / 10
                } else {
                    viewHeight += dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = CGSize.zero
                isDragging = false
                
                if velocity > 200 {
                    expandList()
                } else if velocity < -200 {
                    compressList()
                }
                
                if viewHeight >= threshold {
                    expandList()
                } else if viewHeight < threshold {
                    compressList()
                }
            }
    }
    
    // MARK: - FUNCTIONS
    func expandList() {
        withAnimation {
            viewHeight = maxHeight
            self.isExpanded = true
        }
    }
    
    func compressList() {
        withAnimation {
            viewHeight = minHeight
            self.isExpanded = false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                Spacer()
                
                if viewHeight < threshold {
                    Text("List View")
                        .modifier(TextMod(.footnote, .semibold))
                        .opacity(viewButtonOpacity)
                        .onTapGesture {
                            expandList()
                        }
                        .gesture(dragGesture)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(1..<6) { spot in
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
                                    isShowingSpot.toggle()
                                }
                            } //: VStack
                        } //: ForEach
                    } //: Scroll
                    .padding(.top, searchBarHeight)
                    .overlay (
                        Button {
                            compressList()
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
                        .opacity(viewButtonOpacity)
                        .padding(.bottom)
                    , alignment: .bottom)
                }
                
                if viewHeight < maxHeight {
                    Capsule()
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 6)
                        .opacity(self.isDragging ? 1.0 : 0.6)
                        .padding(.bottom, 10)
                        .gesture(isExpanded ? nil : dragGesture)
                }
                
            } //: VStack
            .frame(height: viewHeight)
            .frame(maxWidth: .infinity)
            .background (
                Color.white
                    .cornerRadius(listCornerRad, corners: [.bottomLeft, .bottomRight])
                    .shadow(radius: listShadowRad)
                    .mask(Rectangle().padding(.bottom, -20))
            )
            .transition(.move(edge: .top))
            .gesture(isExpanded ? nil : dragGesture)
            .animation(.linear, value: true)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $isShowingSpot) {
            SpotListingView()
        }
        
    } //: Body
} //: Struct

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

// MARK: - ANNOTATION VIEW
public class PinView: UIView {
    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 26)
    var isSelected: Bool = false
    weak var delegate: PinViewInteractionDelegate?
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
        //Returns a String that has a small & offset dollar sign, a small space to act as padding between the dollar sign and the price, and the price in bold which automatically adjusts its font size based on the length of the price. With a frame that is 60 wide and 26 tall, the price label touches the edges if the price has 3 digits before the decimal.
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
        
        self.delegate?.didSelectPin(self)
        
        self.isSelected.toggle()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
