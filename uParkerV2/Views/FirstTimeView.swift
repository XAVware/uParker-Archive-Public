//
//  FirstTimeView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/18/20.
//

import UIKit

class FirstTimeView: UIView {
    let stackView = UIStackView()
    let imageView = UIImageView()
    let label = UILabel()
    
    let imageHeight: CGFloat = 150
    let vehicleLabelText = "You haven't saved any vehicles yet! You need to add a vehicle before you can reserve parking!"
    let paymentMethodLabelText = "You haven't saved any payment methods yet! You need to add a payment method before you can reserve parking!"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWith(type: String) {
        var labelText: String!
        let image: UIImage!
        
        switch type {
        
        case "Vehicle":
            image = UIImage(systemName: "car.fill")
            labelText = vehicleLabelText
            
        case "Payment Method":
            image = UIImage(systemName: "creditcard")
            labelText = paymentMethodLabelText
            
        default:
            image = UIImage(systemName: "")
            labelText = vehicleLabelText
        }
        
        setupView(withImage: image, withText: labelText)
    }
    
    private func setupView(withImage image: UIImage, withText labelText: String) {
        backgroundColor = UIColor(named: "uParker Blue")
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 15
        self.addSubview(stackView)
        stackView.pin(to: self)
        
        imageView.image = image
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        label.text = labelText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica", size: 24)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        setConstraints()
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints     = false
        translatesAutoresizingMaskIntoConstraints           = false
    }
    
    
    
    
    
    func pinTo(_ superView: UIView) {
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 200).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 15).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -15).isActive = true
    }
    
}
