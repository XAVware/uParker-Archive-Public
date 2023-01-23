//
//  Suggestion.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/22/23.
//

import Foundation
import MapboxSearch
import CoreLocation

struct SimpleSuggestion: Equatable {
    let name: String
    let address: Address?
    let coordinate: CLLocationCoordinate2D
    let categories: [String]?
}
