//
//  Spot.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/7/23.
//


import SwiftUI
import CoreLocation

//import MapboxGeocoder

class Spot {
    var streetAddress: String!
    var spotTitle: String!
    var price: String!
    var rating: String!
    
    var coordinate: CLLocationCoordinate2D?
    
    init(streetAdress: String, title: String, price: String, rating: String) {
        self.streetAddress = streetAdress
        self.spotTitle = title
        self.price = price
        self.rating = rating
    }
    
    
// ~~~~~~~~~~~~~~~~~~~~ Not working ~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    func getCoordinates(for address: String) -> CLLocationCoordinate2D {
//        var safeCoordinate: CLLocationCoordinate2D!
//        let geocoder = Geocoder.shared
//        let options = ForwardGeocodeOptions(query: address)
//        let task = geocoder.geocode(options) { (placemarks, attribution, error) in
//
//            guard let placemark = placemarks?.first else {
//                print("error getting spot coordinate")
//                return
//            }
//            safeCoordinate = placemark.location?.coordinate
//
//        }
//        task.resume()
//
//        guard safeCoordinate != nil else {
//            return CLLocationCoordinate2D(latitude: 30, longitude: 60)
//        }
//
//        return safeCoordinate
//    }
}

