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
    
    private var sideMenu: SideMenuNavigationController?
    
    //MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        setUpSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: true, isHidden: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: false, isHidden: false)
        }
    }
    
    //MARK: - Initialization Methods
    func setUpSideMenu() {
        let menu = MenuTVC()
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.menuWidth = UIScreen.main.bounds.width * 0.85
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    //MARK: - UI ButtonPressed Methods
    @IBAction func menuPressed(_ sender: UIButton) {
        present(sideMenu!, animated: true)
    }
}

//MARK: - GlobalUpdating Methods
extension HomepageVC: GlobalUpdating {
    func update() { }
}

//MARK: - MenuControllerDelegate Methods
extension HomepageVC: MenuControllerDelegate {
    func didSelectMenuItem(withSegue destinationSegue: String) {
        self.performSegue(withIdentifier: destinationSegue, sender: self)
    }
}
