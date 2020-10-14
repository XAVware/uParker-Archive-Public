//
//  MenuVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/13/20.
//

import UIKit

class MenuTVC: UITableViewController {
    
    var menuButtonTitles: [String] = ["Profile", "Find Parking", "Your Reservations", "Your Vehicles", "Payment Methods", "Host Dashboard", "Preferences"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MenuProfileTableViewCell.nib(), forCellReuseIdentifier: K.TableCells.menuProfileIdentifier)
        tableView.register(MenuButtonTableViewCell.nib(), forCellReuseIdentifier: K.TableCells.menuButtonIdentifier)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuButtonTitles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.menuProfileIdentifier) as! MenuProfileTableViewCell
            tableView.rowHeight = 250
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.menuButtonIdentifier) as! MenuButtonTableViewCell
        cell.configure(withText: menuButtonTitles[indexPath.row])
        tableView.rowHeight = 75
        return cell
    }
    
}
