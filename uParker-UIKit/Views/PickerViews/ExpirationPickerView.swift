//
//  ExpirationPickerView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/19/20.
//

import UIKit

class ExpirationPickerView: UIPickerView , UIPickerViewDelegate, UIPickerViewDataSource {
    
    var month: String?
    var year: String?
    
    var monthList = ["Select the month", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var yearList = ["Select the year", "2020", "2021", "2022", "2023", "2023", "2024"]
    
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
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthList.count
        } else {
            return yearList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return monthList[row]
        } else {
            return yearList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMonth = self.selectedRow(inComponent: 0)
        let selectedYear = self.selectedRow(inComponent: 1)
        month = monthList[selectedMonth]
        year = yearList[selectedYear]
    }
    
    
    
}
