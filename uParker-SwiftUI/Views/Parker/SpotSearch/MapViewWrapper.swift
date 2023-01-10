//
//  MapViewWrapper.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/5/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation


public class MapViewController: UIViewController {
    // MARK: - PROPERTIES
    internal var mapView: MapView!
    
    var geocoder: MBGeocoder = MBGeocoder()
    
    let pennStateCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    
    
    // MARK: - INITIALIZER
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
        geocoder.setFocalArea(pennStateCoordinates)
        geocoder.getCoordinates(forAddress: "100 East Beaver Ave, State College, PA") { result in
            guard result != nil else {
                print("Result is empty")
                return
            }
            
//            self.addViewAnnotation(at: result!)
        }
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        let cameraOptions = CameraOptions(center: pennStateCoordinates, zoom: 12, bearing: -17.6, pitch: 0)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Pass options when initializing the map
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        
//        self.addViewAnnotation(at: pennStateCoordinates)
    }
    
    
    private func createSampleView(withText text: String) -> UIView {
        let backgroundFrame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let backgroundView: UIView = UIView()
        let priceLabel: UILabel = UILabel()
        
        let unselectedBackgroundColor: UIColor = UIColor(named: "uParkerBlue")!

        backgroundView.frame = backgroundFrame
        backgroundView.backgroundColor = unselectedBackgroundColor
        backgroundView.layer.cornerRadius = backgroundFrame.height / 2
    
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.3
        
        priceLabel.frame = backgroundFrame
        priceLabel.textColor = .white
        priceLabel.text = "$ \(text)"
        priceLabel.textAlignment = .center
        priceLabel.adjustsFontSizeToFitWidth = true
        
        backgroundView.addSubview(priceLabel)

        return backgroundView
    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 100,
            height: 40,
            allowOverlap: false,
            anchor: .center
        )
        let sampleView = createSampleView(withText: "Hello world!")
        try? mapView.viewAnnotations.add(sampleView, options: options)
    }
}

// MARK: - VIEW WRAPPER
//Use UIViewControllerRepresentable to display MapBox map in SwiftUI app.
struct MapViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}

/*
class SpotAnnotationView: MGLAnnotationView {
    let backgroundFrame                         = CGRect(x: 0, y: 0, width: 60, height: 25)
    
    let backgroundView: UIView                  = UIView()
    let priceLabel: UILabel                     = UILabel()
    let selectedView: UIView                    = UIView()
    
    let unselectedBackgroundColor: UIColor      = K.BrandColors.uParkerBlue
    let unselectedTextColor: UIColor            = .white
    let unselectedPriceFont: UIFont             = UIFont(name: "Helvetica", size: 14.0)!
    
    let selectedBackgroundColor: UIColor        = .white
    let selectedTextColor: UIColor              = K.BrandColors.uParkerBlue
    let selectedPriceFont: UIFont               = UIFont(name: "Helvetica", size: 15.0)!
    
    var price: String?
    
    override init(annotation: MGLAnnotation!, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        price = getPriceString(from: annotation.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.frame                             = backgroundFrame
        backgroundColor                         = UIColor.clear
        
        backgroundView.frame                    = backgroundFrame
        backgroundView.backgroundColor          = unselectedBackgroundColor
        backgroundView.layer.cornerRadius       = backgroundFrame.height / 2
        
        layer.shadowRadius                      = 2
        layer.shadowOffset                      = CGSize(width: 0, height: 1)
        layer.shadowOpacity                     = 0.3
        
        //Should add constraints to put space before and after the label -- Adding constraints seems to move the annotation to the top left corner of the mapview
        priceLabel.frame                        = backgroundFrame
        priceLabel.text                         = "$ \(price!)"
        priceLabel.textAlignment                = .center
        priceLabel.adjustsFontSizeToFitWidth    = true
        
        backgroundView.addSubview(priceLabel)
        addSubview(backgroundView)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundView.backgroundColor      = selectedBackgroundColor
            priceLabel.textColor                = selectedTextColor
            priceLabel.font                     = selectedPriceFont
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        } else {
            backgroundView.backgroundColor      = unselectedBackgroundColor
            priceLabel.textColor                = unselectedTextColor
            priceLabel.font                     = unselectedPriceFont
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
    func getPriceString(from annotationTitle: String??) -> String {
        if let titleString = annotationTitle, let priceString = titleString {
            return priceString
        } else {
            return "Default"
        }
    }
}

*/

