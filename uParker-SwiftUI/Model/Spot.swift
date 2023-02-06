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
    var id: UUID = UUID()
    var streetAddress: String!
    var spotTitle: String!
    var price: Double!
    var rating: Double!
//    var coordinates: CLLocationCoordinate2D!
    
        
    init(streetAdress: String, title: String, price: Double, rating: Double) {
        self.streetAddress = streetAdress
        self.spotTitle = title
        self.price = price
        self.rating = rating
        
    }
    
//    private func getCoordinates(for address: String) -> CLLocationCoordinate2D {
//        //        geocoder.setFocalArea(pennStateCoordinates)
//        var geocoder: MBGeocoder = MBGeocoder()
//
//        geocoder.getCoordinates(forAddress: address) { result in
//            guard result != nil else {
//                print("Result is empty")
//                return
//            }
//
//            return result
//        }
//    }
}

