//
//  SpotVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/30/20.
//

import UIKit

class SpotVC: UIViewController {
    @IBOutlet weak var imageCollection: SpotImageCollectionView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var reviewCardCollection: ReviewCardCollectionView!
    
    var reviewListVC: ReviewListVC?
    
    var reviewList: [Review] = [Review(reviewerID: 1, spotID: 1, reviewDate: "Oct. 2020", rating: 5, review: "Super easy to find this spot"),
                                Review(reviewerID: 2, spotID: 1, reviewDate: "Nov. 2020", rating: 5, review: "Very close to beaver stadium"),
                                Review(reviewerID: 3, spotID: 1, reviewDate: "Nov. 2020", rating: 3, review: "I had a hard time fitting my vehicle"),
                                Review(reviewerID: 4, spotID: 1, reviewDate: "Dec. 2020", rating: 5, review: "Owner is really friendly")]
    
    var imageList: [UIImage] = [UIImage(named: "Example Driveway Pic")!,
                                UIImage(named: "Example Driveway Pic")!,
                                UIImage(named: "Example Driveway Pic")!,
                                UIImage(named: "Example Driveway Pic")!,
                                UIImage(named: "Example Driveway Pic")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewCardCollection.configure(withReviews: reviewList, parent: self)
        imageCollection.configure(withImages: imageList, parentView: self.view)
        
    }
    
    func openReviewList() {
//        reviewListVC = storyboard!.instantiateViewController(withIdentifier: K.ViewControllers.reviewListVC) as? ReviewListVC
//        guard reviewListVC != nil else {
//            print("ReviewListVC not initialized")
//            return
//        }
////        reviewListVC!.delegate = self
//        reviewListVC!.initialBackgroundFrame = reviewCardCollection.frame
//
//        addChild(reviewListVC!)
//
//        self.view.addSubview(reviewListVC!.view)
//        reviewListVC!.didMove(toParent: self)
//        reviewListVC!.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            reviewListVC!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            reviewListVC!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            reviewListVC!.view.topAnchor.constraint(equalTo: self.view.topAnchor),
//            reviewListVC!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//        reviewListVC!.openListView()
        guard let reviewListVC = storyboard!.instantiateViewController(withIdentifier: K.ViewControllers.reviewListVC) as? ReviewListVC else {
            print("Error initializing ReviewListVC")
            return
        }
        reviewListVC.setReviewList(to: self.reviewList)
        self.navigationController?.present(reviewListVC, animated: false, completion: nil)
    }
    
    @IBAction func reservePressed(_ sender: UIButton) {
        guard let confirmationVC = self.storyboard?.instantiateViewController(identifier: K.ViewControllers.confirmationVC) as? ConfirmationVC else {
            print("Error initializing ConfirmationVC")
            return
        }
        self.navigationController?.present(confirmationVC, animated: false, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

