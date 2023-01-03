//
//  CircularProgressView.swift
//  uParker
//
//  Created by Ryan Smetana on 8/25/20.
//  Copyright © 2020 Ryan Smetana. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    let shapeLayer = CAShapeLayer()
    
    var durationStack: UIStackView!
    var arriveButton: UIButton!
    var labelArray: [UILabel] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgressView()
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init( coder: aDecoder)
        createProgressView()
    }
    
    
    func createProgressView() {
        let circleCenter: CGPoint   = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        createDurationLabels()
        
        let circularPath            = UIBezierPath(arcCenter: circleCenter,
                                                        radius: 80,
                                                        startAngle: -CGFloat.pi / 2,
                                                        endAngle: 2 * CGFloat.pi,
                                                        clockwise: true)


        self.layer.addSublayer(createTrackLayer(path: circularPath))
        self.layer.addSublayer(createShapeLayer(path: circularPath))
        self.addSubview(createDurationStack())
        self.addSubview(createArriveButton())
        setDurationStackConstraints()
    }
    
    func createTrackLayer(path: UIBezierPath) -> CAShapeLayer {
        let trackLayer              = CAShapeLayer()
        trackLayer.path             = path.cgPath
        trackLayer.strokeColor      = K.BrandColors.uParkerLightBlue.cgColor
        trackLayer.lineWidth        = 20
        trackLayer.fillColor        = UIColor.clear.cgColor
        trackLayer.lineCap          = .round
        return trackLayer
    }
    
    func createShapeLayer(path: UIBezierPath) -> CAShapeLayer {
        shapeLayer.path             = path.cgPath
        shapeLayer.strokeColor      = K.BrandColors.uParkerBlue.cgColor
        shapeLayer.lineWidth        = 20
        shapeLayer.fillColor        = UIColor.clear.cgColor
        shapeLayer.lineCap          = .round
        shapeLayer.strokeEnd        = 1
        
        return shapeLayer
    }
    
    func createArriveButton() -> UIButton {
        arriveButton                        = UIButton.init(type: .system)
        arriveButton.frame                  = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        arriveButton.setTitle               ("Arrive", for: .normal)
        arriveButton.setTitleColor          (K.BrandColors.uParkerBlue, for: .normal)
        arriveButton.titleLabel?.font       = UIFont(name: "Helvetica", size: 24)
        
        arriveButton.addTarget(self, action: #selector(arrivePressed), for: .touchUpInside)
        
        return arriveButton
    }
    
    
    @objc func arrivePressed() {
        let basicAnimation                      = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue                  = 0
        basicAnimation.duration                 = 2
        basicAnimation.fillMode                 = .forwards
        basicAnimation.isRemovedOnCompletion    = false
        shapeLayer.add(basicAnimation, forKey: "duration")
        
        arriveButton.isHidden                   = true
        durationStack.isHidden                  = false
    }
    
    
    
    func createDurationStack() -> UIStackView {
        durationStack                   = UIStackView.init(arrangedSubviews: labelArray)
        durationStack.alignment         = .center
        durationStack.distribution      = .fillEqually
        durationStack.axis              = .vertical
        durationStack.spacing           = 0
        durationStack.isHidden          = true
        
        return durationStack
    }
    
    func createDurationLabels() {
        let hourMinuteLabel = UILabel()
        hourMinuteLabel.text            = "00:00"
        hourMinuteLabel.font            = UIFont(name: "Helvetica", size: 36)
        
        let secondLabel = UILabel()
        secondLabel.text                = "00"
        secondLabel.font                = UIFont(name: "Helvetica", size: 24)
        secondLabel.alpha               = 0.8
        
        labelArray.append(hourMinuteLabel)
        labelArray.append(secondLabel)
        
        for label in labelArray {
            label.textColor       = K.BrandColors.uParkerBlue
            label.textAlignment   = .center
        }
    }
    
    
    
    
// ~~~~~~~~~ Set Constraints ~~~~~~~~~~~~~~//
    
    func setDurationStackConstraints() {
        durationStack.translatesAutoresizingMaskIntoConstraints                                     = false
        durationStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 70).isActive           = true
        durationStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive     = true
        durationStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive   = true
        durationStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    func setArriveButtonConstraints() {
        arriveButton.translatesAutoresizingMaskIntoConstraints                                     = false
        arriveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive           = true
        arriveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive     = true
        arriveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive   = true
        arriveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
}
