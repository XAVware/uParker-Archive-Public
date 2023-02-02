//
//  MapViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

// MARK: - VIEW WRAPPER
struct MapViewWrapper: UIViewControllerRepresentable {
    @Binding var center: CLLocation
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext< MapViewWrapper >) -> MapViewController {
        return MapViewController(center: center)
    }
    
    func updateUIViewController(_ mapViewController: MapViewController, context: UIViewControllerRepresentableContext< MapViewWrapper >) {
        mapViewController.centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
    }
}

// MARK: - ANNOTATION MODEL
struct PinModel {
    let id: String
    let coordinate: Point
    let price: Double
}

// MARK: - CUSTOM PROTOCOL
public protocol PinViewInteractionDelegate: AnyObject {
    func didSelectPin(_ pin: PinView)
}

// MARK: - ANNOTATION VIEW
public class PinView: UIView {
    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 26)
    var isSelected: Bool = false
    weak var delegate: PinViewInteractionDelegate?
    let data: PinModel
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: annotationFrame)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func getFormattedPrice(price: Double) -> NSMutableAttributedString {
        //Returns a String that has a small & offset dollar sign, a small space to act as padding between the dollar sign and the price, and the price in bold which automatically adjusts its font size based on the length of the price. With a frame that is 60 wide and 26 tall, the price label touches the edges if the price has 3 digits before the decimal.
        let dollarSignFont: UIFont = UIFont.systemFont(ofSize: 10)
        let spaceFont: UIFont = UIFont.systemFont(ofSize: 6)
        let priceFont: UIFont = UIFont.boldSystemFont(ofSize: price < 100.0 ? 14 : 12)
        
        let labelText = "$ \(String(format: "%.2f", price))"
        
        let attString = NSMutableAttributedString(string: labelText)
        attString.addAttribute(.font, value: dollarSignFont, range: NSRange(location: 0, length: 1))
        attString.addAttribute(.font, value: spaceFont, range: NSRange(location: 1, length: 1))
        attString.addAttribute(.font, value: priceFont, range: NSRange(location: 2, length: labelText.count - 2))
        attString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: 1))
        
        return attString
    }
    
    func initializeBackground() {
        self.backgroundColor = UIColor(named: "uParkerBlue")!
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = annotationFrame.height / 2
        self.layer.borderColor = UIColor(named: "uParkerBlue")!.cgColor
        self.layer.borderWidth = 1
    }
    
    init(pin: PinModel) {
        data = pin
        super.init(frame: annotationFrame)
        initializeBackground()
        
        priceLabel.attributedText = getFormattedPrice(price: data.price)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        self.addSubview(priceLabel)
        
    }
    
    func updateUI() {
        self.backgroundColor = isSelected ? UIColor.white : UIColor(named: "uParkerBlue")!
        self.priceLabel.textColor = isSelected ? UIColor(named: "uParkerBlue")! : UIColor.white
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard delegate != nil else {
            print("No PinView Delegate Found")
            return
        }
        
        self.delegate?.didSelectPin(self)
        
        self.isSelected.toggle()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - CONTROLLER
public class MapViewController: UIViewController, PinViewInteractionDelegate {
    public func didSelectPin(_ pin: PinView) {
        if let previousPin = self.selectedPin {
            previousPin.isSelected = false
            previousPin.updateUI()
        }
        
        self.selectedPin = pin
        let newCenter = CLLocation(latitude: pin.data.coordinate.coordinates.latitude, longitude: pin.data.coordinate.coordinates.longitude)
        LocationManager.shared.setCenter(newLocation: newCenter)
        print("Selected pin: \(pin.data)")
    }
    
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    var selectedPin: PinView?
    
    let markers: [PinModel] = [PinModel(id: "Spot_ID", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)), price: 3.00),
                                      PinModel(id: "Spot_ID2", coordinate: Point(CLLocationCoordinate2D(latitude: 40.7820, longitude: -77.8505)), price: 40.00)]
    
    var cameraOptions: CameraOptions {
        return CameraOptions(center: centerLocation, zoom: 12, bearing: -17.6, pitch: 0)
    }
    
    var centerLocation: CLLocationCoordinate2D {
        didSet { mapView.camera.fly(to: cameraOptions, duration: 1) }
    }
    
    //    lazy var pointAnnotationManager: PointAnnotationManager = {
    //        print("AnnotationManager Initialized")
    //        let annotationManager: PointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()
    //        annotationManager.delegate = self
    //        annotationManager.syncSourceAndLayerIfNeeded()
    //        return annotationManager
    //    }()
    
    //    private func getBackground(isSelected: Bool, price: Double) -> UIImage {
    //        return SpotAnnotationView(isSelected: isSelected, price: price).asImage()
    //    }
    
    
    
    // MARK: - INITIALIZER
    init(center: CLLocation) {
        centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        super.init(nibName: nil, bundle: nil)
        print("MapViewController Initialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //Map must initialize first - pointAnnotationManagerRequires it
        initializeMap()
        
        self.markers.forEach { marker in
            let options = ViewAnnotationOptions(
                geometry: marker.coordinate,
                allowOverlap: true,
                visible: true,
                anchor: .bottom,
                offsetY: 0)
            
            let pin = PinView(pin: marker)
            pin.delegate = self
            try? mapView.viewAnnotations.add(pin, options: options)
        }
        //        updateAnnotations()
    }
    
    //    private func updateAnnotations() {
    //        var pointAnnotation = PointAnnotation(id: "Spot_ID", coordinate: CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600))
    //        pointAnnotation.image = .init(image: getBackground(isSelected: false, price: 400.00), name: pointAnnotation.id)
    //
    //        var pointAnnotation2 = PointAnnotation(id: "Spot_ID2", coordinate: CLLocationCoordinate2D(latitude: 40.7820, longitude: -77.8505))
    //        pointAnnotation2.image = .init(image: getBackground(isSelected: false, price: 30.00), name: pointAnnotation2.id)
    //
    //
    //        // Add the annotation to the manager in order to render it on the map.
    //        pointAnnotationManager.annotations = [pointAnnotation, pointAnnotation2]
    //    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
    }
    
}



// MARK: - ANNOTATION INTERACTION DELEGATE
//extension MapViewController: AnnotationInteractionDelegate {
//
//    public func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
//        guard let tappedAnnotation = annotations.first as? PointAnnotation else {
//            print("Issue casting selected annotation to PointAnnotation")
//            return
//        }
//
//
//        self.selectedAnnotation = tappedAnnotation
//
//
//        let tappedCoordinate = CLLocation(latitude: tappedAnnotation.point.coordinates.latitude, longitude: tappedAnnotation.point.coordinates.longitude)
//        LocationManager.shared.setCenter(newLocation: tappedCoordinate)
//
//        DispatchQueue.main.async {
//            if let index = self.pointAnnotationManager.annotations.firstIndex(where: { $0.id == tappedAnnotation.id }) {
//                var annotation = self.pointAnnotationManager.annotations[index]
//                annotation.image = .init(image: self.getBackground(isSelected: tappedAnnotation.isSelected, price: 3.00), name: "\(tappedAnnotation.id)_\(tappedAnnotation.isSelected)")
//                self.pointAnnotationManager.annotations[index] = annotation
//            }
//        }
//        print("Annotation Tapped: \(annotations[0])")
//
//    }
//}
//
//class SpotAnnotationView: UIView {
//    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 26)
//    let selected: Bool
//
//    lazy var priceLabel: UILabel = {
//        let label = UILabel(frame: annotationFrame)
//        label.textColor = self.selected ? UIColor(named: "uParkerBlue")! : UIColor.white
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//
//    func getFormattedPrice(price: Double) -> NSMutableAttributedString {
//        //Returns a String that has a small & offset dollar sign, a small space to act as padding between the dollar sign and the price, and the price in bold which automatically adjusts its font size based on the length of the price. With a frame that is 60 wide and 26 tall, the price label touches the edges if the price has 3 digits before the decimal.
//        let dollarSignFont: UIFont = UIFont.systemFont(ofSize: 10)
//        let spaceFont: UIFont = UIFont.systemFont(ofSize: 6)
//        let priceFont: UIFont = UIFont.boldSystemFont(ofSize: price < 100.0 ? 14 : 12)
//
//        let labelText = "$ \(String(format: "%.2f", price))"
//
//        let attString = NSMutableAttributedString(string: labelText)
//        attString.addAttribute(.font, value: dollarSignFont, range: NSRange(location: 0, length: 1))
//        attString.addAttribute(.font, value: spaceFont, range: NSRange(location: 1, length: 1))
//        attString.addAttribute(.font, value: priceFont, range: NSRange(location: 2, length: labelText.count - 2))
//        attString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: 1))
//
//        return attString
//    }
//
//    func initializeBackground() {
//        self.backgroundColor = selected ? UIColor.white : UIColor(named: "uParkerBlue")!
//
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = annotationFrame.height / 2
//        self.layer.borderColor = UIColor(named: "uParkerBlue")!.cgColor
//        self.layer.borderWidth = 1
//    }
//
//    init(isSelected: Bool, price: Double) {
//        selected = isSelected
//        super.init(frame: annotationFrame)
//
//        initializeBackground()
//
//        priceLabel.attributedText = getFormattedPrice(price: price)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.addGestureRecognizer(tap)
//
//        self.addSubview(priceLabel)
//
//    }
//
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        print("Tapped")
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
