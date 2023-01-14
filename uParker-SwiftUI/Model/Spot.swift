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
        
    init(streetAdress: String, title: String, price: String, rating: String) {
        self.streetAddress = streetAdress
        self.spotTitle = title
        self.price = price
        self.rating = rating
        
        
    }
    
}

