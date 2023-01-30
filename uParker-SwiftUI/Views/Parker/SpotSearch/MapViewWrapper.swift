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
    
    private enum Constants {
        static let BLUE_ICON_ID = "blue"
        static let SOURCE_ID = "source_id"
        static let LAYER_ID = "layer_id"
        static let TERRAIN_SOURCE = "TERRAIN_SOURCE"
        static let TERRAIN_URL_TILE_RESOURCE = "mapbox://mapbox.mapbox-terrain-dem-v1"
        static let MARKER_ID_PREFIX = "view_annotation_"
        static let SELECTED_ADD_COEF_PX: CGFloat = 50
    }
    
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
        let queryOptions = RenderedQueryOptions(layerIds: [Constants.LAYER_ID], filter: nil)
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
        try? style.addImage(image, id: Constants.BLUE_ICON_ID)
        
        var source = GeoJSONSource()
        source.data = .featureCollection(FeatureCollection(features: pointList))
        try? mapView.mapboxMap.style.addSource(source, id: Constants.SOURCE_ID)
        
        if style.uri == .satelliteStreets {
            var demSource = RasterDemSource()
            demSource.url = Constants.TERRAIN_URL_TILE_RESOURCE
            try? mapView.mapboxMap.style.addSource(demSource, id: Constants.TERRAIN_SOURCE)
            let terrain = Terrain(sourceId: Constants.TERRAIN_SOURCE)
            try? mapView.mapboxMap.style.setTerrain(terrain)
        }
        
        var layer = SymbolLayer(id: Constants.LAYER_ID)
        layer.source = Constants.SOURCE_ID
        layer.iconImage = .constant(.name(Constants.BLUE_ICON_ID))
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
        let currentId = "\(Constants.MARKER_ID_PREFIX)\(markerID)"
        markerID += 1
        var feature = Feature(geometry: point)
        feature.identifier = .string(currentId)
        pointList.append(feature)
        if (try? mapView.mapboxMap.style.source(withId: Constants.SOURCE_ID)) != nil {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: Constants.SOURCE_ID, geoJSON: .featureCollection(FeatureCollection(features: pointList)))
        }
        return currentId
    }
    
    // Add a view annotation at a specified location and optionally bind it to an ID of a marker
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D, withMarkerId markerId: String? = nil) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 128,
            height: 64,
            associatedFeatureId: markerId,
            allowOverlap: false,
            anchor: .bottom
        )
        
        let annotationView = AnnotationView(frame: CGRect(x: 0, y: 0, width: 128, height: 64))
        
        annotationView.title = String(format: "lat=%.2f\nlon=%.2f", coordinate.latitude, coordinate.longitude)
        annotationView.delegate = self
        
        try? mapView.viewAnnotations.add(annotationView, options: options)
        
        // Set the vertical offset of the annotation view to be placed above the marker
        try? mapView.viewAnnotations.update(annotationView, options: ViewAnnotationOptions(offsetY: markerHeight))
    }
    
    //    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
    //        let pinWidth: CGFloat = 60
    //        let pinHeight: CGFloat = 25
    //
    //        let options = ViewAnnotationOptions(
    //            geometry: Point(coordinate),
    //            width: pinWidth,
    //            height: pinHeight,
    //            allowOverlap: true,
    //            anchor: .bottom
    //        )
    //
    //        let frame = CGRect(x: 0, y: 0, width: pinWidth, height: pinHeight)
    //
    //        let pinView: UILabel = UILabel(frame: frame)
    //        pinView.textColor = .white
    //        pinView.text = "$3.00"
    //        pinView.font = .systemFont(ofSize: 12, weight: .semibold)
    //        pinView.textAlignment = .center
    //        pinView.adjustsFontSizeToFitWidth = true
    //        pinView.backgroundColor = UIColor(named: "uParkerBlue")!
    //        pinView.layer.masksToBounds = true
    //        pinView.layer.cornerRadius = pinHeight / 2
    //        pinView.layer.shadowRadius = 2
    //        pinView.layer.shadowOffset = CGSize(width: 0, height: 1)
    //        pinView.layer.shadowOpacity = 0.5
    //
    //        try? mapView.viewAnnotations.add(pinView, options: options)
    //    }
}

protocol AnnotationViewDelegate: AnyObject {
    func annotationViewDidSelect(_ annotationView: AnnotationView)
    func annotationViewDidUnselect(_ annotationView: AnnotationView)
    func annotationViewDidPressClose(_ annotationView: AnnotationView)
}

// `AnnotationView` is a custom `UIView` subclass which is used only for annotation demonstration
final class AnnotationView: UIView {
    
    weak var delegate: AnnotationViewDelegate?
    
    var selected: Bool = false {
        didSet {
            selectButton.setTitle(selected ? "Deselect" : "Select", for: .normal)
        }
    }
    
    var title: String? {
        get { centerLabel.text }
        set { centerLabel.text = newValue }
    }
    
    lazy var centerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("X", for: .normal)
        return button
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 0.9882352941, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Select", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        
        closeButton.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectPressed(sender:)), for: .touchUpInside)
        
        [centerLabel, closeButton, selectButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            
            centerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            centerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            centerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            
            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            selectButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            selectButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action handlers
    @objc private func closePressed(sender: UIButton) {
        delegate?.annotationViewDidPressClose(self)
    }
    
    @objc private func selectPressed(sender: UIButton) {
        if selected {
            selected = false
            delegate?.annotationViewDidUnselect(self)
        } else {
            selected = true
            delegate?.annotationViewDidSelect(self)
        }
    }
}

extension MapViewController: AnnotationViewDelegate {
    func annotationViewDidSelect(_ annotationView: AnnotationView) {
        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
        
        let updateOptions = ViewAnnotationOptions(
            width: (options.width ?? 0.0) + Constants.SELECTED_ADD_COEF_PX,
            height: (options.height ?? 0.0) + Constants.SELECTED_ADD_COEF_PX,
            selected: true
        )
        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
    }
    
    func annotationViewDidUnselect(_ annotationView: AnnotationView) {
        guard let options = self.mapView.viewAnnotations.options(for: annotationView) else { return }
        
        let updateOptions = ViewAnnotationOptions(
            width: (options.width ?? 0.0) - Constants.SELECTED_ADD_COEF_PX,
            height: (options.height ?? 0.0) - Constants.SELECTED_ADD_COEF_PX,
            selected: false
        )
        try? self.mapView.viewAnnotations.update(annotationView, options: updateOptions)
    }
    
    // Handle the actions for the button clicks inside the `SampleView` instance
    func annotationViewDidPressClose(_ annotationView: AnnotationView) {
        mapView.viewAnnotations.remove(annotationView)
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
