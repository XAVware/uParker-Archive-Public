//
//  RoundButton.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/9/20.
//

import UIKit

class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init( coder: aDecoder)
        setUpField()
    }
    
    private func setUpField() {
        layer.cornerRadius = self.bounds.height / 2
        if self.backgroundColor == nil {
            layer.borderWidth = 5
            layer.borderColor = self.titleColor(for: .normal)!.cgColor
        }
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 9)
        layer.shadowOpacity = 0.3
    }
}
