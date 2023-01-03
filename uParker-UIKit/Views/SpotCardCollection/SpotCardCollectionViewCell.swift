//
//  SpotCardCollectionViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/29/20.
//

import UIKit

class SpotCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var spotBackgroundView: UIView!
    
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var availableNowStack: UIStackView!
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(withSpot spot: Spot) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
        
        
        spotBackgroundView.layer.cornerRadius = 10
        spotBackgroundView.clipsToBounds = true
        thumbnail.image = UIImage(named: "Example Driveway Pic")
        priceLabel.text = "\(spot.price!) / Day"
        ratingLabel.text = spot.rating
        titleLabel.text = spot.spotTitle
        
        
    }
    
    
    
    static func nib() -> UINib {
        return UINib(nibName: K.CollectionCells.spotCardIdentifier, bundle: nil)
    }
}
