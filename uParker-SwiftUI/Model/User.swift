//
//  User.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/21/22.
//

import SwiftUI

//struct User: Identifiable, Codable {
//    let id: Int
//    let firstName: String
//    let lastName: String
//    let email: String
//    let phoneNumber: String
//}


struct User {
    enum UserType { case parker, host}
    
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var stripeId: String
    var userType: UserType = .parker
    
    static func initFrom( _ data: [String: Any]) -> User {
        let id = data["id"] as? String ?? ""
        let firstName = data["firstName"] as? String ?? ""
        let lastName = data["lastName"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String ?? ""
        let stripeId = data["stripeId"] as? String ?? ""
        
        return User(id: id, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, stripeId: stripeId)
    }
}
