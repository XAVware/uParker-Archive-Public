//
//  SuggestedDestinationCollectionViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/28/20.
//

import UIKit

class SuggestedDestinationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var destinationImage: UIImageView!
    @IBOutlet weak var destinationTitle: UILabel!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    public func configure(image: UIImage, title: String) {
        destinationImage.image = image
        destinationTitle.text = title
        
        destinationImage.contentMode = .scaleAspectFill
        destinationImage.layer.cornerRadius = 25
        destinationImage.clipsToBounds = true
        
        imageBackgroundView.layer.cornerRadius = 30
        imageBackgroundView.layer.borderWidth = 2
        imageBackgroundView.layer.borderColor = K.BrandColors.uParkerBlue.cgColor
        imageBackgroundView.layer.shadowColor = UIColor.black.cgColor
        imageBackgroundView.layer.shadowRadius = 5
        imageBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageBackgroundView.layer.shadowOpacity = 0.3
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.CollectionCells.suggestionIdentifier, bundle: nil)
    }
}
