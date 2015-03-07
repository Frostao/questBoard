//
//  ViewController.swift
//  socket
//
//  Created by Gelei Chen on 15/2/24.
//  Copyright (c) 2015年 Gelei. All rights reserved.
//

import UIKit

class JobViewController: UITableViewController {
    
    
    

    var socket = SIOSocket()
    var jobArray:[Job] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "hello"
        SIOSocket.socketWithHost("http://nerved.herokuapp.com", response: { (socket:SIOSocket!) in
            self.socket = socket;
            self.socket.on("handshake", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                let dict = arg[0] as NSDictionary
                let uuid: AnyObject? = dict["uuid"]
                //self.navigationController?.navigationItem.title = uuid as String?
                
            })
            self.socket.emit("queryall")
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                //println(arg.firstObject!)
                let dict = arg[0] as NSDictionary
                //println(dict)
                let data: NSArray = dict["data"] as NSArray//get data
                for entryDict in data{
                    //println(entryDict)
                    
                    //location && coordinate
                    let location:NSDictionary = entryDict.objectForKey("location") as NSDictionary
                    let coordinate:NSArray = (location.objectForKey("coordinates") as NSArray)
                    
                    //title
                    let title:String = entryDict.objectForKey("description") as String
                    let salaryDouble:Double = entryDict.objectForKey("comp") as Double
                    let salary = "$ " + salaryDouble.description
                    let job = Job(longitude: coordinate[0] as Double, latitude: coordinate[1] as Double,salary:salary,title:title)
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        let value = jobArray[indexPath.row]
        cell?.textLabel?.text = value.description
        return cell!

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMap" {
            let viewController = segue.destinationViewController as LocationViewController
            viewController.jobArray = self.jobArray
        }
    }

    
}

