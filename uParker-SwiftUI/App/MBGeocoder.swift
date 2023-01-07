//
//  MBGeocoder.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/7/23.
//


// https://github.com/mapbox/MapboxGeocoder.swift

import CoreLocation
import MapboxGeocoder
import SwiftUI

struct MBGeocoder {
    // MARK: - PROPERTIES
    //Uses public key in Info.plist file
    private let geocoder: Geocoder = Geocoder.shared
    private var focalArea: CLLocation
    
    init(generalArea: CLLocation) {
        print("-----------------GEOCODER INITIALIZED-----------------")
        self.focalArea = generalArea
    }
    
    func getCoordinates(forAddress address: String) {
        let options = ForwardGeocodeOptions(query: address)
        options.focalLocation = self.focalArea
        options.allowedScopes = [.address, .pointOfInterest]
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
        print("Original Coordinate: \(coordinate)")
        
        let task = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            print("Result Coordinate: \(placemark.location!.coordinate)")
            coordinate = placemark.location!.coordinate
            print("New Coordinate: \(coordinate)")
        }
        print("Confirm New Coordinate: \(coordinate)")
        
    }
    
//    func getCoordinates(forAddress address: String) -> CLLocationCoordinate2D {
//        let options = ForwardGeocodeOptions(query: address)
//        options.focalLocation = self.focalArea
//        
//        var resultCoordinates: CLLocationCoordinate2D?
//        
//        let task = geocoder.geocode(options) { (placemarks, attribution, error) in
//            guard let placemark = placemarks?.first else {
//                return
//            }
//
//            guard let location = placemark.location else {
//                print("Unable to get location for address: \(address)")
//                return
//            }
//            
//            resultCoordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            
//            print("Location Coordinates: \(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))")
//            print("Result Coordinates Value: \(resultCoordinates!)")
//        }
//        
//        guard resultCoordinates != nil else {
//            print("Result coordinate is nil, returning default")
//            return CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
//        }
//        
//        return resultCoordinates!
        
//        guard resultLocation != nil else {
//            print("Location Result is Empty, returning default coordinates")
//            return CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
//        }
//
//        let resultCoordinates = CLLocationCoordinate2D(latitude: resultLocation!.coordinate.latitude, longitude: resultLocation!.coordinate.longitude)
//        return resultCoordinates
//    }
    
    
    
    
    func printSample() {
        let options = ForwardGeocodeOptions(query: "200 queen street")

        // To refine the search, you can set various properties on the options object.
        options.allowedISOCountryCodes = ["CA"]
        options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
        options.allowedScopes = [.address, .pointOfInterest]

        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }

            print("\(placemark.name)")
                // 200 Queen St
            print("\(String(describing: placemark.qualifiedName))")
                // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada

            let coordinate = placemark.location!.coordinate
            print("\(coordinate.latitude), \(coordinate.longitude)")
                // 45.270093, -66.050985
        }
    }
}
