//
//  CreateAccountVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/12/20.
//

import UIKit

class CreateAccountVC: UIViewController {
    @Global var currentUser: User
    
    @IBOutlet weak var nameStack:               UIStackView!
    @IBOutlet weak var emailStack:              UIStackView!
    @IBOutlet weak var passwordStack:           UIStackView!
    @IBOutlet weak var phoneNumberStack:        UIStackView!
    @IBOutlet weak var firstNameText:           UnderlinedTextField!
    @IBOutlet weak var greetingText:            UILabel!
    @IBOutlet weak var emailText:               UnderlinedTextField!
    @IBOutlet weak var passwordText:            UnderlinedTextField!
    @IBOutlet weak var reEnterPasswordText:     UnderlinedTextField!
    @IBOutlet weak var phoneNumberText:         UnderlinedTextField!
    @IBOutlet weak var newsletterCheckbox:      UIButton!
    @IBOutlet weak var nextButton:              RoundButton!
    
    var stackArray                  = [UIStackView]()
    var stackLocation: Int          = 0
    
    var name: String                = ""
    var email: String               = ""
    var newsletterIsSelected: Bool  = false
    var password: String            = ""
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        stackArray = [nameStack, emailStack, passwordStack, phoneNumberStack]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentUser.getEmail() != nil {
            email = currentUser.getEmail()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        next()
    }
    
    @IBAction func newsletterPressed(_ sender: Any?) {
        newsletterIsSelected.toggle()
        let imageName = newsletterIsSelected ? "checkmark.square" : "square"
        newsletterCheckbox.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    private func next() {
        //Checks if each stack is visible -> stack.isHidden == false
        switch false {
            
        case nameStack.isHidden:
            if firstNameText.text != nil {
                //Capatalizes first letter of entered name, removes leading and trailing white spaces and saves it to var
                name = firstNameText.text!.capitalizingFirstLetter().trimmingCharacters(in: .whitespacesAndNewlines)
                //Displays name in greeting in email stack
                greetingText.text = "\(name)!"
            }
            //Sets the email textbox to the optional email they entered on the login screen
            //to help make their registration process quicker
            emailText.text = email
        case emailStack.isHidden:
            email = emailText!.text!
        case passwordStack.isHidden:
            password = passwordText.text!
        case phoneNumberStack.isHidden:
            phoneNumber = phoneNumberText.text!
        default:
            print("Error")
        }
        moveToNextStack()
    }
    
    private func moveToNextStack() {
        if stackLocation < stackArray.count - 1 {
            if stackLocation == stackArray.count - 2 {
                nextButton.setTitle("Finish", for: .normal)
            }
            stackArray[stackLocation].removeFromSuperview()
            stackLocation += 1
            stackArray[stackLocation].isHidden = false
        } else {
            login()
        }
    }
    
    private func login() {
        currentUser.setFirstName(firstName: self.name)
        currentUser.setEmail(email: self.email)
        self.performSegue(withIdentifier: K.Segues.toHomescreen, sender: self)
    }
    
}


//MARK: - GlobalUpdating
extension CreateAccountVC: GlobalUpdating {
    func update() { }
}

