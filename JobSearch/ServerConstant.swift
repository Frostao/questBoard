//
//  ServerConstant.swift
//  QuestBoard
//
//  Created by Siyuan Gao on 3/23/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//

import Foundation

private let _sharedInstance = ServerConst()
typealias ServiceResponse = (Bool?, String?) -> Void


class ServerConst {
    class var sharedInstance : ServerConst {
        return _sharedInstance
    }
    let serverURL = "https://nerved.herokuapp.com"
    
    var socket = SIOSocket()
    
    func login(username:String,password:String,onCompletion: ServiceResponse)->Void{
        SIOSocket.socketWithHost(self.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket
            let userInfo = NSDictionary(objectsAndKeys: username,"email",password,"password")
            self.socket.emit("login", args: [userInfo])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as NSArray
                let dict = arg[0] as! NSDictionary
                if  dict["code"] as! Int != 200 {
                    onCompletion(false,"user Name incorrect")
                } else {
                    onCompletion(true,"ok")
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(dict["data"], forKey: "token")
                    NSNotificationCenter.defaultCenter().postNotificationName("loggedin", object: nil)
                }
            })
        })
    }
    
    func register(talents:String,name:String,email:String,profession:String,password:String,phone:String,onCompletion: ServiceResponse)->Void{
        SIOSocket.socketWithHost(self.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket;
            let talent = talents.componentsSeparatedByString(",")
            let userInfo = NSDictionary(objectsAndKeys: name,"name",email,"email",profession, "profession",talent,"talents",password,"pass",phone,"phone")
            //println(userInfo)
            self.socket.emit("register", args: [userInfo])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as NSArray
                let dict = arg[0] as! NSDictionary
                if  dict["code"] as! Int != 200 {
                    onCompletion(false,"user Name incorrect")
                } else {
                    onCompletion(true,"ok")
                }
            })
        })
    }
    
    
    func post(skill:String,location:CLLocationCoordinate2D?,jobTitle:String,jobDescription:String,remarks:String,pay:String,duration:String,onComplemention:ServiceResponse){
        SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket;
            let defaults = NSUserDefaults.standardUserDefaults()
            let token = defaults.valueForKey("token") as! String
            let skills = skill.componentsSeparatedByString(",")
            if let theLocation = location {
                let location = NSDictionary(objectsAndKeys: NSDictionary(objectsAndKeys: "Point","type",[theLocation.longitude, theLocation.latitude],"coordinates"),"location")
                
                let userInfo = NSDictionary(objectsAndKeys: jobTitle,"title",jobDescription,"description",remarks, "remarks",skills,"skills",pay,"comp",(duration as NSString).doubleValue,"duration",token,"token",location["location"]!,"location")
                self.socket.emit("post", args: [userInfo])
            } else {
                //alertView
                onComplemention(false,"location not found")
                
            }
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as NSArray
                println(arg.firstObject!)
                let dict = arg[0] as! NSDictionary
                if  dict["code"] as! Int != 200 {
                    //email not correct
                    onComplemention(false,"user Name incorrect")
                    
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName("addedJob", object: nil)
                    onComplemention(true,"ok")
                }
                
                //let code: AnyObject? = dict["message"]
                
                //self.data.append(code! as String)
                //self.tableView.reloadData()
            })
        })

    }
    
    
}