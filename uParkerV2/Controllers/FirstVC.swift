//
//  FirstVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/9/20.
//

import UIKit

class FirstVC: UIViewController {
    @Global var currentUser: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
    }
}

//MARK: - GlobalUpdating
extension FirstVC: GlobalUpdating {
    func update() { }

}
