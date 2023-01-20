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
    
    let pinView = UIHostingController(rootView: PinView())
    
    
    // MARK: - INITIALIZER
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
        addPins()
    }
    
    private func addPins() {
        geocoder.setFocalArea(pennStateCoordinates)
        geocoder.getCoordinates(forAddress: "100 East Beaver Ave, State College, PA") { result in
            guard result != nil else {
                print("Result is empty")
                return
            }
            
            self.addViewAnnotation(at: result!)
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
    
//    private func createSampleView(withText text: String) -> UIView {
//        let backgroundFrame = CGRect(x: 0, y: 0, width: 100, height: 40) // Size while selected
//
//        let backgroundView: UIView = UIView()
//        let priceLabel: UILabel = UILabel()
//
//        let unselectedBackgroundColor: UIColor = UIColor(named: "uParkerBlue")!
//
//        backgroundView.frame = backgroundFrame
//        backgroundView.backgroundColor = unselectedBackgroundColor
//        backgroundView.layer.cornerRadius = backgroundFrame.height / 2
//
//        backgroundView.layer.shadowRadius = 2
//        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        backgroundView.layer.shadowOpacity = 0.3
//
//        priceLabel.frame = backgroundFrame
//        priceLabel.textColor = .white
//        priceLabel.text = "$ \(text)"
//        priceLabel.textAlignment = .center
//        priceLabel.adjustsFontSizeToFitWidth = true
//
//        backgroundView.addSubview(priceLabel)
//
//        return backgroundView
//    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 100,
            height: 40,
            allowOverlap: false
//            allowOverlap: false,
//            anchor: .center
        )
        
        
        let frame = CGRect(x: 0, y: 0, width: 70, height: 20)
        
        
        let pinView: UIView = UIView(frame: frame)
        pinView.backgroundColor = UIColor(named: "uParkerBlue")!
        pinView.layer.cornerRadius = frame.height
        pinView.layer.shadowRadius = 2
        pinView.layer.shadowOffset = CGSize(width: 0, height: 1)
        pinView.layer.shadowOpacity = 0.3
        
        let priceLabel: UILabel = UILabel(frame: frame)
        priceLabel.textColor = .white
        priceLabel.text = "$3.00/Day"
        priceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        priceLabel.textAlignment = .center
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.backgroundColor = UIColor(.red)
//        priceLabel.cornerRadius = frame.height
        priceLabel.backgroundColor = UIColor(named: "uParkerBlue")!
        priceLabel.layer.shadowRadius = 2
        priceLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        priceLabel.layer.shadowOpacity = 0.3
        
//        pinView.addSubview(priceLabel)

        try? mapView.viewAnnotations.add(pinView, options: options)
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

struct PinView: View {
        var body: some View {
            Text("$3.00")
                .font(.caption)
                .foregroundColor(.white)
                .background(backgroundGradient)
                .padding()
                .clipShape(Capsule())
        }
}
