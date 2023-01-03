//
//  SpotImageCollectionCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/31/20.
//

import UIKit

class SpotImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(with image: UIImage) {
        imageView.image                 = image
        imageView.contentMode           = .scaleAspectFill
        imageView.layer.cornerRadius    = 10
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.CollectionCells.spotImageIdentifier, bundle: nil)
    }
}
