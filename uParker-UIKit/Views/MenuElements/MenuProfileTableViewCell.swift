//
//  MenuProfileTableViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/14/20.
//

import UIKit

class MenuProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var rating: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func seeReviewsPressed(_ sender: UIButton) {
    }
    
    //    public func configure(with user: User) {
//        greetingText.text = user.firstName
//        rating = user.getRating()
//    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.TableCells.menuProfileIdentifier, bundle: nil)
    }
    
}
