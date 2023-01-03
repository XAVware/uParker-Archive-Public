//
//  MapVC.swift
//  uParkerV2
//
//  Created by Ryan Smetana on 10/22/20.
//

import UIKit
import CoreLocation
import MapboxMaps
import SideMenu

class MapVC: UIViewController {
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var spotCardCollection: SpotCardCollectionView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var toggleListButton: UIButton!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var homeButton: RoundButton!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var filterButton: RoundButton!
    @IBOutlet weak var listCollectionView: UIView!
    
//    var mapView: MGLMapView = MGLMapView()
    internal var mapView: MapView!

    let locationManager = CLLocationManager()
    
    var searchVC: SearchVC?
    
    var listHeight: CGFloat!
    
    let stateCollegeCoor = CLLocationCoordinate2D(latitude: 40.7934, longitude: -77.8600)
    let spotList: [Spot] = [Spot(streetAdress: "120 E Park Ave, State College Pennsylvania, 16801", title: "Tom's Driveway", price: "15.00", rating: "4.75"),
                            Spot(streetAdress: "25 Holmes Street, State College Pennsylvania, 16801", title: "Rachel's Driveway", price: "14.00", rating: "5.00"),
                            Spot(streetAdress: "12 Bellaire Ave, State College Pennsylvania, 16801", title: "Paul's Driveway", price: "8.00", rating: "4.75"),
                            Spot(streetAdress: "25 West Fairmount Ave, State College Pennsylvania, 16801", title: "Megan's Driveway", price: "14.00", rating: "4.75")]
    
//    var pointAnnotations = [MGLPointAnnotation]()
    var pointAnnotations = [PointAnnotation]()

    
    private var filtersMenu: SideMenuNavigationController?
    
    var listCollection: SpotListCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: "your_public_access_token")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        self.view.addSubview(mapView)
//        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        initializeMap()
        initializeSearchBar()
        initializeSpotCollection()
        initializeListView()
        initializeFilterMenu()
    }
    
    func initializeFilterMenu() {
        let menu = storyboard!.instantiateViewController(identifier: "filtersMenu") as! FiltersTVC
        
        filtersMenu = SideMenuNavigationController(rootViewController: menu)
        filtersMenu?.menuWidth = UIScreen.main.bounds.width * 0.85
        filtersMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.rightMenuNavigationController = filtersMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        present(filtersMenu!, animated: true, completion: nil)
    }
    
    @IBAction func toggleListPressed(_ sender: UIButton) {
        
        if listView.transform == .identity {
            mapView.isUserInteractionEnabled = false
            homeButton.clipsToBounds = true
            filterButton.clipsToBounds = true
            listLabel.text = "Map View"
            listIcon.image = UIImage(systemName: "map")
            self.listCollection = SpotListCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: .init())
            self.listCollection!.configure(with: self.spotList, parent: self)
            self.listCollectionView.addSubview(self.listCollection!)
            self.listCollection!.pin(to: self.listCollectionView)
            UIView.animate(withDuration: 0.3) {
                self.listView.transform = CGAffineTransform(translationX: 0, y: -(self.listView.frame.minY) + self.view.safeAreaInsets.top - 10)
                self.toggleListButton.transform = CGAffineTransform(rotationAngle: 3.14)
            } completion: { (finished) in
                
            }
        } else {
            mapView.isUserInteractionEnabled = true
            homeButton.clipsToBounds = false
            filterButton.clipsToBounds = false
            listLabel.text = "List View"
            listIcon.image = UIImage(systemName: "list.bullet")
            UIView.animate(withDuration: 0.3) {
                self.listView.transform = .identity
                self.toggleListButton.transform = .identity
            } completion: { (finished) in
                self.listCollection!.removeFromSuperview()
                self.listCollection = nil
            }
        }
        

    }
    
    func selectSpotAnnotation(spotIndex: Int) {
//        mapView.selectAnnotation(pointAnnotations[spotIndex], animated: true, completionHandler: nil)
    }
    
    func initializeListView() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topSafeAreaHeight = safeFrame.minY
        listHeight = UIScreen.main.bounds.height - topSafeAreaHeight + 10
        listView.layer.cornerRadius = 20
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.heightAnchor.constraint(equalToConstant: listHeight).isActive = true
    }
    
    func initializeSpotCollection() {
        spotCardCollection.configure(with: spotList)
        spotCardCollection.parentViewController = self
    }
    
    func openSpot() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "spotView") as! SpotVC
        
        let navController = UINavigationController(rootViewController: VC1)
        navController.setUpNavBar(navController, isTextWhite: false, isHidden: true)
        self.present(navController, animated:true, completion: nil)
    }
    
    func initializeSearchBar() {
        let lineColor = UIColor(white: 0.6, alpha: 0.6)
        searchBarView.layer.cornerRadius = 15
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = lineColor.cgColor
        searchBarView.layer.shadowRadius = 10
        searchBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchBarView.layer.shadowOpacity = 0.3
        
        let middleLine = CALayer()
        middleLine.frame = CGRect(x: 5, y: searchBarView.bounds.height / 2, width: searchBarView.bounds.width - 10, height: 1.0)
        middleLine.backgroundColor = lineColor.cgColor
        searchBarView.layer.addSublayer(middleLine)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchBarTapped(_:)))
        searchBarView.addGestureRecognizer(tap)
    }
    
    @IBAction func homeTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func searchBarTapped(_ sender: UIButton) {
        searchVC = storyboard!.instantiateViewController(withIdentifier: "searchView") as? SearchVC
        guard searchVC != nil else {
            print("SearchVC not initialized")
            return
        }
        searchVC!.delegate = self
        searchVC!.initialBackgroundFrame = searchBarView.frame
        addChild(searchVC!)
        
        self.view.addSubview(searchVC!.view)
        searchVC!.didMove(toParent: self)
        searchVC!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchVC!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchVC!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchVC!.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchVC!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        searchVC!.openSearchView()
    }
    
    func cleanUp() {
        searchVC!.removeFromParent()
        searchVC = nil
    }
    
    
    func initializeMap() {
        let myResourceOptions = ResourceOptions(accessToken: "your_public_access_token")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        self.view.addSubview(mapView)
        
        /*
        spotList[0].coordinate = CLLocationCoordinate2D(latitude: 40.800370, longitude: -77.869320)
        spotList[1].coordinate = CLLocationCoordinate2D(latitude: 40.803870, longitude: -77.869640)
        spotList[2].coordinate = CLLocationCoordinate2D(latitude: 40.800430, longitude: -77.846370)
        spotList[3].coordinate = CLLocationCoordinate2D(latitude: 40.786260, longitude: -77.862680)
        
        DispatchQueue.global(qos: .background).async {
            
            for spot in self.spotList {
                let spotCoordinate = spot.coordinate!
                let point = PointAnnotation(coordinate: spotCoordinate)
//                point.title = String(spot.price)
                self.pointAnnotations.append(point)
                DispatchQueue.main.async {
//                    self.mapView.addAnnotations(self.pointAnnotations)
                    // Create the `PointAnnotationManager` which will be responsible for handling this annotation
                    let pointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()

                    // Add the annotation to the manager in order to render it on the map.
                    pointAnnotationManager.annotations = [point]
                }
            }
        }
        
        mapView.frame = view.bounds
//        mapView.styleURL = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.setCenter(stateCollegeCoor, animated: false)
//        mapView.setZoomLevel(12, animated: false)
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
         
         */
    }
   
}

/*

//MARK: - MGLMapViewDelegate
extension MapVC: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = SpotAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let currentZoomLevel = mapView.zoomLevel
        mapView.setCenter(annotation.coordinate, zoomLevel: currentZoomLevel, animated: true)
        for spot in spotList {
            if annotation.coordinate == spot.coordinate! {
                let selectedSpotIndex = spotList.firstIndex{$0 === spot}!
                self.spotCardCollection.scrollToItem(at: IndexPath(item: selectedSpotIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
*/
