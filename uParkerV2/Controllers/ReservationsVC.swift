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
    
}

//MARK: - GlobalUpdating
extension ReservationsVC: GlobalUpdating {
    func update() { }
}
