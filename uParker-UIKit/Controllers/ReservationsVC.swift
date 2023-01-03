//
//  ReservationsVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/14/20.
//

import UIKit
import CoreLocation
import MapboxGeocoder

class ReservationsVC: UIViewController {
    @Global var currentUser: User
    var locationManager: CLLocationManager?
    
    let reservation: Reservation = Reservation(streetAddress: "244 Alpine Trail", city: "Sparta", state: "New Jersey", zipCode: 07871)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForUpdates()
    }
    
    @IBAction func directionsPressed(_ sender: UIButton) {
        locationManager = CLLocationManager()
        if let manager = locationManager {
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        displayActionSheet()
    }
    
    func displayActionSheet() {
        let alert = UIAlertController(title: "Are you sure you want to cancel your reservation?", message: "Cancellation may result in penalties or fines. Please see our cancellation policy for more information.", preferredStyle: .actionSheet)
        
        let seeCancellationPolicy = UIAlertAction(title: "Cancellation Policy", style: .default) { (action) in
            //Open Cancellation Policy in Safari
            //Can I indicate that the button will
        }
        
        let cancelReservationAction = UIAlertAction(title: "Cancel Reservation", style: .destructive) { (action) in
            //What should button do
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(seeCancellationPolicy)
        alert.addAction(cancelReservationAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - CLLocationManagerDelegate
extension ReservationsVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            currentLat = location.coordinate.latitude
//            currentLon = location.coordinate.longitude
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            let geocoder = Geocoder.shared
            let options = ForwardGeocodeOptions(query: "244 Alpine Trail, Sparta NJ, 07871")
//            options.allowedISOCountryCodes ["NJ"]
            let task = geocoder.geocode(options) { (placemarks, attribution, error) in
                
                guard let placemark = placemarks?.first else {
                    print("error")
                    return
                }
                let reservationCoordinate = placemark.location?.coordinate
                let lat = reservationCoordinate?.latitude
                let lon = reservationCoordinate?.longitude
                
            }
            task.resume()
            let directionsVC = DirectionsVC()
            self.navigationController!.pushViewController(directionsVC, animated: false)
        }
    }
}

//MARK: - GlobalUpdating
extension ReservationsVC: GlobalUpdating {
    func update() { }
}
