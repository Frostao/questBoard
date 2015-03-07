//
//  ViewController.swift
//  socket
//
//  Created by Gelei Chen on 15/2/24.
//  Copyright (c) 2015年 Gelei. All rights reserved.
//

import UIKit

class JobViewController: UITableViewController {
    
    
    
    
    @IBOutlet weak var UIID: UILabel!
    var socket = SIOSocket()
    var data : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "hello"
        self.navigationController?.navigationItem.title = "hello"
        SIOSocket.socketWithHost("http://nerved.herokuapp.com", response: { (socket:SIOSocket!) in
            
            self.socket = socket;
            self.socket.on("handshake", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                let dict = arg[0] as NSDictionary
                let uuid: AnyObject? = dict["uuid"]
                //self.UIID.text = uuid as String?
                
            })
            self.socket.emit("queryall")
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                println(arg.firstObject!)
                let dict = arg[0] as NSDictionary
                
//                let code: AnyObject? = dict["data"]
//                for a in code as NSDictionary {
//                    println("a=\(a)")
//                }
//                let comp: [NSDictionary] = code! as [NSDictionary]
//                println("comp is \(comp)")
                //self.data.append(code! as String)
                self.tableView.reloadData()
            })
        })
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    
}

