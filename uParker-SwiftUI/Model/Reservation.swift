//
//  Reservation.swift
//  uParker
//
//  Created by Ryan Smetana on 8/30/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import Foundation


struct Reservation {
    
    var reservationID: Int?
    var ownerID: Int?
    var parkerID: Int?
    
    let streetAddress: String!
    let city: String!
    let state: String!
    let zipCode: String!
    
    var startDate: String?
    var endDate: String?
    
    var startTime: String?
    var endTime: String?
    
    init(streetAddress: String, city: String, state: String, zipCode: String) {
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
    
    
}
