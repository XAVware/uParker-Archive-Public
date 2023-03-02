//
//  Vehicle.swift
//  uParker
//
//  Created by Ryan Smetana on 8/5/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import SwiftUI

class Vehicle: Codable {
    let color: VehicleColor
    let driveType: String
    let engine: String
    let fuel: String
    let make: String
    let model: String
    let name: String
    let style: String
    let transmission: String
    let trim: String
    let vin: String
    let year: String
    var plate: String?
    var state: String?
}

struct VehicleColor: Codable {
    let abbreviation: String
    let name: String
}

struct PTVResponse: Codable {
    let success: Bool
    let vin: Vehicle
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


/*
 Actual Response:
 {
     success = 1;
     vin =     {
         color =         {
             abbreviation = UNK;
             name = Unknown;
         };
         driveType = AWD;
         engine = "2.5L H4 DOHC 16V TURBO";
         fuel = Gasoline;
         make = Subaru;
         model = Impreza;
         name = "2007 Subaru Impreza";
         style = Sedan;
         transmission = Manual;
         trim = WRX;
         vin = JF1GD74657G507090;
         year = 2007;
     };
 }

 */
