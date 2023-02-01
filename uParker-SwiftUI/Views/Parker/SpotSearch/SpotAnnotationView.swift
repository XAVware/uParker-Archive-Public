//
//  SpotAnnotationView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/1/23.
//

import SwiftUI

class SpotAnnotationView: UIView {
    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 26)
    let selected: Bool
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: annotationFrame)
        label.textColor = self.selected ? UIColor(named: "uParkerBlue")! : UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func getFormattedPrice(price: Double) -> NSMutableAttributedString {
        //Returns a String that has a small & offset dollar sign, a small space to act as padding between the dollar sign and the price, and the price in bold which automatically adjusts its font size based on the length of the price. With a frame that is 60 wide and 26 tall, the price label touches the edges if the price has 3 digits before the decimal.
        let dollarSignFont: UIFont = UIFont.systemFont(ofSize: 10)
        let spaceFont: UIFont = UIFont.systemFont(ofSize: 6)
        let priceFont: UIFont = UIFont.boldSystemFont(ofSize: price < 100.0 ? 14 : 12)
        
        let labelText = "$ \(String(format: "%.2f", price))"
        
        let attString = NSMutableAttributedString(string: labelText)
        attString.addAttribute(.font, value: dollarSignFont, range: NSRange(location: 0, length: 1))
        attString.addAttribute(.font, value: spaceFont, range: NSRange(location: 1, length: 1))
        attString.addAttribute(.font, value: priceFont, range: NSRange(location: 2, length: labelText.count - 2))
        attString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: 1))
        
        return attString
    }
    
    func initializeBackground() {
        self.backgroundColor = selected ? UIColor.white : UIColor(named: "uParkerBlue")!
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = annotationFrame.height / 2
        self.layer.borderColor = UIColor(named: "uParkerBlue")!.cgColor
        self.layer.borderWidth = 1
    }
    
    init(isSelected: Bool, price: Double) {
        selected = isSelected
        super.init(frame: annotationFrame)
        
        initializeBackground()
        
        priceLabel.attributedText = getFormattedPrice(price: price)
        
        self.addSubview(priceLabel)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
