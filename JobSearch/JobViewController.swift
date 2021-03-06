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

class JobViewController: UITableViewController,CLLocationManagerDelegate,UISearchResultsUpdating {
    @IBAction func addJob(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token:String = defaults.valueForKey("token") as? String {
            self.performSegueWithIdentifier("showAdd", sender: self)
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }
    
    var localFilteredJobArray : [Job] = []
    var serverFilteredJobArray : [Job] = []
    let locationManager = CLLocationManager()
    var socket = SIOSocket()
    var jobArray:[Job] = []
    var currentJob:Job?
    var location:CLLocationCoordinate2D?
    var resultSeachController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        let bar = UIView(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, 1.0)
)
      bar.backgroundColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.addSubview(bar)
        self.navigationController?.navigationBar.translucent = true
        
       
        self.resultSeachController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            controller.searchBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
            controller.searchBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
            controller.searchBar.translucent = false
            //controller.hidesNavigationBarDuringPresentation = true
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "getDataFromServer", forControlEvents: UIControlEvents.ValueChanged)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"didAddjob:", name: "addedJob", object: nil)
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse{
            self.locationManager.requestWhenInUseAuthorization()
            
        } else {
            locationManager.startUpdatingLocation()
        }
        //let internetTest = NSURLConnection(request: NSURLRequest(URL: NSURL(string: "http://nerved.herokuapp.com")!), delegate: self, startImmediately: true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token:String = defaults.valueForKey("token") as? String {
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
            println("no token")
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 245, green: 146, blue: 108, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        
       self.tableView.reloadData()
    }
    
    func didAddjob(notification: NSNotification) {
        
        getDataFromServer()
        //self.tableView.reloadData()
    }
    
    
    
    func getDataFromServer() -> Void {
        SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket;
            self.socket.on("handshake", callback: { (args:[AnyObject]!)  in
                let arg = args as NSArray
                let dict = arg[0] as! NSDictionary
                let uuid: AnyObject? = dict["uuid"]
                //self.navigationController?.navigationItem.title = uuid as String?
                
            })
            //self.socket.emit("queryall")
            let lati = self.location!.latitude
            let long = self.location!.longitude
            let geo = NSDictionary(objectsAndKeys: "Point", "type", [long,lati], "coordinates")
            let dict = NSDictionary(objectsAndKeys: 3000, "maxDist",geo,"location")
            println(dict)
            self.socket.emit("geosearch", args: [dict])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                self.jobArray = []
                let arg = args as NSArray
                //println(arg.firstObject!)
                let dict = arg[0] as! NSDictionary
                //println(dict)
                let data: NSArray = dict["data"] as! NSArray//get data
                for entryDict in data{
                    //println(entryDict)
                    
                    //location && coordinate
                    let location:NSDictionary = entryDict.objectForKey("location") as! NSDictionary
                    let coordinate:NSArray = (location.objectForKey("coordinates") as! NSArray)
                    let title:String = entryDict.objectForKey("title") as! String
                    //title
                    let description:String = entryDict.objectForKey("description") as! String
                    let salaryDouble:String = entryDict.objectForKey("comp") as! String
                    let salary = "$" + salaryDouble
                    
                    let date = entryDict.objectForKey("date") as! String
                    let expireDate = entryDict.objectForKey("expire") as! String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    
                    let dateMid = dateFormatter.dateFromString(date)
                    let expireDateMid = dateFormatter.dateFromString(expireDate)
                    
                    let dateFormatter2 = NSDateFormatter()
                    dateFormatter2.dateFormat = "MMM dd"
                    let dateResult = dateFormatter2.stringFromDate(dateMid!)
                    let expireDateResult = dateFormatter2.stringFromDate(expireDateMid!)
                    
                    
                    let hay = entryDict.objectForKey("postid") as! String
                    let endIndex = advance(hay.startIndex, 5)
                    let id = hay.substringToIndex(endIndex)
                    
                    let tags:NSArray = entryDict.objectForKey("tags") as! NSArray
                    
                    
                    
                    let uuid = entryDict.objectForKey("uuid") as! String
                    
                    
                    let job = Job(longitude: coordinate[0] as! Double, latitude: coordinate[1] as! Double,salary:salary,title:title,detail:description,date:dateResult,expireDate:expireDateResult,jobID:id,tags:tags,UUID:uuid,postID:hay)
                    self.jobArray.append(job)
                    
                }
                
                self.tableView.reloadData()
                
                let formatter = NSDateFormatter()
                formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
                let title = ("Last update: " + formatter.stringFromDate(NSDate()))
                let attributedTitle = NSAttributedString(string: title)
                self.refreshControl?.attributedTitle = attributedTitle
                
                //println(NSDate())
                self.refreshControl?.endRefreshing()
                //self.location.append( as String)
                
                
            })
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.resultSeachController.active{
            return 2
        } else {
            return 1
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSeachController.active {
            if section == 0 {
                return self.localFilteredJobArray.count
            } else {
                return self.serverFilteredJobArray.count
            }
        } else {
            return self.jobArray.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? JobTableViewCell
        if self.resultSeachController.active {
            //searched
            if indexPath.section == 0{
                //local result
                let value = self.localFilteredJobArray[indexPath.row]
                cell?.salary.text = value.salary
                cell?.salary.textColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
                cell?.title.text = value.title
                cell?.postTime.text = "\(value.expireDate)"
                var tagResult = ""
                for tag in value.tags {
                    tagResult += "#\(tag), "
                }
                cell?.tags.text = tagResult
            } else {
                //server result
                let value = self.serverFilteredJobArray[indexPath.row]
                cell?.salary.text = value.salary
                cell?.salary.textColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
                cell?.title.text = value.title
                cell?.postTime.text = "\(value.expireDate)"
                var tagResult = ""
                for tag in value.tags {
                    tagResult += "#\(tag), "
                }
                cell?.tags.text = tagResult
            }
            
        } else {
            //not search
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
        }
        
        
        return cell!

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.resultSeachController.active {
            if section == 0 {
                if self.localFilteredJobArray.count != 0 {
                    return "The Quest Near you"
                }
                
            } else {
                if self.serverFilteredJobArray.count != 0 {
                    return "All the Quest"
                }
            }
        } else {
            return ""
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.resultSeachController.active{
            if indexPath.section == 0{
                //local
                currentJob = self.localFilteredJobArray[indexPath.row]
            } else {
                //server side
                currentJob = self.serverFilteredJobArray[indexPath.row]
            }
            self.performSegueWithIdentifier("toJobDetail", sender: self)
            self.resultSeachController.dismissViewControllerAnimated(false, completion: nil)
        } else {
            currentJob = self.jobArray[indexPath.row]
            self.performSegueWithIdentifier("toJobDetail", sender: self)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMap" {
            let viewController = segue.destinationViewController as! LocationViewController
            //viewController.hidesBottomBarWhenPushed = true
            viewController.jobArray = self.jobArray
            viewController.myLocation = self.location
            
        } else if segue.identifier == "toJobDetail" {
            let viewController = segue.destinationViewController as! JobDetailViewController
            //viewController.hidesBottomBarWhenPushed = true
            viewController.currentJob = self.currentJob
            
        }
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let currentLocation = locations {
            
            if location == nil {
                getDataFromServer()
                //self.tableView.reloadData()
            }
            let thisLocation : CLLocation = currentLocation[0] as! CLLocation
            location = thisLocation.coordinate
        }
    }
    
    func getSearchResultsFromServer(keyword:String){
        SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket;
            let dict = NSDictionary(objectsAndKeys: ["\(keyword)"], "keywords")
            self.socket.emit("searchbykey", args: [dict])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as NSArray
                let dict = arg[0] as! NSDictionary
                let data: NSArray = dict["data"] as! NSArray//get data
                for entryDict in data{
                    
                    //location && coordinate
                    let location:NSDictionary = entryDict.objectForKey("location") as! NSDictionary
                    let coordinate:NSArray = (location.objectForKey("coordinates") as! NSArray)
                    let title:String = entryDict.objectForKey("title") as! String
                    //title
                    let description:String = entryDict.objectForKey("description") as! String
                    let salaryDouble:String = entryDict.objectForKey("comp") as! String
                    let salary = "$" + salaryDouble
                    
                    let date = entryDict.objectForKey("date") as! String
                    let expireDate = entryDict.objectForKey("expire") as! String
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    
                    let dateMid = dateFormatter.dateFromString(date)
                    let expireDateMid = dateFormatter.dateFromString(expireDate)
                    
                    let dateFormatter2 = NSDateFormatter()
                    dateFormatter2.dateFormat = "MMM dd"
                    let dateResult = dateFormatter2.stringFromDate(dateMid!)
                    let expireDateResult = dateFormatter2.stringFromDate(expireDateMid!)
                    
                    
                    let hay = entryDict.objectForKey("postid") as! String
                    let endIndex = advance(hay.startIndex, 5)
                    let id = hay.substringToIndex(endIndex)
                    
                    let tags:NSArray = entryDict.objectForKey("tags") as! NSArray
                    
                    
                    
                    let uuid = entryDict.objectForKey("uuid") as! String
                    
                    
                    let job = Job(longitude: coordinate[0] as! Double, latitude: coordinate[1] as! Double,salary:salary,title:title,detail:description,date:dateResult,expireDate:expireDateResult,jobID:id,tags:tags,UUID:uuid,postID:hay)
                    self.serverFilteredJobArray.append(job)
                }
                self.tableView.reloadData()
            })
            

        })
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        localFilteredJobArray.removeAll(keepCapacity: false)
        serverFilteredJobArray.removeAll(keepCapacity: false)
        
        //Local search
        let searchPredicate = NSPredicate(format: "SELF.title CONTAINS[cd] %@", searchController.searchBar.text)
        let array = (jobArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.localFilteredJobArray = array as! [Job]
        
        //sever search
        getSearchResultsFromServer(searchController.searchBar.text)
        
        self.tableView.reloadData()
    }
}

