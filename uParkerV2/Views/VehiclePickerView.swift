//
//  VehiclePickerView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/15/20.
//

import UIKit

class VehiclePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var make: String?
    var model: String?
    var vehicleList = VehicleList().vehicleList
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpPickerView()
        
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init( coder: aDecoder)
        setUpPickerView()
    }
    
    func setUpPickerView() {
        self.delegate = self
        self.dataSource = self
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return vehicleList.count
        } else {
            let selectedMake = self.selectedRow(inComponent: 0)
            return vehicleList[selectedMake].model.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return vehicleList[row].make
        } else {
            let selectedMake = self.selectedRow(inComponent: 0)
            return vehicleList[selectedMake].model[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
        let selectedMake = self.selectedRow(inComponent: 0)
        let selectedModel = self.selectedRow(inComponent: 1)
        make = vehicleList[selectedMake].make
        model = vehicleList[selectedMake].model[selectedModel]
        self.reloadComponent(1)
    }
    
    
    
}

