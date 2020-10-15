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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(with: navController, backgroundColor: .white, isHidden: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if let navController = self.navigationController {
//            navController.setUpNavBar(with: navController, backgroundColor: UIColor(named: "uParker Blue")!, isHidden: false)
//        }
    }
}

//MARK: - GlobalUpdating
extension ReservationsVC: GlobalUpdating {
    func update() { }
}
