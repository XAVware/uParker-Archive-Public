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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

//MARK: - GlobalUpdating
extension FirstVC: GlobalUpdating {
    func update() { }

}
