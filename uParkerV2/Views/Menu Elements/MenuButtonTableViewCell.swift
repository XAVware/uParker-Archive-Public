//
//  MenuButtonTableViewCell.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/14/20.
//

import UIKit

class MenuButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(withText buttonText: String) {
        menuButton.setTitle(buttonText, for: .normal)
        
        switch buttonText {
        case "Find Parking":
            iconImageView.image = UIImage(systemName: "mappin.and.ellipse")
        case "Your Reservations":
            iconImageView.image = UIImage(systemName: "calendar")
        case "Your Vehicles":
            iconImageView.image = UIImage(systemName: "car.fill")
        case "Payment Methods":
            iconImageView.image = UIImage(systemName: "creditcard")
        case "Host Dashboard":
            iconImageView.image = UIImage(systemName: "dollarsign.circle")
        case "Preferences":
            iconImageView.image = UIImage(systemName: "gear")
        default:
            iconImageView.image = UIImage(systemName: "")
        }
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: K.TableCells.menuButtonIdentifier, bundle: nil)
    }
}
