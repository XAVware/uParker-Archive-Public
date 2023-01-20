//
//  MapViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

public class MapViewController: UIViewController {
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    
    var geocoder: MBGeocoder = MBGeocoder()
    
    let pennStateCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    
    // MARK: - INITIALIZER
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
        addPins()
    }
    
    private func addPins() {
        geocoder.setFocalArea(pennStateCoordinates)
        geocoder.getCoordinates(forAddress: "100 East Beaver Ave, State College, PA") { result in
            guard result != nil else {
                print("Result is empty")
                return
            }
            
            self.addViewAnnotation(at: result!)
        }
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        let cameraOptions = CameraOptions(center: pennStateCoordinates, zoom: 12, bearing: -17.6, pitch: 0)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Pass options when initializing the map
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let pinWidth: CGFloat = 60
        let pinHeight: CGFloat = 25
        
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: pinWidth,
            height: pinHeight,
            allowOverlap: false
            //            allowOverlap: false,
            //            anchor: .center
        )
        
        let frame = CGRect(x: 0, y: 0, width: pinWidth, height: pinHeight)
        
        let pinView: UILabel = UILabel(frame: frame)
        pinView.textColor = .white
        pinView.text = "$3.00"
        pinView.font = .systemFont(ofSize: 12, weight: .semibold)
        pinView.textAlignment = .center
        pinView.adjustsFontSizeToFitWidth = true
        pinView.backgroundColor = UIColor(named: "uParkerBlue")!
        pinView.layer.masksToBounds = true
        pinView.layer.cornerRadius = pinHeight / 2
        pinView.layer.shadowRadius = 2
        pinView.layer.shadowOffset = CGSize(width: 0, height: 1)
        pinView.layer.shadowOpacity = 0.5
        
        try? mapView.viewAnnotations.add(pinView, options: options)
    }
}

// MARK: - VIEW WRAPPER
//Use UIViewControllerRepresentable to display MapBox map in SwiftUI app.
struct MapViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}

