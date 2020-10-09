//
//  UPTextField.swift
//  uParker
//
//  Created by Ryan Smetana on 7/16/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
        
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init( coder: aDecoder)
        setUpField()
    }
    
    private func setUpField() {
        var lineColor: UIColor {
            self.textColor!
        }

        tintColor               = lineColor
        textColor               = lineColor
        font                    = UIFont(name: "Helvetica", size: 18.0)
        backgroundColor         = nil
        autocorrectionType      = .no
        clipsToBounds           = true
        borderStyle             = UITextField.BorderStyle.none
        
        let placeholder         = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont     = UIFont(name: "Helvetica", size:  18.0)
        attributedPlaceholder   = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: lineColor,
             NSAttributedString.Key.font: placeholderFont!])
        
        let indentView          = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        leftView                = indentView
        leftViewMode            = .always
        
        let length: CGFloat = UIScreen.main.bounds.size.width - 32
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: length, height: 2.0)
        bottomLine.backgroundColor = lineColor.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    
}
