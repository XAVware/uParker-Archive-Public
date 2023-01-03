//
//  SpotImageCollectionView.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/17/20.
//

import UIKit

class SpotImageCollectionView: UICollectionView {

    let imagePageControl: UIPageControl! = UIPageControl()
    var recommendedSize: CGSize!
    var imageList: [UIImage] = []

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
        self.delegate = self
        self.dataSource = self
        self.register(SpotImageCollectionCell.nib(), forCellWithReuseIdentifier: K.CollectionCells.spotImageIdentifier)
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled                = true
        self.isPagingEnabled                = true
        self.contentMode                    = .center
                
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.collectionViewLayout = layout
        
    }
    
    func configure(withImages images: [UIImage], parentView: UIView) {
        imageList = images
        
        recommendedSize                                     = imagePageControl.size(forNumberOfPages: imageList.count)
        imagePageControl.frame                              = CGRect(x: 0, y: 0, width: recommendedSize.width, height: recommendedSize.height)
        imagePageControl.currentPageIndicatorTintColor      = K.BrandColors.uParkerBlue
        imagePageControl.pageIndicatorTintColor             = K.BrandColors.uParkerBlue.withAlphaComponent(0.4)
        imagePageControl.numberOfPages                      = imageList.count
        imagePageControl.isUserInteractionEnabled           = false
        
        parentView.addSubview(imagePageControl)
        parentView.bringSubviewToFront(imagePageControl)
        
        imagePageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePageControl.heightAnchor.constraint(equalToConstant: recommendedSize.height),
            imagePageControl.widthAnchor.constraint(equalToConstant: recommendedSize.width),
            imagePageControl.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.maxY - recommendedSize.height),
            imagePageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        self.reloadData()
    }
}

//MARK: - CollectionViewDelegate Methods
extension SpotImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            self.imagePageControl.currentPage = indexPath!.item
        }
    }
    
}

//MARK: - CollectionViewDataSource Methods
extension SpotImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellImage: UIImage = imageList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCells.spotImageIdentifier, for: indexPath) as! SpotImageCollectionCell
        cell.configure(with: cellImage)
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout Methods
extension SpotImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
