//
//  SearchVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/28/20.
//

import UIKit
import FSCalendar

class SearchVC: UIViewController {
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var updateButton: RoundButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateButton: UIButton!
    
    //Initial frame is set to match Map's search bar frame, uses this as default
    var initialBackgroundFrame: CGRect = CGRect(x: UIScreen.main.bounds.width / 2, y: 115, width: 1, height: 10)
    
    var delegate: MapVC?
    
    //This view will be created directly on top of the map search bar for the animation starting point
    var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStack.alpha = 0
        updateButton.alpha = 0
        backgroundView = UIView(frame: initialBackgroundFrame)
        view.backgroundColor = nil
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        initializeDateButton()
        initializeCalendar()
    }
    
    @IBAction func datePressed(_ sender: UIButton) {
        var endAlpha: CGFloat!
        if calendar.alpha == 0 {
            endAlpha = 1
        } else {
            endAlpha = 0
        }
        UIView.animate(withDuration: 0.1) {
            self.calendar.alpha = endAlpha
        }
    }
    
    func initializeDateButton() {
        dateButton.backgroundColor = .white
        dateButton.layer.borderColor = UIColor.white.cgColor
        dateButton.layer.borderWidth = 1
        dateButton.layer.cornerRadius = 15
        dateButton.layer.shadowColor = UIColor.black.cgColor
        dateButton.layer.shadowRadius = 5
        dateButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        dateButton.layer.shadowOpacity = 0.3
    }
    
    func initializeCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        guard delegate != nil else {
            print("Search View Delegate is nil")
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.mainStack.alpha = 0
            self.updateButton.alpha = 0
        } completion: { (finished) in
            UIView.animate(withDuration: 0.1) {
                self.backgroundView.alpha = 0
                self.backgroundView.frame = self.initialBackgroundFrame
            } completion: { (finished) in
                self.view.removeFromSuperview()
                self.delegate!.cleanUp()
            }
        }

    }
    
    func openSearchView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.backgroundView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: 0.1) {
                self.mainStack.alpha = 1
                self.updateButton.alpha = 1
            }
            
        }
    }
    
    
    
}

//MARK: - FSCalendar DataSource Methods
extension SearchVC: FSCalendarDataSource {
    
}

//MARK: - FSCalendar Delegate Methods
extension SearchVC: FSCalendarDelegate {
    
}

