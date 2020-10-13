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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        emailText.delegate = self
        passwordText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
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


//MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            login()
        }
        return false
    }
}

//MARK: - GlobalUpdating
extension LoginVC: GlobalUpdating {
    func update() { }
}



