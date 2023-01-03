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
        static let toHomescreen         = "goToHomepage"
        
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
        
        static let openSearchView       = "displaySearchView"
        
    }
    
    struct BrandColors {
        
        static let uParkerBlue          = UIColor(named: "uParkerBlue")!
        
        static let uParkerLightBlue = UIColor(red: 25 / 255,
                                         green: 54 / 255,
                                         blue: 88 / 255,
                                         alpha: 1.0)
    }
    
    struct TableCells {
        static let menuProfileIdentifier            = "MenuProfileTableViewCell"
        static let menuButtonIdentifier             = "MenuButtonTableViewCell"
        static let paymentMethodCellIdentifier      = "paymentMethodCell"
    }
    
    struct CollectionCells {
        static let suggestionIdentifier             = "SuggestedDestinationCollectionViewCell"
        static let spotCardIdentifier               = "SpotCollectionViewCell"
        static let spotImageIdentifier              = "SpotImageCollectionCell"
        static let spotListIdentifier               = "SpotListCollectionViewCell"
        static let reviewCardIdentifier             = "ReviewCardCollectionViewCell"
        static let reviewListIdentifier             = "ReviewListCollectionViewCell"
    }
    
    struct ViewControllers {
        static let reviewListVC                     = "ReviewListVC"
        static let confirmationVC                   = "ConfirmationVC"
    }
    
    struct Accessibility {
        static let starOne                          = "1"
        static let starTwo                          = "2"
        static let starThree                        = "3"
        static let starFour                         = "4"
        static let starFive                         = "5"
    }
}
