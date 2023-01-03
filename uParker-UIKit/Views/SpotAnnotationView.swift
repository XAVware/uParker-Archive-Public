//
//  SpotAnnotationView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/16/20.
//

import UIKit
import MapboxMaps
/*
class SpotAnnotationView: MGLAnnotationView {
    let backgroundFrame                         = CGRect(x: 0, y: 0, width: 60, height: 25)
    
    let backgroundView: UIView                  = UIView()
    let priceLabel: UILabel                     = UILabel()
    let selectedView: UIView                    = UIView()
    
    let unselectedBackgroundColor: UIColor      = K.BrandColors.uParkerBlue
    let unselectedTextColor: UIColor            = .white
    let unselectedPriceFont: UIFont             = UIFont(name: "Helvetica", size: 14.0)!
    
    let selectedBackgroundColor: UIColor        = .white
    let selectedTextColor: UIColor              = K.BrandColors.uParkerBlue
    let selectedPriceFont: UIFont               = UIFont(name: "Helvetica", size: 15.0)!
    
    var price: String?
    
    override init(annotation: MGLAnnotation!, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        price = getPriceString(from: annotation.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.frame                             = backgroundFrame
        backgroundColor                         = UIColor.clear
        
        backgroundView.frame                    = backgroundFrame
        backgroundView.backgroundColor          = unselectedBackgroundColor
        backgroundView.layer.cornerRadius       = backgroundFrame.height / 2
        
        layer.shadowRadius                      = 2
        layer.shadowOffset                      = CGSize(width: 0, height: 1)
        layer.shadowOpacity                     = 0.3
        
        //Should add constraints to put space before and after the label -- Adding constraints seems to move the annotation to the top left corner of the mapview
        priceLabel.frame                        = backgroundFrame
        priceLabel.text                         = "$ \(price!)"
        priceLabel.textAlignment                = .center
        priceLabel.adjustsFontSizeToFitWidth    = true
        
        backgroundView.addSubview(priceLabel)
        addSubview(backgroundView)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundView.backgroundColor      = selectedBackgroundColor
            priceLabel.textColor                = selectedTextColor
            priceLabel.font                     = selectedPriceFont
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        } else {
            backgroundView.backgroundColor      = unselectedBackgroundColor
            priceLabel.textColor                = unselectedTextColor
            priceLabel.font                     = unselectedPriceFont
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
    func getPriceString(from annotationTitle: String??) -> String {
        if let titleString = annotationTitle, let priceString = titleString {
            return priceString
        } else {
            return "Default"
        }
    }
}

*/
