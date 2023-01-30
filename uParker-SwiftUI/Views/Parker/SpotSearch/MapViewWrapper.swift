//
//  MapViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

public class MapViewController: UIViewController, AnnotationInteractionDelegate {
    public func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        print(annotations[0])
    }
    
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    
    //    var geocoder: MBGeocoder = MBGeocoder()
    
    var centerLocation: CLLocationCoordinate2D {
        didSet {
            mapView.camera.fly(to: cameraOptions, duration: 1)
        }
    }
    
    let pennStateCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    
    var cameraOptions: CameraOptions {
        return CameraOptions(center: centerLocation, zoom: 12, bearing: -17.6, pitch: 0)
    }
    
    // MARK: - INITIALIZER
    init(center: CLLocation) {
        centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initializeMap()
        //        addViewAnnotation(at: CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600))
        //        addPins()
    }
    
    //    private func addPins() {
    //        geocoder.setFocalArea(pennStateCoordinates)
    //        geocoder.getCoordinates(forAddress: "100 East Beaver Ave, State College, PA") { result in
    //            guard result != nil else {
    //                print("Result is empty")
    //                return
    //            }
    //
    //            self.addViewAnnotation(at: result!)
    //        }
    //    }
    
    private var pointList: [Feature] = []
    var markerID = 0
    
    private let image = UIImage(named: "red_pin")!
    private lazy var markerHeight: CGFloat = image.size.height
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onMapLongClick)))
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        
        addMarkerAndAnnotation(at: mapView.mapboxMap.coordinate(for: mapView.center))
        
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            print("Called")
//            Seems to only call once. Maybe wait to add annotations until here?
//            self.finish()
        }
        
        mapView.mapboxMap.onEvery(event: .styleLoaded) { [weak self] _ in
            self?.prepareStyle()
        }
                
    }
    
    // MARK: - Action handlers
    
    @objc private func onMapLongClick(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .ended else { return }
        let point = Point(mapView.mapboxMap.coordinate(for: sender.location(in: mapView)))
        _ = addMarker(at: point)
    }
    
    @objc private func onMapClick(_ sender: UITapGestureRecognizer) {
        let screenPoint = sender.location(in: mapView)
        let queryOptions = RenderedQueryOptions(layerIds: ["layer_id"], filter: nil)
        mapView.mapboxMap.queryRenderedFeatures(with: screenPoint, options: queryOptions) { [weak self] result in
            if case let .success(queriedFeatures) = result,
               let self = self,
               let feature = queriedFeatures.first?.feature,
               let id = feature.identifier,
               case let .string(idString) = id,
               let viewAnnotations = self.mapView.viewAnnotations {
                if let annotationView = viewAnnotations.view(forFeatureId: idString) {
                    let visible = viewAnnotations.options(for: annotationView)?.visible ?? true
                    try? viewAnnotations.update(annotationView, options: ViewAnnotationOptions(visible: !visible))
                } else {
                    let markerCoordinates: CLLocationCoordinate2D
                    if let geometry = feature.geometry, case let Geometry.point(point) = geometry {
                        markerCoordinates = point.coordinates
                    } else {
                        markerCoordinates = self.mapView.mapboxMap.coordinate(for: screenPoint)
                    }
                    self.addViewAnnotation(at: markerCoordinates, withMarkerId: idString)
                }
            }
        }
    }
    
    @objc private func styleChangePressed(sender: UIButton) {
        mapView.mapboxMap.style.uri = mapView.mapboxMap.style.uri == .streets ? .satelliteStreets : .streets
    }
    
    // MARK: - Style management
    
    private func prepareStyle() {
        let style = mapView.mapboxMap.style
        try? style.addImage(image, id: "blue")
        
        var source = GeoJSONSource()
        source.data = .featureCollection(FeatureCollection(features: pointList))
        try? mapView.mapboxMap.style.addSource(source, id: "source_id")
        
        if style.uri == .satelliteStreets {
            var demSource = RasterDemSource()
            demSource.url = "mapbox://mapbox.mapbox-terrain-dem-v1"
            try? mapView.mapboxMap.style.addSource(demSource, id: "TERRAIN_SOURCE")
            let terrain = Terrain(sourceId: "TERRAIN_SOURCE")
            try? mapView.mapboxMap.style.setTerrain(terrain)
        }
        
        var layer = SymbolLayer(id: "layer_id")
        layer.source = "source_id"
        layer.iconImage = .constant(.name("blue"))
        layer.iconAnchor = .constant(.bottom)
        layer.iconAllowOverlap = .constant(true)
        try? mapView.mapboxMap.style.addLayer(layer)
    }
    
    // MARK: - Annotation management
    private func addMarkerAndAnnotation(at coordinate: CLLocationCoordinate2D) {
        let point = Point(coordinate)
        let markerId = addMarker(at: point)
        addViewAnnotation(at: coordinate, withMarkerId: markerId)
    }
    
    // Add a marker to a custom GeoJSON source:
    // This is an optional step to demonstrate the automatic alignment of view annotations
    // with features in a data source
    private func addMarker(at point: Point) -> String {
        let currentId = "\("view_annotation_")\(markerID)"
        markerID += 1
        var feature = Feature(geometry: point)
        feature.identifier = .string(currentId)
        pointList.append(feature)
        if (try? mapView.mapboxMap.style.source(withId: "source_id")) != nil {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: "source_id", geoJSON: .featureCollection(FeatureCollection(features: pointList)))
        }
        return currentId
    }
    
    // Add a view annotation at a specified location and optionally bind it to an ID of a marker
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D, withMarkerId markerId: String? = nil) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 60,
            height: 25,
            associatedFeatureId: markerId,
            allowOverlap: false,
            anchor: .bottom
        )
        
        let pinView = SpotAnnotationView(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        pinView.title = "$3.00"
        pinView.delegate = self
        
        try? mapView.viewAnnotations.add(pinView, options: options)
        
        // Set the vertical offset of the annotation view to be placed above the marker
        try? mapView.viewAnnotations.update(pinView, options: ViewAnnotationOptions(offsetY: markerHeight))
    }

}

final class SpotAnnotationView: UIView {
    weak var delegate: SpotAnnotationViewDelegate?
    
    var selected: Bool = false {
        didSet {
            self.backgroundColor = selected ? UIColor.white : UIColor(named: "uParkerBlue")!
            self.priceLabel.textColor = selected ? UIColor(named: "uParkerBlue")! : UIColor.white
        }
    }
    
    var title: String? {
        get { priceLabel.text }
        set { priceLabel.text = newValue }
    }
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(Color.white)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "uParkerBlue")!
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if selected {
            selected = false
            delegate?.annotationViewDidUnselect(self)
        } else {
            selected = true
            delegate?.annotationViewDidSelect(self)
        }
    }
}

protocol SpotAnnotationViewDelegate: AnyObject {
    func annotationViewDidSelect(_ annotationView: SpotAnnotationView)
    func annotationViewDidUnselect(_ annotationView: SpotAnnotationView)
    func annotationViewDidPressClose(_ annotationView: SpotAnnotationView)
    
}

//protocol AnnotationViewDelegate: AnyObject {
//    func annotationViewDidSelect(_ annotationView: AnnotationView)
//    func annotationViewDidUnselect(_ annotationView: AnnotationView)
//    func annotationViewDidPressClose(_ annotationView: AnnotationView)
//
//}

// `AnnotationView` is a custom `UIView` subclass which is used only for annotation demonstration
//final class AnnotationView: UIView {
//
//    weak var delegate: AnnotationViewDelegate?
//
//    var selected: Bool = false {
//        didSet {
//            selectButton.setTitle(selected ? "Deselect" : "Select", for: .normal)
//        }
//    }
//
//    var title: String? {
//        get { centerLabel.text }
//        set { centerLabel.text = newValue }
//    }
//
//    lazy var centerLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.numberOfLines = 0
//        return label
//    }()
//
//    lazy var closeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitleColor(.black, for: .normal)
//        button.setTitle("X", for: .normal)
//        return button
//    }()
//
//    lazy var selectButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 0.9882352941, alpha: 1)
//        button.layer.cornerRadius = 8
//        button.clipsToBounds = true
//        button.setTitle("Select", for: .normal)
//        return button
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .green
//
//        closeButton.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
//        selectButton.addTarget(self, action: #selector(selectPressed(sender:)), for: .touchUpInside)
//
//        [centerLabel, closeButton, selectButton].forEach { item in
//            item.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(item)
//        }
//
//        NSLayoutConstraint.activate([
//            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
//            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
//
//            centerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
//            centerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
//            centerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
//
//            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
//            selectButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
//            selectButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Action handlers
//    @objc private func closePressed(sender: UIButton) {
//        delegate?.annotationViewDidPressClose(self)
//    }
//
//    @objc private func selectPressed(sender: UIButton) {
//        if selected {
//            selected = false
//            delegate?.annotationViewDidUnselect(self)
//        } else {
//            selected = true
//            delegate?.annotationViewDidSelect(self)
//        }
//    }
//}

//extension MapViewController: AnnotationViewDelegate {
//    func annotationViewDidSelect(_ annotationView: AnnotationView) {
//        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
//
//        let updateOptions = ViewAnnotationOptions(
//            width: (options.width ?? 0.0) + 50,
//            height: (options.height ?? 0.0) + 50,
//            selected: true
//        )
//        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
//    }
//
//    func annotationViewDidUnselect(_ annotationView: AnnotationView) {
//        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
//
//        let updateOptions = ViewAnnotationOptions(
//            width: (options.width ?? 0.0) - 50,
//            height: (options.height ?? 0.0) - 50,
//            selected: false
//        )
//        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
//    }
//
//    // Handle the actions for the button clicks inside the `SampleView` instance
//    func annotationViewDidPressClose(_ annotationView: AnnotationView) {
//        mapView.viewAnnotations.remove(annotationView)
//    }
//}

extension MapViewController: SpotAnnotationViewDelegate {
    func annotationViewDidSelect(_ annotationView: SpotAnnotationView) {
        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
        
        let updateOptions = ViewAnnotationOptions(
            width: (options.width ?? 0.0) + 5,
            height: (options.height ?? 0.0) + 3,
            selected: true
        )
        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
    }
    
    func annotationViewDidUnselect(_ annotationView: SpotAnnotationView) {
        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
        
        let updateOptions = ViewAnnotationOptions(
            width: (options.width ?? 0.0) - 5,
            height: (options.height ?? 0.0) - 3,
            selected: false
        )
        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
    }
    
    func annotationViewDidPressClose(_ annotationView: SpotAnnotationView) {
//        mapView.viewAnnotations.remove(annotationView)
    }
}


// MARK: - VIEW WRAPPER
struct MapViewWrapper: UIViewControllerRepresentable {
    @Binding var center: CLLocation
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext< MapViewWrapper >) -> MapViewController {
        return MapViewController(center: center)
    }
    
    func updateUIViewController(_ mapViewController: MapViewController, context: UIViewControllerRepresentableContext< MapViewWrapper >) {
        mapViewController.centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
    }
}
