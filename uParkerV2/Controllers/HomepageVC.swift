//
//  HomepageVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/13/20.
//

import UIKit

class HomepageVC: UIViewController {
    @Global var currentUser: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(with: navController, isHidden: false)
        }
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.toMenu, sender: self)
    }
    
    @IBAction func reservationsClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.toReservations, sender: self)
    }
    
}

extension HomepageVC: GlobalUpdating {
    func update() { }
}


