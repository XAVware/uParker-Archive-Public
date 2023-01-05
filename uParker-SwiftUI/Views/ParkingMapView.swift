//
//  MapView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps

struct ParkingMapViewWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ParkingMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}

public class ParkingMapViewController: UIViewController {
    
    internal var mapView: MapView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoicnlzbWV0IiwiYSI6ImNrZXZ5OHU4bDBoMG8ycmw5YWdjcG11bnkifQ.uREplVHezS8CYP4djva__Q")
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600), zoom: 12, bearing: -17.6, pitch: 0)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Pass options when initializing the map
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
    }
}
