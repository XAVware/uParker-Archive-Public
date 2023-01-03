//
//  VehicleList.swift
//  uParker
//
//  Created by Ryan Smetana on 7/31/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import UIKit


class VehicleFramework {
    var make: String
    var model: [String]
    
    init(make:String, model:[String]) {
        self.make = make
        self.model = model
    }
}

class VehicleList {
    
    var vehicleList = [VehicleFramework]()
    
    init() {
        vehicleList.append(VehicleFramework(make: "Audi", model: ["A3","A4","A5"]))
        vehicleList.append(VehicleFramework(make: "BMW", model: ["3-Series","4-Series","5-Series"]))
        vehicleList.append(VehicleFramework(make: "Chevrolet", model: ["Corvette"]))
        
    }
    
    
}
