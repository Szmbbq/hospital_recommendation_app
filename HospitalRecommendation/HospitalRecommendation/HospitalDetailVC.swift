//
//  HospitalDetailVC.swift
//  HospitalRecommendation
//
//  Created by xxx on 2019/11/3.
//  Copyright © 2019 Szmbbq. All rights reserved.
//

import UIKit
import MapKit

class HospitalDetailVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailTextView: UITextView!
    var hospital: NSDictionary!
    var userLocation: CLLocation!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Handlers
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
