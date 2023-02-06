//
//  MapViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

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
    let markers: [PinModel] = [PinModel(id: "Spot_ID", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)), price: 3.00),
                                      PinModel(id: "Spot_ID2", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7820, longitude: -77.8505)), price: 40.00)]
    
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
        print("Selected pin: \(pin.data)")
    }
}

public protocol PinViewInteractionDelegate: AnyObject {
    func didSelectPin(_ pin: PinView)
}
