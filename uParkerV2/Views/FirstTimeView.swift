//
//  FirstTimeView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/18/20.
//

import UIKit

class FirstTimeView: UIView {
    let imageHeight: CGFloat = 150
    let vehicleLabelText = "You haven't saved any vehicles yet! You need to add a vehicle before you can reserve parking!"
    let paymentMethodLabelText = "You haven't saved any payment methods yet! You need to add a payment method before you can reserve parking!"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        setupView()
    }
    
    func configureWith(type: String) {
        switch type {
        
        case "Vehicle":
            let image = UIImageView(image: UIImage(systemName: "car.fill"))
            let labelText = vehicleLabelText
            setupView(withImage: image, withText: labelText)
            
        case "Payment Method":
            let image = UIImageView(image: UIImage(systemName: "creditcard"))
            let labelText = paymentMethodLabelText
            setupView(withImage: image, withText: labelText)
            
        default:
            let image = UIImageView(image: UIImage(systemName: ""))
            let labelText = vehicleLabelText
            setupView(withImage: image, withText: labelText)
        }
    }
    
    private func setupView(withImage image: UIImageView, withText labelText: String) {
        backgroundColor = UIColor(named: "uParker Blue")
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 15
        self.addSubview(stackView)
        stackView.pin(to: self)
        
        
        
        
        
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackView.addArrangedSubview(image)
        
        
        
        
        let label = UILabel()
        label.text = labelText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica", size: 24)
        
        stackView.addArrangedSubview(label)
        
        
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    
    
    
    
    
    
    func pinTo(_ superView: UIView) {
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 200).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 15).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -15).isActive = true
    }
    
}
