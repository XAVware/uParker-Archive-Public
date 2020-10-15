//
//  LoginVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/9/20.
//

import UIKit


class LoginVC: UIViewController {
    @Global var currentUser: User

    @IBOutlet weak var emailText: UnderlinedTextField!
    @IBOutlet weak var passwordText: UnderlinedTextField!
    
    //MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: true, isHidden: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: false, isHidden: false)
        }
    }
    
    
    //MARK: - UI ButtonPressed Methods
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailText.text == "On" {
            currentUser.toggleErrorHandling(enabled: true)
        } else if emailText.text == "Off" {
            currentUser.toggleErrorHandling(enabled: false)
        } else {
            login()
        }
                
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        if let email = emailText.text {
            currentUser.setEmail(email: email)
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        if let email = emailText.text {
            currentUser.setEmail(email: email)
        }
    }
    
    private func login() {
        self.performSegue(withIdentifier: K.Segues.toHomescreen, sender: self)
    }
    
}


//MARK: - GlobalUpdating
extension LoginVC: GlobalUpdating {
    func update() { }
}



