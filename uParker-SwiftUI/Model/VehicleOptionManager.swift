//
//  VehicleOptionManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/13/23.
//

import SwiftUI

struct VehicleOption {
    let id: UUID = UUID()
    let year: String
    let make: String
    let model: String
    let trim: [String]
}

