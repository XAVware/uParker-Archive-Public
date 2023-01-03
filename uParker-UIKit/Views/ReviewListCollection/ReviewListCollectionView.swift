//
//  ReviewListCollection.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/19/20.
//

import UIKit

class ReviewListCollectionView: UICollectionView {
    let collectionViewHeight: CGFloat       = 85
    let cellSpacing: CGFloat                = 40
    
    var cellWidth: CGFloat {
        return UIScreen.main.bounds.width - cellSpacing
    }
    
    var cellHeight: CGFloat {
        return collectionViewHeight - 20
    }
    
    var sideInset: CGFloat {
        return cellSpacing / 2
    }
    
    var collectionLayout: UICollectionViewFlowLayout {
        let layout                          = UICollectionViewFlowLayout()
        layout.itemSize                     = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection              = .vertical
        layout.sectionInset                 = UIEdgeInsets(top: 5, left: sideInset, bottom: 5, right: sideInset)
        return layout
    }
    
    var reviewList: [Review]                    = []
    var parentViewController: SpotVC?
    var reviewListVC: ReviewListVC?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initializeCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeCollectionView()
    }
    
    convenience init() {
        self.init()
        initializeCollectionView()
    }
    
    func initializeCollectionView() {        
        self.delegate                                   = self
        self.dataSource                                 = self
        self.backgroundColor                            = nil
        self.showsHorizontalScrollIndicator             = false
        self.isScrollEnabled                            = true
        self.isPagingEnabled                            = true
        self.contentMode                                = .center
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.collectionViewLayout                       = collectionLayout
        self.register(ReviewListCollectionViewCell.nib(), forCellWithReuseIdentifier: K.CollectionCells.reviewListIdentifier)
        self.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
    }
    
    func configure(withReviews reviewList: [Review]) {
//        self.parentViewController = parent
        self.reviewList = reviewList
        self.reloadData()
    }
    
    
    
}

//MARK: - CollectionView Delegate Methods
extension ReviewListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        parentViewController!.openReviewList()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
//            parentViewController?.selectSpotAnnotation(spotIndex: indexPath!.row)
        }
    }
}

//MARK: - CollectionView DataSource Methods
extension ReviewListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCells.reviewListIdentifier, for: indexPath) as! ReviewListCollectionViewCell
        cell.configure(withReview: reviewList[indexPath.item])
        return cell
    }
}

//MARK: - CollectionView FlowLayout Methods
extension ReviewListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}



