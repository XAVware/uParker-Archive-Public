//
//  DirectionsVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/19/20.
//

import UIKit
import MapboxMaps
//import MapboxCoreNavigation
//import MapboxNavigation
//import MapboxDirections
import CoreLocation

class DirectionsVC: UIViewController {
    
    /*
    var mapView: NavigationMapView!
    var routeOptions: NavigationRouteOptions?
    var route: Route?
    let locationManager = CLLocationManager()
    let destinationCoordinate = CLLocationCoordinate2D(latitude: 41.015072, longitude: -74.681396)
    var currentLat: CLLocationDegrees?
    var currentLon: CLLocationDegrees?
    var startTripButton: RoundButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeStartTripButton()
        requestUserLocation()
        
    }
    
    
    func requestUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            DispatchQueue.global(qos: .background).async {
                let location = self.getCurrentLocation()
                DispatchQueue.main.async {
                    self.initializeMap(userLocation: location)
                    self.mapView.showsUserLocation = true
                }
            }
            
        } else {
            print("Location Services not enabled")
        }
    }
    
    
    
    
    //MARK: - StartTripButton Functionality
    
    func initializeStartTripButton() {
        view.backgroundColor = .white
        
        startTripButton = RoundButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        guard let safeButton = startTripButton else {
            print("Button not initialized")
            return
        }

        safeButton.setTitle("Start Trip", for: .normal)
        safeButton.backgroundColor = K.BrandColors.uParkerBlue
        safeButton.titleLabel?.textColor = .white
        safeButton.layer.borderColor = K.BrandColors.uParkerBlue.cgColor
        safeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 24)
        safeButton.addTarget(self, action: #selector(startTrip), for: .touchUpInside)
        safeButton.isEnabled = false
        
        
        view.addSubview(safeButton)
        safeButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive     = true
        safeButton.translatesAutoresizingMaskIntoConstraints                                           = false
        safeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive                  = true
        safeButton.heightAnchor.constraint(equalToConstant: 50).isActive                               = true
        safeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                      = true
        
        
        self.showSpinner()
    }
    
    @objc func startTrip(sender: UIButton!) {
        let navigationVC = NavigationViewController(for: route!, routeOptions: routeOptions!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        if let userLocation: CLLocation = locationManager.location {
            let userLat = userLocation.coordinate.latitude
            let userLon = userLocation.coordinate.longitude
            let currentLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
            return currentLocation
        } else {
            print("Could not get current location")
            return CLLocationCoordinate2D(latitude: -20, longitude: 90)
        }
    }
    
    
    
    
    
    
    func initializeMap(userLocation: CLLocationCoordinate2D) {
        mapView = NavigationMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.setCenter(destinationCoordinate, zoomLevel: 11, animated: false)
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = destinationCoordinate
        annotation.title = "Destination"
        mapView.addAnnotation(annotation)
        
        calculateRoute(from: userLocation, to: destinationCoordinate) { (route, error) in
            if error != nil {
                print("Error getting route")
            }
        }
        
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func calculateRoute(from originCoor: CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> Void) {
        
        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
        
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                
                strongSelf.route = route
                strongSelf.routeOptions = routeOptions
                
                strongSelf.drawRoute(route: route)
                
                strongSelf.mapView.showWaypoints(on: route)
                
                let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
                let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
                let routeCam = strongSelf.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
                strongSelf.mapView.setCamera(routeCam, animated: false)
                
                if let annotation = strongSelf.mapView.annotations?.first as? MGLPointAnnotation {
                    annotation.title = "Destination"
                    strongSelf.mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
                }
                
                DispatchQueue.main.async {
                    strongSelf.startTripButton!.isEnabled = true
                    strongSelf.removeSpinner()
                }
            }
        }
    }
    
    
    
    
    
    
    func drawRoute(route: Route) {
        guard let routeShape = route.shape, routeShape.coordinates.count > 0 else { return }
        var routeCoordinates = routeShape.coordinates
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: UInt(routeCoordinates.count))
        
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
}



//MARK: - CLLocationManagerDelegate
extension DirectionsVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLat = location.coordinate.latitude
            currentLon = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - MGLMapViewDelegate
extension DirectionsVC: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
     
     */
}

