//
//  ColorPickerView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/15/20.
//

import UIKit

class ColorPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var color: String?
    var colorList = ["Blue", "Red", "Yellow"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init( coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedColor = self.selectedRow(inComponent: 0)
        color = colorList[selectedColor]
        self.reloadComponent(0)
    }
    
}


