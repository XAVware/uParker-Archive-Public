//
//  User.swift
//  uParker
//
//  Created by Ryan Smetana on 8/5/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import Foundation

class User: ObservableObject {
    
    @Published private var firstName: String!
    private var email: String!
    private var phoneNumber: String?
    private var isHost: Bool = false
    
    
    @Published var ownedVehicles: [Vehicle] = []
    @Published var primaryVehicle: Vehicle?
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var upcomingReservations: [Reservation] = []
    
    @Published var errorHandlingEnabled: Bool = false
    
    
    
    init() {
        self.firstName = "Ryan"
        self.email = "ryan.smetana@xavware.com"
    }
    
    func toggleErrorHandling(enabled: Bool) {
        if enabled {
            errorHandlingEnabled = true
        } else {
            errorHandlingEnabled = false
        }
    }
    
    
    
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getOwnedVehicles() -> [Vehicle] {
        return ownedVehicles
    }
    
    func addVehicle(newVehicle: Vehicle) {
        if primaryVehicle == nil {
            primaryVehicle = newVehicle
        } else {
            ownedVehicles.insert(newVehicle, at: 0)
        }
        
        //newVehicle.save()
    }
    
    func deleteVehicle(_ selectedVehicle: Vehicle) {
        if selectedVehicle.licensePlate == primaryVehicle!.licensePlate {
            makePrimaryVehicle(ownedVehicles[0])
            ownedVehicles.remove(at: 0)
        } else {
            var vehicleIndex = 0
            for vehicle in ownedVehicles {
                if vehicle.licensePlate == selectedVehicle.licensePlate {
                    ownedVehicles.remove(at: vehicleIndex)
                    return
                } else {
                    vehicleIndex += 1
                }
            }
        }
    }
    
    func makePrimaryVehicle(_ selectedVehicle: Vehicle) {
        deleteVehicle(selectedVehicle)
        ownedVehicles.insert(primaryVehicle!, at: 0)
        primaryVehicle = selectedVehicle
    }
    
    func getPaymentMethods() -> [PaymentMethod] {
        return paymentMethods
    }
    
    func addPaymentMethod(newPaymentMethod: PaymentMethod) {
        paymentMethods.append(newPaymentMethod)
    }
    
}

