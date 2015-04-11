//
//  SignUpViewController.swift
//  JobSearch
//
//  Created by Carl Chen on 3/7/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//
import CoreLocation
import UIKit

class AddViewController: UITableViewController,UITextFieldDelegate , CLLocationManagerDelegate{
    @IBAction func cencel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var socket = SIOSocket()
    var jobTitle = UITextField()
    var jobDescription = UITextField()
    var remarks = UITextField()
    var duration = UITextField()
    var pay = UITextField()
    var skills = UITextField()
    var location:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 245, green: 146, blue: 108, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)

        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse{
            locationManager.requestWhenInUseAuthorization()
        } else {
            
            locationManager.startUpdatingLocation()
            
            
        }
        self.title = "Add Job"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 6
        } else {
            return 1
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
            switch indexPath.row {
            case 0:
                cell.label1?.text = "Job Title"
                self.jobTitle = cell.textField1
            case 1:
                cell.label1.text = "Description"
                self.jobDescription = cell.textField1
            case 2:
                cell.label1.text = "Pay per hour"
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                    cell.textField1.keyboardType = UIKeyboardType.DecimalPad
                }
                self.pay = cell.textField1
            case 3:
                cell.label1.text = "Skills"
                self.skills = cell.textField1
            case 4:
                cell.label1.text = "Duration"
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                    cell.textField1.keyboardType = UIKeyboardType.PhonePad
                }
                self.duration = cell.textField1
            case 5:
                cell.label1.text = "Remark"
                self.remarks = cell.textField1
            default:
                break
            }
            cell.textField1.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("submit", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1  && indexPath.row == 0{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            ServerConst.sharedInstance.post(self.skills.text, location: self.location, jobTitle: self.jobTitle.text, jobDescription: self.jobDescription.text, remarks: self.remarks.text, pay: self.pay.text, duration: self.duration.text){(responseObject:Bool?, error:String?) in
                if responseObject!{
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    if error == "user Name incorrect"{
                        let alert = UIAlertView(title: "Incorrect email or password", message: "Incorrect email or password, please check your input", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    } else if error == "location not found"{
                        let error = UIAlertView(title: "No location Found", message: "Please enable your location in privacy settings", delegate: self, cancelButtonTitle: "OK")
                        error.show()
                    }
                }
            }
            
        } else {
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let currentLocation = locations {
            let thisLocation : CLLocation = currentLocation[0] as! CLLocation
            location = thisLocation.coordinate
        }
    }

    
}
