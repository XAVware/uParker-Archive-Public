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
    
    let pennStateCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    
    
    // MARK: - INITIALIZER
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoicnlzbWV0IiwiYSI6ImNrZXZ5OHU4bDBoMG8ycmw5YWdjcG11bnkifQ.uREplVHezS8CYP4djva__Q")
        let cameraOptions = CameraOptions(center: pennStateCoordinates, zoom: 12, bearing: -17.6, pitch: 0)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Pass options when initializing the map
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        
        //Add Annotation to map
        self.addViewAnnotation(at: pennStateCoordinates)
    }
    
    
    private func createSampleView(withText text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 100,
            height: 40,
            allowOverlap: false,
            anchor: .center
        )
        let sampleView = createSampleView(withText: "Hello world!")
        try? mapView.viewAnnotations.add(sampleView, options: options)
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
