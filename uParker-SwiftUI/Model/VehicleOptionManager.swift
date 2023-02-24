//
//  VehicleOptionManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/13/23.
//

import SwiftUI

struct VehicleOption: Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case year
        case category
        case model
        case make
    }
    
    var id: UUID = UUID()
    let year: Int
    let category: String
    let model: String
    let make: String
}

