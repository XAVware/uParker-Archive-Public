//
//  LocationManager.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/19/23.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit
import MapboxSearch

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation = CLLocation(latitude: 40.7934, longitude: -77.8600)
    @Published var region = MKCoordinateRegion()
    @Published var suggestionList: [SearchSuggestion] = []
    @Published var lastSelectedSuggestion: SimpleSuggestion?
    
    private let locationManager = CLLocationManager()
    
    let searchEngine = SearchEngine()
    var searchText: String = ""
    
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        searchEngine.delegate = self
    }
    
    //May not need
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        //5000 is a little over 3 miles
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
}

extension LocationManager: SearchEngineDelegate {
    func selectSuggestion(_ suggestion: SearchSuggestion, completion: @escaping (SimpleSuggestion?) -> Void) {
        searchEngine.select(suggestion: suggestion)
        
        DispatchQueue.main.async {
            guard self.lastSelectedSuggestion != nil else {return}
            completion(self.lastSelectedSuggestion)
        }
    }
    
    @objc func updateQuery(text: String) {
        searchEngine.query = text
    }

    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
        self.suggestionList = suggestions
    }
     
    // MARK: - SEARCH ENGINE DELEGATE METHODS
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        dumpSuggestions(suggestions, query: searchEngine.query)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        lastSelectedSuggestion = SimpleSuggestion(name: result.name, address: result.address, coordinate: result.coordinate, categories: result.categories)
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        print("Error during search: \(searchError)")
    }
}
