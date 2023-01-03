//
//  SpotListCollectionViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/16/20.
//

import UIKit

class SpotListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availableNowStack: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var spotBackgroundView: UIView!
    
    let cornerRadius: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeComponents()
    }

    func initializeComponents() {
        self.backgroundColor = nil
        self.clipsToBounds = false
        spotBackgroundView.backgroundColor = nil
        spotBackgroundView.clipsToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.contentMode = .scaleAspectFill
        
    }
    
    public func configure(withSpot spot: Spot) {
        let ratingString = String(describing: spot.rating!)
        imageView.image = UIImage(named: "Example Driveway Pic")
        priceLabel.text = "$ \(spot.price!)"
        ratingLabel.text = "\(ratingString) (24)"
        titleLabel.text = spot.spotTitle
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.CollectionCells.spotListIdentifier, bundle: nil)
    }
}
