//
//  MenuVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/13/20.
//

import UIKit

class MenuTVC: UITableViewController {
    
    public var delegate: MenuControllerDelegate?
    
    var menuItems: [String] = ["Profile", "Find Parking", "Your Reservations", "Your Vehicles", "Payment Methods", "Host Dashboard", "Preferences"]
    
    var menuButtonDestinations: [String:String] = ["Profile": "",
                                                   "Find Parking": K.Segues.toFindParking,
                                                   "Your Reservations": K.Segues.toReservations,
                                                   "Your Vehicles": K.Segues.toVehicles,
                                                   "Payment Methods": K.Segues.toPaymentMethods,
                                                   "Host Dashboard": K.Segues.toHostDashboard,
                                                   "Preferences": K.Segues.toPreferences]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MenuProfileTableViewCell.nib(), forCellReuseIdentifier: K.TableCells.menuProfileIdentifier)
        tableView.register(MenuButtonTableViewCell.nib(), forCellReuseIdentifier: K.TableCells.menuButtonIdentifier)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
        let selectedItem = menuItems[indexPath.row]
        let destination = menuButtonDestinations[selectedItem]
        delegate?.didSelectMenuItem(withSegue: destination!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.menuProfileIdentifier) as! MenuProfileTableViewCell
            tableView.rowHeight = 250
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.menuButtonIdentifier) as! MenuButtonTableViewCell
        cell.configure(withText: menuItems[indexPath.row])
        tableView.rowHeight = 75
        return cell
    }
    
}

//MARK: - MenuControllerDelegate Protocol
protocol MenuControllerDelegate {
    func didSelectMenuItem(withSegue destinationSegue: String)
}
