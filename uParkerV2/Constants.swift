//
//  Constants.swift
//  uParker
//
//  Created by Ryan Smetana on 9/13/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//
import UIKit

struct K {
    
    struct Segues {
        static let toLogin = "goToLogin"
        
        //Login screen segues
        static let toCreateAccount      = "goToCreateAccount"
        static let toForgotPassword     = "goToForgotPassword"
        static let toHomescreen         = "goToHomescreen"
        
        //Homescreen segues
        static let toFindParking        = "goToFindParking"
        static let toReservations       = "goToReservations"
        static let toHostDashboard      = "goToHostDashboard"
        static let toMenu               = "goToMenu"
        
        //Menu Segues
        static let toVehicles           = "goToVehicles"
        static let toPaymentMethods     = "goToPaymentMethods"
        static let toPreferences        = "goToPreferences"
        
        //Reservation screen segues
        static let toDirections         = "goToDirections"
        
        //Vehicle screen segues
        static let toAddVehicle         = "goToAddVehicle"
        
        //Payment screen segues
        static let toAddPayment         = "goToAddPayment"
        
        //Find parking screen segues
        static let toFilters            = "goToFilters"
        
        static let toSpot               = "goToSpot"
        
    }
    
    struct BrandColors {
        static let uParkerBlue = UIColor(red: 25 / 255,
                                    green: 54 / 255,
                                    blue: 88 / 255,
                                    alpha: 1.0)
        
        static let uParkerLightBlue = UIColor(red: 25 / 255,
                                         green: 54 / 255,
                                         blue: 88 / 255,
                                         alpha: 1.0)
    }
    
    struct FStore {
        
    }
}
