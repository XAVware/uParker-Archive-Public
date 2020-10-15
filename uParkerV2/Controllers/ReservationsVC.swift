//
//  ReservationsVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/14/20.
//

import UIKit

class ReservationsVC: UIViewController {
    @Global var currentUser: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
    }
    
    //MARK: - ViewController Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: false, isHidden: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: - GlobalUpdating
extension ReservationsVC: GlobalUpdating {
    func update() { }
}
