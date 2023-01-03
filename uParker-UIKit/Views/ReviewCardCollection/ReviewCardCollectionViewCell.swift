//
//  ReviewCardCollectionViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/17/20.
//

import UIKit

class ReviewCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeComponents()
    }
    
    func initializeComponents() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
        
        starOne.accessibilityLabel = K.Accessibility.starOne
        starTwo.accessibilityLabel = K.Accessibility.starTwo
        starThree.accessibilityLabel = K.Accessibility.starThree
        starFour.accessibilityLabel = K.Accessibility.starFour
        starFive.accessibilityLabel = K.Accessibility.starFive
        
        background.layer.cornerRadius = 10
        background.clipsToBounds = true
    }
    
    public func configure(withReview review: Review) {
        ratingLabel.text = "\(String(describing: review.rating)) / 5.0"
        reviewLabel.text = review.review
        dateLabel.text = review.reviewDate
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.CollectionCells.reviewCardIdentifier, bundle: nil)
    }
}
