//
//  AddVehicleVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/15/20.
//

import UIKit

class AddVehicleVC: UIViewController, UIGestureRecognizerDelegate {
    @Global var currentUser: User
    var previousViewController: YourVehiclesVC?
    
    
    @IBOutlet weak var vehicleStack:            UIStackView!
    @IBOutlet weak var colorStack:              UIStackView!
    @IBOutlet weak var licensePlateStack:       UIStackView!
    @IBOutlet weak var vehiclePicker:           VehiclePickerView!
    @IBOutlet weak var colorPicker:             ColorPickerView!
    @IBOutlet weak var licensePlateText:        UnderlinedTextField!
    @IBOutlet weak var nextButton:              RoundButton!
    
    var make: String?
    var model: String?
    var color: String?
    var licensePlate: String?
    
    var stackArray                  = [UIStackView]()
    var stackLocation:Int           = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        stackArray = [vehicleStack, colorStack, licensePlateStack]
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
            stackArray[stackLocation].isHidden = true
            stackLocation += 1
            stackArray[stackLocation].isHidden = false
        } else {
            finish()
        }
    }
    
    private func finish() {
        let make = vehiclePicker.make
        let model = vehiclePicker.model
        let color = colorPicker.color
        let licensePlate = licensePlateText.text
        let vehicleType = "\(color!) \(make!) \(model!)"
        let tempVehicle = Vehicle(vehicle: vehicleType, licensePlate: licensePlate!)
        currentUser.addVehicle(newVehicle: tempVehicle)
        previousViewController!.updateUI()
        self.navigationController!.popViewController(animated: true)
    }

    
}

//MARK: - GlobalUpdating
extension AddVehicleVC: GlobalUpdating {
    func update() { }
}

