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

class MBGeocoder {
    // MARK: - PROPERTIES
    //Uses public key in Info.plist file
    private let geocoder: Geocoder = Geocoder.shared
    private var focalArea: CLLocation?
    
    func getCoordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let options = ForwardGeocodeOptions(query: address)
        if focalArea != nil {
            options.focalLocation = focalArea
        }

        geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            let coordinates = placemark.location!.coordinate
            completion(coordinates)
        }
    }
    
    func setFocalArea(_ focalArea: CLLocationCoordinate2D) {
        let convertedFocalArea = CLLocation(latitude: focalArea.latitude, longitude: focalArea.longitude)
        self.focalArea = convertedFocalArea
    }

}
