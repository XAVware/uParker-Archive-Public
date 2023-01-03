//
//  ForgotPasswordVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/12/20.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @Global var currentUser: User
    
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var sentStack: UIStackView!
    @IBOutlet weak var emailText: UnderlinedTextField!
    @IBOutlet weak var submitButton: RoundButton!
    
    var email: String = ""
    
    //MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentUser.getEmail() != nil {
            emailText.text = currentUser.getEmail()
        }
    }
    
    //MARK: - UI ButtonPressed Methods
    @IBAction func submitPressed(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        if submitButton.titleLabel!.text == "Submit" {
            submitButton.setTitle("Back", for: .normal)
            //Send email and check for success message before:
            displaySentPage()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func displaySentPage() {
        emailStack.removeFromSuperview()
        sentStack.isHidden = false
    }
    
}

//MARK: - GlobalUpdating Methods
extension ForgotPasswordVC: GlobalUpdating {
    func update() { }
}
