//
//  ReviewListVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/18/20.
//

import UIKit

class ReviewListVC: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var starStack: UIStackView!
//    @IBOutlet weak var reviewListCollection: ReviewListCollectionView!
    
    
    //Initial frame is set to match Map's search bar frame, uses this as default
    var initialBackgroundFrame: CGRect = CGRect(x: UIScreen.main.bounds.width / 2, y: 115, width: 1, height: 10)
    
    var delegate: MapVC?
    
    //This view will be created directly on top of the map search bar for the animation starting point
    var backgroundView: UIView!
    
    var reviewList: [Review] = []
    
    var reviewListCollection: ReviewListCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mainStack.alpha = 0
//        closeButton.alpha = 0
//        backgroundView = UIView(frame: initialBackgroundFrame)
//        view.backgroundColor = nil
//        backgroundView.backgroundColor = .white
//        view.addSubview(backgroundView)
//        view.sendSubviewToBack(backgroundView)
//        reviewListCollection = ReviewListCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: .init())
    }
    
    func setReviewList(to list: [Review]) {
        reviewListCollection = ReviewListCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: .init())
        self.reviewList = list
        reviewListCollection!.configure(withReviews: reviewList)
        view.addSubview(reviewListCollection!)
        reviewListCollection!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reviewListCollection!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            reviewListCollection!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            reviewListCollection!.topAnchor.constraint(equalTo: starStack.bottomAnchor, constant: 20),
            reviewListCollection!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    
    @IBAction func closePressed(_ sender: UIButton) {
//        guard delegate != nil else {
//            print("Search View Delegate is nil")
//            return
//        }
//        UIView.animate(withDuration: 0.1) {
//            self.mainStack.alpha = 0
//            self.closeButton.alpha = 0
//        } completion: { (finished) in
//            UIView.animate(withDuration: 0.1) {
//                self.backgroundView.alpha = 0
//                self.backgroundView.frame = self.initialBackgroundFrame
//            } completion: { (finished) in
//                self.view.removeFromSuperview()
//                self.delegate!.cleanUp()
//            }
//        }
        self.dismiss(animated: false, completion: nil)
    }
    
//    func openListView() {
//        UIView.animate(withDuration: 0.1, animations: {
//            self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//            self.backgroundView.alpha = 1
//        }) { (finished) in
//            UIView.animate(withDuration: 0.1) {
//                self.mainStack.alpha = 1
//                self.closeButton.alpha = 1
//            }
//
//        }
//    }
}
