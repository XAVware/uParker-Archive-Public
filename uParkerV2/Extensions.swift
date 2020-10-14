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
    func setUpNavBar(with navigationController: UINavigationController, isHidden: Bool) {
        navigationController.setNavigationBarHidden(isHidden, animated: true)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.layoutIfNeeded()
    }
}
