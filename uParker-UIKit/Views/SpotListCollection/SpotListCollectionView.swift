//
//  SpotListCollectionView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/16/20.
//

import UIKit

class SpotListCollectionView: UICollectionView {
    let cellSpacing: CGFloat                = 20
    let sideInset: CGFloat                  = 30
    let topInset: CGFloat                   = 5
    let bottomInset: CGFloat                = 5

    var cellWidth: CGFloat {
        return UIScreen.main.bounds.width - (sideInset * 2)
    }
    
    var cellHeight: CGFloat {
        let height = cellWidth * 0.75
        if height >= 250 {
            return 250
        } else {
            return height
        }
    }

    var collectionLayout: UICollectionViewFlowLayout {
        let layout                          = UICollectionViewFlowLayout()
        layout.itemSize                     = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection              = .vertical
        layout.sectionInset                 = UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
        return layout
    }
    
    
    
    
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
       
    func initializeCollectionView() {
        self.delegate                       = self
        self.dataSource                     = self
        self.backgroundColor                = nil
        self.showsVerticalScrollIndicator   = false
        self.isScrollEnabled                = true
        self.contentMode                    = .center
        self.collectionViewLayout           = collectionLayout
        self.register(SpotListCollectionViewCell.nib(), forCellWithReuseIdentifier: K.CollectionCells.spotListIdentifier)
    }
    
    func addSeparator(yPos: CGFloat) {
        let yPosition = yPos + (cellSpacing / 2)
        let separator = CALayer()
        separator.frame = CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.width, height: 0.5)
        separator.backgroundColor = UIColor(white: 0.6, alpha: 0.4).cgColor
        self.layer.addSublayer(separator)
    }
    
    func configure(with spotList: [Spot], parent: MapVC) {
        self.spotList = spotList
        self.parentViewController = parent
        self.reloadData()
    }
}

//MARK: - CollectionView Delegate Methods
extension SpotListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        parentViewController!.openSpot()
    }
}

//MARK: - CollectionView DataSource Methods
extension SpotListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCells.spotListIdentifier, for: indexPath) as! SpotListCollectionViewCell
        cell.configure(withSpot: spotList[indexPath.item])
        addSeparator(yPos: cell.frame.maxY)
        return cell
    }
}

//MARK: - CollectionView FlowLayout Methods
extension SpotListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
