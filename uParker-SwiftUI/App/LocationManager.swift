//
//  LocationManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/19/23.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    let locationManager = CLLocationManager()
//
//    @Published var location: CLLocationCoordinate2D?
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600),
//        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//    )
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Did update")
//        guard let location = locations.first else { return }
////        location = locations.first?.coordinate
//        DispatchQueue.main.async {
//            self.location = location.coordinate
//            self.region = MKCoordinateRegion(
//                center: location.coordinate,
//                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//            )
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
    }
    
    func requestLocation() {
        print("Called")
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.location = location
            //5000 is a little over 3 miles
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//            DispatchQueue.main.async {
//                self.location = location.coordinate
//                self.region = MKCoordinateRegion(
//                    center: location.coordinate,
//                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//                )
//            }
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
}
