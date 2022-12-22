//
//  User.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/21/22.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String 
}
