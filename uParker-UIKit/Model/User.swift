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
    
    
    
    @Published var primaryVehicle: Vehicle?
    @Published var ownedVehicles: [Vehicle] = []
    
    
    @Published var defaultPaymentMethod: PaymentMethod?
    @Published var paymentMethods: [PaymentMethod] = []
    
    
    @Published var upcomingReservations: [Reservation] = []
    
    @Published var errorHandlingEnabled: Bool = false
    
    
    
    init() {
        self.firstName = "Ryan"
        self.email = "ryan.smetana@xavware.com"
//        self.primaryVehicle = Vehicle(vehicle: "Black Subaru WRX", licensePlate: "S71 JCY")
//        ownedVehicles = [Vehicle(vehicle: "Silver BMW 545i", licensePlate: "3KP YTA"), Vehicle(vehicle: "White Mazda 3i", licensePlate: "ERT 9J0")]
//        self.defaultPaymentMethod = PaymentMethod(nameOnCard: "Ryan", cardNumber: "1234", expirationDate: "10/18", cvc: "555")
//        self.paymentMethods = [PaymentMethod(nameOnCard: "Megan", cardNumber: "5678", expirationDate: "08/24", cvc: "777")]
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
        if ownedVehicles.count == 0 {
            primaryVehicle = nil
            return
        }
        
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
        if defaultPaymentMethod == nil {
            defaultPaymentMethod = newPaymentMethod
        } else {
            paymentMethods.insert(newPaymentMethod, at: 0)
        }
    }
    
    
    func deletePaymentMethod(_ selectedPaymentMethod: PaymentMethod) {
        if paymentMethods.count == 0 {
            defaultPaymentMethod = nil
            return
        }
        
        if selectedPaymentMethod.cardNumber == defaultPaymentMethod!.cardNumber {
            makeDefaultPaymentMethod(paymentMethods[0])
            paymentMethods.remove(at: 0)
        } else {
            var paymentMethodIndex = 0
            for paymentMethod in paymentMethods {
                if paymentMethod.cardNumber == selectedPaymentMethod.cardNumber {
                    paymentMethods.remove(at: paymentMethodIndex)
                    return
                } else {
                    paymentMethodIndex += 1
                }
            }
        }
    }
    
    func makeDefaultPaymentMethod(_ selectedPaymentMethod: PaymentMethod) {
        deletePaymentMethod(selectedPaymentMethod)
        paymentMethods.insert(defaultPaymentMethod!, at: 0)
        defaultPaymentMethod = selectedPaymentMethod
    }
    
}

