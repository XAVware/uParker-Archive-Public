//
//  ConfirmationVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/15/20.
//

import UIKit

class ConfirmationVC: UIViewController {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func changeVehicleTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func changePaymentTapped(_ sender: UIButton) {
    }
    
}
