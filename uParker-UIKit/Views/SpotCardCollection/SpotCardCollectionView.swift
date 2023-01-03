//
//  SpotCardCollectionView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/30/20.
//

import UIKit

class SpotCardCollectionView: UICollectionView {
    
    var cellWidth: CGFloat                  = 300
    var cellHeight: CGFloat                 = 100
    let cellSpacing: CGFloat                = 40
    var spotList: [Spot]                    = []
    var parentViewController: MapVC?
    
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
    
    func setParent(_ parent: MapVC) {
        parentViewController = parent
    }
    
    
    
    func initializeCollectionView() {
        self.delegate                       = self
        self.dataSource                     = self
        
        let sideInset                       = cellSpacing / 2
        cellWidth                           = UIScreen.main.bounds.width - cellSpacing
        
        self.backgroundColor                = nil
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled                = true
        self.isPagingEnabled                = true
        self.contentMode                    = .center
        
        self.register(SpotCardCollectionViewCell.nib(), forCellWithReuseIdentifier: K.CollectionCells.spotCardIdentifier)
        
        let layout                          = UICollectionViewFlowLayout()
        layout.itemSize                     = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection              = .horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 5, left: sideInset, bottom: 5, right: sideInset)
        self.collectionViewLayout           = layout
    }
    
    func configure(with spotList: [Spot]) {
        self.spotList = spotList
        self.reloadData()
    }
    
    
    
    
}

//MARK: - CollectionView Delegate Methods
extension SpotCardCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        parentViewController!.openSpot()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            parentViewController?.selectSpotAnnotation(spotIndex: indexPath!.row)
        }
    }
}

//MARK: - CollectionView DataSource Methods
extension SpotCardCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        spotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCells.spotCardIdentifier, for: indexPath) as! SpotCardCollectionViewCell
        cell.configure(withSpot: spotList[indexPath.item])
        return cell
    }
    
    
    
}

//MARK: - CollectionView FlowLayout Methods
extension SpotCardCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
