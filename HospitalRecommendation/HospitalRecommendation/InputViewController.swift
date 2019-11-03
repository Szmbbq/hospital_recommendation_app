//
//  ViewController.swift
//  HospitalRecommendation
//
//  Created by xxx on 2019/11/2.
//  Copyright © 2019 Szmbbq. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InputViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var searchSpanField: UITextField!
    
    var locationManager: CLLocationManager?
    var distanceSpan: Double = 1000
    var currentLocation: CLLocation!
    var searchSpan: Int!
    var hospitals: [NSDictionary] = []
    
    
    
    // MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addressField.backgroundColor = .lightText
        addressField.text = "Please enter your address"
        setUpLoationManager()
    }
    
    // MARK: - handlers
    
    // configure location manager
    
    func setUpLoationManager() {
        self.locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mapView = self.mapView {
            self.currentLocation = locations.last!
            let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }

    @IBAction func getLocation(_ sender: Any) {
        // get user address input
        guard let addressText = addressField.text, !addressText.isEmpty else {
            let alert  = UIAlertController(title: "Missing Input", message: "No user address input, use current location instead?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction) in
                // go back to current location
                self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: false)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // convert to location point
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressText) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                let alert = UIAlertController(title: "Current Position Unavailable", message: "Failed to get current location", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Use your location
            self.currentLocation = location
            let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let addrAnnotation = MKPointAnnotation()
            addrAnnotation.title = "Your Address"
            addrAnnotation.coordinate = locationCoordinate
            self.mapView.addAnnotation(addrAnnotation)
            self.mapView.setCenter(locationCoordinate, animated: false)
        }
    }
    
    @IBAction func getHospitals(_ sender: Any) {
        // get span distance
        let defaultSearchRange: Int = 40000
        self.searchSpan = self.searchSpanField.text != "" ? Int(searchSpanField.text!)! * 1000 : defaultSearchRange
        // get nearby hospitals
        let urlStr = "https://data.medicare.gov/resource/a7xq-q7qn.json?$where=within_circle(location,\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude),\(self.searchSpan!))"
        let url = URL(string: urlStr)!
        let httqReq = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let hospitals = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]]
                self.hospitals = hospitals as [NSDictionary]
                DispatchQueue.main.async {
                    // perform segue
                    self.performSegue(withIdentifier: "showHospitalVC", sender: self)
                }
            } catch let error {
                print("JSON parse error: \(error)")
            }
        }
        httqReq.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHospitalVC" {
            print("to hospital vc")
            let vc = segue.destination as! HospitalTableVC
            vc.hospitals = self.hospitals
            vc.userLocation = self.currentLocation
            vc.searchSpan = Double(self.searchSpan)
        }
    }
}

