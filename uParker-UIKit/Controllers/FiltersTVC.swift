//
//  FiltersTVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 11/12/20.
//

import UIKit
import RangeSeekSlider

class FiltersTVC: UITableViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSlider: PriceRangeSlider!
    @IBOutlet weak var reviewSlider: RangeSeekSlider!
    @IBOutlet weak var starOne: UIButton!
    @IBOutlet weak var starTwo: UIButton!
    @IBOutlet weak var starThree: UIButton!
    @IBOutlet weak var starFour: UIButton!
    @IBOutlet weak var starFive: UIButton!
    
    var priceOptions: [Int]!
    var starArray: [UIButton]!
    
    let fullStar = UIImage(systemName: "star.fill")
    let halfStar = UIImage(systemName: "star.leadinghalf.fill")
    let emptyStar = UIImage(systemName: "star")
    let emptyCircle = UIImage(systemName: "circle")
    let fullCircle = UIImage(systemName: "checkmark.circle.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceSlider.setLabel(label: priceLabel)
        initializeReviewSlider()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
    }
    
    func initializeReviewSlider() {
        starArray = [starOne, starTwo, starThree, starFour, starFive]
        starOne.accessibilityLabel = K.Accessibility.starOne
        starTwo.accessibilityLabel = K.Accessibility.starTwo
        starThree.accessibilityLabel = K.Accessibility.starThree
        starFour.accessibilityLabel = K.Accessibility.starFour
        starFive.accessibilityLabel = K.Accessibility.starFive
        
        reviewSlider.delegate = self
        reviewSlider.enableStep = true
        reviewSlider.step = 1
        reviewSlider.minValue = CGFloat(0)
        reviewSlider.maxValue = CGFloat(10)
        reviewSlider.minDistance = 1
        reviewSlider.handleDiameter = 20
        reviewSlider.lineHeight = 3

    }
    
    @IBAction func starTapped(_ sender: UIButton) {
        
        if let senderInt = Int(sender.accessibilityLabel!) {
            reviewSlider.selectedMaxValue = CGFloat(senderInt * 2)
//            reviewSlider.layoutSubviews()
            
            let senderArrayIndex = senderInt - 1
            var count = 0
            for star in starArray {
                if count <= senderArrayIndex {
                    star.alpha = 1
                } else {
                    star.alpha = 0.4
                }
                count += 1
            }
        } else {
            print("Star Accessibility Label can not be converted to Integer. Check Constants file and initialization method.")
        }
    }
    
}

extension FiltersTVC: RangeSeekSliderDelegate {
    func didStartTouches(in slider: RangeSeekSlider) {
        //
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        //
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        //Update images
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        return "1"
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        return "10"
    }
}
