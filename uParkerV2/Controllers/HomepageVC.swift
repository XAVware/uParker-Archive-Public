//
//  HomepageVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/13/20.
//

import UIKit
import SideMenu

class HomepageVC: UIViewController {
    @Global var currentUser: User
    
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        
        
        menu = SideMenuNavigationController(rootViewController: MenuTVC())
        menu?.menuWidth = UIScreen.main.bounds.width * 0.85
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(with: navController, backgroundColor: UIColor(named: "uParkerBlue")!, isHidden: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(with: navController, backgroundColor: .white, isHidden: false)
        }
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
//        self.performSegue(withIdentifier: K.Segues.toMenu, sender: self)
        present(menu!, animated: true)
    }
    
    @IBAction func reservationsClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.toReservations, sender: self)
    }
    
}

extension HomepageVC: GlobalUpdating {
    func update() { }
}


