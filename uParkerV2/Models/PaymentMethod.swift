//
//  PaymentMethod.swift
//  uParker
//
//  Created by Ryan Smetana on 8/7/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import Foundation

class PaymentMethod {
    
    let nameOnCard:         String!
    let cardNumber:         String!
    let expirationDate:     String!
    let cvc:                String!
    
    init(nameOnCard: String, cardNumber: String, expirationDate: String, cvc: String) {
        self.nameOnCard = nameOnCard
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.cvc = cvc
    }
    
    func saveCard() {
        //Save card to database
    }
    
    func deleteCard() {
        //Delete card from database
    }
}
