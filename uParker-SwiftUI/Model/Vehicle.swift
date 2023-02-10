//
//  Vehicle.swift
//  uParker
//
//  Created by Ryan Smetana on 8/5/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import SwiftUI

class Vehicle: Codable {
    let vin: String
    let year: String
    let make: String
    let model: String
    let trim: String
    let name: String
    let engine: String
    let style: String
    let transmission: String
    let driveType: String
    let fuel: String
    let color: [VehicleColor]
}

struct VehicleColor: Codable {
    let name: String
    let abbreviation: String
}

/*
 Example output from PlateToVin API
 {
     "vin": "3GCPWBEK9LG168514",
     "year": "2020",
     "make": "Chevrolet",
     "model": "Silverado 1500",
     "trim": "Custom",
     "name": "2020 Chevrolet Silverado 1500",
     "engine": "2.7L L4 DOHC 16V TURBO",
     "style": "Pickup",
     "transmission": "Automatic",
     "driveType": "RWD",
     "fuel": "Gasoline",
     "color": {
         "name": "Black",
         "abbreviation": "BLK"
     }
 }
 
 */
