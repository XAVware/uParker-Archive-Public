//
//  TableHeaderView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/18/20.
//

import UIKit

class TableHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureWith(sectionTitle: String) {
        self.backgroundColor = UIColor(named: "uParker Blue")
        self.alpha = 1
        
        let bottomLine = CALayer()
        let bottomLineInset: CGFloat = 15.0
        let bottomLineWidth = self.frame.width - (bottomLineInset * 2)
        
        bottomLine.frame = CGRect(x: bottomLineInset, y: self.frame.height - 1, width: bottomLineWidth, height: 1)
        bottomLine.backgroundColor = UIColor(white: 1, alpha: 0.3).cgColor
        
        self.layer.addSublayer(bottomLine)
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.width - 15, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.text = sectionTitle
        
        
        self.addSubview(label)
    }
}
