//
//  ViewController.swift
//  socket
//
//  Created by Gelei Chen on 15/2/24.
//  Copyright (c) 2015年 Gelei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JobViewController: UITableViewController,CLLocationManagerDelegate {
    
    
    
    let locationManager = CLLocationManager()
    var socket = SIOSocket()
    var jobArray:[Job] = []
    var currentJob:Job?
    var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse{
            
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 245, green: 146, blue: 108, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        
        SIOSocket.socketWithHost("http://nerved.herokuapp.com", response: { (socket:SIOSocket!) in
            self.socket = socket;
            self.socket.on("handshake", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                let dict = arg[0] as NSDictionary
                let uuid: AnyObject? = dict["uuid"]
                //self.navigationController?.navigationItem.title = uuid as String?
                
            })
            //self.socket.emit("queryall")
            let lati = self.location.latitude
            let long = self.location.longitude
            let geo = NSDictionary(objectsAndKeys: "Point", "type", [long,lati], "coordinates")
            let dict = NSDictionary(objectsAndKeys: 30000, "maxDist",geo,"location")
            //println(dict)
            self.socket.emit("geosearch", args: [dict])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                //println(arg.firstObject!)
                let dict = arg[0] as NSDictionary
                //println(dict)
                let data: NSArray = dict["data"] as NSArray//get data
                for entryDict in data{
                    println(entryDict)
                    
                    //location && coordinate
                    let location:NSDictionary = entryDict.objectForKey("location") as NSDictionary
                    let coordinate:NSArray = (location.objectForKey("coordinates") as NSArray)
                    let title:String = entryDict.objectForKey("title") as String
                    //title
                    let description:String = entryDict.objectForKey("description") as String
                    let salaryDouble:Double = entryDict.objectForKey("comp") as Double
                    let salary = "$" + salaryDouble.description
                    
                    let date = entryDict.objectForKey("date") as String
                    let expireDate = entryDict.objectForKey("expire") as String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    
                    let dateMid = dateFormatter.dateFromString(date)
                    let expireDateMid = dateFormatter.dateFromString(expireDate)
                    
                    let dateFormatter2 = NSDateFormatter()
                    dateFormatter2.dateFormat = "MMM dd"
                    let dateResult = dateFormatter2.stringFromDate(dateMid!)
                    let expireDateResult = dateFormatter2.stringFromDate(expireDateMid!)
                    
                    
                    let hay = entryDict.objectForKey("postid") as String
                    let endIndex = advance(hay.startIndex, 5)
                    let id = hay.substringToIndex(endIndex)
                    
                    let tags:NSArray = entryDict.objectForKey("tags") as NSArray
                    
                    let uuid = entryDict.objectForKey("uuid") as String
                    
                    
                    let job = Job(longitude: coordinate[0] as Double, latitude: coordinate[1] as Double,salary:salary,title:title,detail:description,date:dateResult,expireDate:expireDateResult,jobID:id,tags:tags,UUID:uuid,postID:hay)
                    self.jobArray.append(job)
                    
                }
                
                //self.location.append( as String)
                
                self.tableView.reloadData()
            })
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? JobTableViewCell
        let value = jobArray[indexPath.row]
        cell?.salary.text = value.salary
        cell?.salary.textColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        cell?.title.text = value.title
        cell?.postTime.text = "\(value.expireDate)"
        var tagResult = ""
        for tag in value.tags {
            tagResult += "#\(tag), "
        }
        cell?.tags.text = tagResult
        
        return cell!

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentJob = jobArray[indexPath.row]
        
        self.performSegueWithIdentifier("toJobDetail", sender: self)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMap" {
            let viewController = segue.destinationViewController as LocationViewController
            viewController.jobArray = self.jobArray
        } else if segue.identifier == "toJobDetail" {
            let viewController = segue.destinationViewController as JobDetailViewController
            viewController.currentJob = self.currentJob
            

        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let currentLocation = locations {
            let thisLocation : CLLocation = currentLocation[0] as CLLocation
            location = thisLocation.coordinate
        }
    }
}

