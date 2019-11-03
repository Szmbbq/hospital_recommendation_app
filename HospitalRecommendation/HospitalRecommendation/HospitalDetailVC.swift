//
//  HospitalDetailVC.swift
//  HospitalRecommendation
//
//  Created by xxx on 2019/11/3.
//  Copyright © 2019 Szmbbq. All rights reserved.
//

import UIKit
import MapKit

class HospitalDetailVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailTextView: UITextView!
    var hospital: NSDictionary!
    var userLocation: CLLocation!
    var hospitalLocation: CLLocation!
    var locationManager: CLLocationManager?
    var distanceSpan: Double!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLoationManager()
        addHospitalPin()
        showRoute()
        showHospitalInfo()
        print(hospital)
    }
    
    // MARK: - Handlers
    
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 3.5
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mapView = self.mapView {
            self.userLocation = locations.last!
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
    func addHospitalPin() {
        // get hosptital coordinate
        let hospitalCoordinate = (hospital.object(forKey: "location") as! NSDictionary).object(forKey: "coordinates") as! Array<Any>
        self.hospitalLocation = CLLocation(latitude: hospitalCoordinate[1] as! CLLocationDegrees, longitude: hospitalCoordinate[0] as! CLLocationDegrees)
        let locationCoordinate = self.hospitalLocation.coordinate
        let addrAnnotation = MKPointAnnotation()
        addrAnnotation.title = hospital.object(forKey: "hospital_name") as! String
        addrAnnotation.coordinate = locationCoordinate
        self.mapView.addAnnotation(addrAnnotation)
    }
    
    func showRoute() {
        // show route
        let userPlaceMark = MKPlacemark(coordinate: self.userLocation.coordinate)
        let hospitalPlaceMark = MKPlacemark(coordinate: self.hospitalLocation.coordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: userPlaceMark)
        directionRequest.destination = MKMapItem(placemark: hospitalPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionRes = response else {
                if let error = error {
                    print("Error happened. \(error)")
                }
                return
            }
            let route = directionRes.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        self.mapView.delegate = self
    }
    
    func showHospitalInfo() {
        var infoStr: String = ""
        infoStr += "Facility Name: \(self.hospital.object(forKey: "hospital_name") as! String) \n"
        infoStr += "Address: \(self.hospital.object(forKey: "address") as! String), \(self.hospital.object(forKey: "city") as! String)\n"
        infoStr += "Overall Performance Rating: \(self.hospital.object(forKey: "overall_rating_of_hospital_performance_rate") as! String)"
        self.detailTextView.text = infoStr
        self.detailTextView.isEditable = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
