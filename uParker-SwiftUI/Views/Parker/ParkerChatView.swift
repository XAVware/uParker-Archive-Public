//
//  ParkerChatView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/6/23.
//

import SwiftUI
import MapboxMaps
import CoreLocation

struct ParkerChatView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var locationManager = LocationManager.shared
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            
            if sessionManager.isLoggedIn == false {
                HeaderView(leftItem: nil, title: nil, rightItem: nil)
                NeedLoginView(title: "Chat", mainHeadline: "Login to view conversations", mainDetail: "Once you login, your message inbox will appear here.")
            } else {
                MapViewWrapper(center: $locationManager.location)
            }
            
            Spacer()
        } //: VStack
        .padding()
    }
}

// MARK: - PREVIEW
//struct ParkerChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ParkerChatView()
//            .environmentObject(SessionManager())
//    }
//}



public class MapViewController: UIViewController, AnnotationInteractionDelegate {
    public func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        print("Annotation Tapped: \(annotations[0])")
    }
    
    // MARK: - PROPERTIES
    internal var mapView: MapView!
        
    var centerLocation: CLLocationCoordinate2D {
        didSet { mapView.camera.fly(to: cameraOptions, duration: 1) }
    }
    
    let pennStateCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    
    var cameraOptions: CameraOptions {
        return CameraOptions(center: centerLocation, zoom: 12, bearing: -17.6, pitch: 0)
    }
    
    // MARK: - INITIALIZER
    init(center: CLLocation) {
        centerLocation = CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initializeMap()
    }
    
    private func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: MBAccessKey)
        
        // Pass camera options to map init options
        let options = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        
        
        // Initialize a point annotation with a geometry ("coordinate" in this case)
        var pointAnnotation = PointAnnotation(id: "Spot_ID", coordinate: pennStateCoordinates)


        // Make the annotation show a red pin
        pointAnnotation.image = .init(image: SpotAnnotationView().asImage(), name: "red_pin")
        pointAnnotation.textField = "$3.00"
        pointAnnotation.textAnchor = .center
        pointAnnotation.textColor = StyleColor(UIColor.white)
        pointAnnotation.iconAnchor = .bottom

        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.delegate = self

        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager.annotations = [pointAnnotation]
        
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            print("Called")
//            Seems to only call once. Maybe wait to add annotations until here?
//            self.finish()
        }
      
    }
    
}


class SpotAnnotationView: UIView {
    let annotationFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 25)
    
    init() {
        super.init(frame: annotationFrame)

        self.backgroundColor = UIColor(named: "uParkerBlue")!

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


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

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
