//
//  YourVehiclesVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/15/20.
//

import UIKit

class YourVehiclesVC: UIViewController {
    @Global var currentUser: User
    
    @IBOutlet weak var addVehicleButton: UIButton!
    @IBOutlet weak var vehicleTable: UITableView!
    
    var ownedVehicles: [Vehicle]            = []
    var tableCells: [UITableViewCell]       = []
    
    let firstTimeView = FirstTimeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        vehicleTable.delegate           = self
        vehicleTable.dataSource         = self
        vehicleTable.backgroundColor = K.BrandColors.uParkerBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toAddVehicle {
            if let nextViewController = segue.destination as? AddVehicleVC {
                nextViewController.previousViewController = self
            }
        }
    }
    
    @IBAction func addVehiclePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.Segues.toAddVehicle, sender: self)
    }
    
    
    func updateUI() {
        ownedVehicles = currentUser.getOwnedVehicles()
        tableCells.removeAll()
        vehicleTable.reloadData()
        if currentUser.primaryVehicle == nil {
            firstTimeView.configureWith(type: "Vehicle")
            view.addSubview(firstTimeView)
            firstTimeView.pinTo(view)
        } else {
            firstTimeView.removeFromSuperview()
        }
    }
}



//MARK: - UITableViewDataSource & Delegate
extension YourVehiclesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if ownedVehicles.count > 0 {
            return 2
        } else if currentUser.primaryVehicle != nil {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return ownedVehicles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath)
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.textLabel!.text = currentUser.primaryVehicle!.vehicle
            cell.detailTextLabel!.text = currentUser.primaryVehicle!.licensePlate
        } else {
            let vehicle = ownedVehicles[indexPath.row]
            cell.textLabel!.text = vehicle.vehicle
            cell.detailTextLabel!.text = vehicle.licensePlate
        }
        
        
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = UIColor.white
        cell.accessoryView = disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedVehicle: Vehicle
        if indexPath.section == 0 {
            selectedVehicle = currentUser.primaryVehicle!
        } else {
            selectedVehicle = ownedVehicles[indexPath.row]
        }
        
        let alert = UIAlertController(title: selectedVehicle.vehicle, message: "What would you like to do with this vehicle?", preferredStyle: .actionSheet)
        
        let makeDefaultAction = UIAlertAction(title: "Make Default", style: .default) { (action) in
            self.currentUser.makePrimaryVehicle(selectedVehicle)
            self.updateUI()
        }
        
        let deleteAction = UIAlertAction(title: "Delete Vehicle", style: .destructive) { (action) in
            self.currentUser.deleteVehicle(selectedVehicle)
            self.updateUI()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        
        if indexPath.section != 0 {
            alert.addAction(makeDefaultAction)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor(named: "uParker Blue")
        view.alpha = 1
        
        let bottomLine = CALayer()
        let bottomLineInset: CGFloat = 15.0
        let bottomLineWidth = view.frame.width - (bottomLineInset * 2)
        
        bottomLine.frame = CGRect(x: bottomLineInset, y: view.frame.height - 1, width: bottomLineWidth, height: 1)
        bottomLine.backgroundColor = UIColor(white: 1, alpha: 0.3).cgColor
        
        view.layer.addSublayer(bottomLine)
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width - 15, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        if section == 0 {
            label.text = "Default Vehicle"
        } else {
            label.text = "Other Vehicles"
        }
        
        view.addSubview(label)
        return view
    }
}

//MARK: - GlobalUpdating
extension YourVehiclesVC: GlobalUpdating {
    func update() { }
}
