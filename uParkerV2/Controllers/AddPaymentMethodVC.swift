//
//  AddPaymentMethodVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/19/20.
//

import UIKit

class AddPaymentMethodVC: UIViewController {
    @Global var currentUser: User
    var previousViewController:             PaymentMethodsVC!
    @IBOutlet weak var nameStack:           UIStackView!
    @IBOutlet weak var cardNumberStack:     UIStackView!
    @IBOutlet weak var expirationStack:     UIStackView!
    @IBOutlet weak var cvcStack:            UIStackView!
    @IBOutlet weak var nameOnCardText:      UITextField!
    @IBOutlet weak var cardNumberText:      UITextField!
    @IBOutlet weak var expirationPicker:    ExpirationPickerView!
    @IBOutlet weak var cvcText:             UITextField!
    @IBOutlet weak var nextButton:          UIButton!
    
    var nameOnCard:             String?
    var cardNumber:             String?
    var expirationMonth:        String?
    var expirationYear:         String?
    var expiration:             String?
    var cvc:                    String?
    
    var stackArray              = [UIStackView] ()
    var stackLocation: Int      = 0
    
    
    //MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        navigationController?.navigationBar.prefersLargeTitles = false
        stackArray = [nameStack, cardNumberStack, expirationStack, cvcStack]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: false, isHidden: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navController = self.navigationController {
            navController.setUpNavBar(navController, isTextWhite: true, isHidden: false)
        }
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
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
            finish()
        }
    }
    
    private func finish() {
        let nameOnCard = nameOnCardText.text
        let cardNumber = cardNumberText.text
        let expirationMonth = expirationPicker.month ?? "none"
        let expirationYear = expirationPicker.year ?? "none"
        let cvc = cvcText.text
        
        
        let expirationDate = "\(expirationMonth) / \(expirationYear)"
        let tempPaymentMethod = PaymentMethod(nameOnCard: nameOnCard!, cardNumber: cardNumber!, expirationDate: expirationDate, cvc: cvc!)
        currentUser.addPaymentMethod(newPaymentMethod: tempPaymentMethod)
        previousViewController!.updateUI()
        self.navigationController!.popViewController(animated: true)
    }
    
}


//MARK: - GlobalUpdating
extension AddPaymentMethodVC: GlobalUpdating {
    func update() { }
}

