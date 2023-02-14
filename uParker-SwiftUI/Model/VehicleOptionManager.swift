//
//  VehicleOptionManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/13/23.
//

import SwiftUI

let vehicleList: [VehicleOption] = Bundle.main.decode("VehicleOptions.json")

struct VehicleOption: Codable, Identifiable {
    var id: UUID = UUID()
    let year: String
    let make: String
    let model: String
    let trim: [String]
}

