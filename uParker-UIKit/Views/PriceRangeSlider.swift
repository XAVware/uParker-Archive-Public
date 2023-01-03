//
//  PriceRangeSlider.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/14/20.
//

import UIKit
import RangeSeekSlider

class PriceRangeSlider: RangeSeekSlider {
    let priceOptions: [Int] = [0, 5, 10, 20, 30, 40, 80, 120, 160]
    var priceLabel: UILabel?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        initializePriceSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializePriceSlider()
    }
    
    func setLabel(label: UILabel) {
        self.priceLabel = label
    }
    
    func initializePriceSlider() {
        self.delegate = self
        self.enableStep = true
        self.step = 1
        self.minValue = CGFloat(priceOptions[0])
        self.maxValue = CGFloat(priceOptions.count - 1)
        self.minDistance = 1
        self.handleDiameter = 20
        self.lineHeight = 3
    }
    
    func getPriceString(forValue value: CGFloat) -> String {
        let valueInt: Int = Int(value)
        var formattedString = "$"
        
        if valueInt >= priceOptions.count {
            let maxPriceOption = priceOptions[priceOptions.count - 1]
            formattedString.append("\(maxPriceOption)+")
        } else {
            let correspondingPrice = String(priceOptions[valueInt])
            formattedString.append(correspondingPrice)
        }
        
        return formattedString
    }
    
    func getPriceLabelString(selectedMinValue: CGFloat, selectedMaxValue: CGFloat) -> String {
        let minVal = getPriceString(forValue: selectedMinValue)
        let maxVal = getPriceString(forValue: selectedMaxValue)
        
        if selectedMinValue == self.minValue && selectedMaxValue == self.maxValue {
            return "Any Price"
        } else if selectedMinValue != self.minValue && selectedMaxValue != self.maxValue {
            return "Between \(minVal) and \(maxVal)"
        } else if selectedMinValue != self.minValue && selectedMaxValue == self.maxValue {
            return "Over \(minVal)"
        } else {
            return "Under \(maxVal)"
        }
    }
    
}

extension PriceRangeSlider: RangeSeekSliderDelegate {
    
    func didStartTouches(in slider: RangeSeekSlider) {
        //
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        //
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        guard priceLabel != nil else {
            print("Price Label is nil")
            return
        }
        priceLabel!.text = getPriceLabelString(selectedMinValue: minValue, selectedMaxValue: maxValue)
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        return getPriceString(forValue: minValue)
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        return getPriceString(forValue: maxValue)
    }
    
}
