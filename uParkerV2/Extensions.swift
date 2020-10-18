//
//  extensions.swift
//  uParker
//
//  Created by Ryan Smetana on 7/23/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints                       = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive     = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive     = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive     = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive     = true
    }
}

extension UINavigationController {
    func setUpNavBar(_ navigationController: UINavigationController, isTextWhite: Bool, isHidden: Bool) {
        let tint = isTextWhite ? UIColor.white : UIColor(named: "uParkerBlue")
        let titleFont = UIFont(name: "Helvetica", size: 18.0)
        
        navigationController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: tint!,
             NSAttributedString.Key.font: titleFont!]
        
        navigationController.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: tint!]
        
        navigationController.setNavigationBarHidden(isHidden, animated: false)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = nil
        navigationController.navigationBar.layoutIfNeeded()
        navigationController.navigationBar.tintColor = tint
        
    }
}
