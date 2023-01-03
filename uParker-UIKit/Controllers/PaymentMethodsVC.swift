//
//  PaymentMethodsVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/19/20.
//

import UIKit

class PaymentMethodsVC: UIViewController {
    @Global var currentUser: User
    
    @IBOutlet weak var paymentMethodTable: UITableView!
    @IBOutlet weak var addPaymentMethodButton: UIBarButtonItem!
    
    
    var cardList: [PaymentMethod]           = []
    var tableCells: [UITableViewCell]       = []
    
    let firstTimeView = FirstTimeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
        setUpTable()
        updateUI()
    }
    
    func setUpTable() {
        paymentMethodTable.delegate           = self
        paymentMethodTable.dataSource         = self
        paymentMethodTable.backgroundColor = K.BrandColors.uParkerBlue
    }
    
    func updateUI() {
        if let navController = self.navigationController {
            navController.navigationBar.prefersLargeTitles = true
        }
        cardList = currentUser.getPaymentMethods()
        tableCells.removeAll()
        paymentMethodTable.reloadData()
        if currentUser.defaultPaymentMethod == nil {
            firstTimeView.configureWith(type: "Payment Method")
            view.addSubview(firstTimeView)
            firstTimeView.pinTo(view)
            paymentMethodTable.isUserInteractionEnabled = false
        } else {
            firstTimeView.removeFromSuperview()
            paymentMethodTable.isUserInteractionEnabled = true
        }
    }
    
    func displayActionSheet(paymentMethod: PaymentMethod, isDefault paymentMethodIsDefault: Bool) {
        let alert = UIAlertController(title: paymentMethod.cardNumber, message: "What would you like to do with this payment method?", preferredStyle: .actionSheet)
        let makeDefaultAction = UIAlertAction(title: "Make Default", style: .default) { (action) in
            self.currentUser.makeDefaultPaymentMethod(paymentMethod)
            self.updateUI()
        }
        let deleteAction = UIAlertAction(title: "Delete Payment Method", style: .destructive) { (action) in
            self.currentUser.deletePaymentMethod(paymentMethod)
            self.updateUI()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if !paymentMethodIsDefault {
            alert.addAction(makeDefaultAction)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UI Button Tapped Methods & Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toAddPayment {
            if let nextViewController = segue.destination as? AddPaymentMethodVC {
                nextViewController.previousViewController = self
            }
        }
    }
    @IBAction func addPaymentMethodPressed(_ sender: Any) {
        self.performSegue(withIdentifier: K.Segues.toAddPayment, sender: self)
    }
}



//MARK: - UITableViewDataSource Methods
extension PaymentMethodsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if cardList.count > 0 {
            return 2
        } else if currentUser.defaultPaymentMethod != nil {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return cardList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.paymentMethodCellIdentifier, for: indexPath)
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.textLabel!.text = currentUser.defaultPaymentMethod!.cardNumber
            cell.detailTextLabel!.text = currentUser.defaultPaymentMethod!.expirationDate
        } else {
            let paymentMethod = cardList[indexPath.row]
            cell.textLabel!.text = paymentMethod.cardNumber
            cell.detailTextLabel!.text = paymentMethod.expirationDate
        }
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))
        disclosureIndicator.tintColor = UIColor.white
        cell.accessoryView = disclosureIndicator
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate Methods
extension PaymentMethodsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPaymentMethod: PaymentMethod
        if indexPath.section == 0 {
            selectedPaymentMethod = currentUser.defaultPaymentMethod!
            displayActionSheet(paymentMethod: selectedPaymentMethod, isDefault: true)
        } else {
            selectedPaymentMethod = cardList[indexPath.row]
            displayActionSheet(paymentMethod: selectedPaymentMethod, isDefault: false)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = TableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        if section == 0 {
            sectionHeader.configureWith(sectionTitle: "Default Payment Method")
        } else {
            sectionHeader.configureWith(sectionTitle: "Other Payment Methods")
        }
        return sectionHeader
    }
}


//MARK: - GlobalUpdating
extension PaymentMethodsVC: GlobalUpdating {
    func update() { }
}

