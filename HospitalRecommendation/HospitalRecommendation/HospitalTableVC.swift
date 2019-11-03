//
//  HospitalTableVC.swift
//  HospitalRecommendation
//
//  Created by xxx on 2019/11/2.
//  Copyright © 2019 Szmbbq. All rights reserved.
//

import UIKit
import CoreLocation

class HospitalTableVC: UITableViewController {
    
    // MARK: - properties
    var hospitals: [NSDictionary]!
    var userLocation: CLLocation!
    var hospitalSelected: NSDictionary!
    var searchSpan: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HospitalViewCell.self, forCellReuseIdentifier: "HospitalCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Handlers
    func calculateDistance(currLoation: CLLocation, destination: CLLocation) -> Double {
        return destination.distance(from: currLoation) / 1609
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.hospitals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath) as! HospitalViewCell
        // Configure the cell...
        let hospital: NSDictionary = self.hospitals[indexPath.row]
        cell.hospitalName?.text = hospital.object(forKey: "hospital_name") as! String
        cell.hospitalName?.isEditable = false
        let hospitalCoordinate = (hospital.object(forKey: "location") as! NSDictionary).object(forKey: "coordinates") as! Array<Any>
        let hospitalDistance: Double = calculateDistance(currLoation: self.userLocation, destination: CLLocation(latitude: hospitalCoordinate[1] as! CLLocationDegrees, longitude: hospitalCoordinate[0] as! CLLocationDegrees))
        cell.hospitalDistance?.text = String(format: "%.2f", hospitalDistance) + (hospitalDistance > 1 ? " miles" : " mile")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hospitalSelected = self.hospitals[indexPath.row]
        performSegue(withIdentifier: "showDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVC" {
            print("to detail vc")
            let vc = segue.destination as! HospitalDetailVC
            vc.hospital = self.hospitalSelected
            vc.userLocation = self.userLocation
            vc.distanceSpan = self.searchSpan
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
