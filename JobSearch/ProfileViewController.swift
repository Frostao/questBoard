//
//  ProfileViewController.swift
//  JobSearch
//
//  Created by Gelei Chen on 15/3/7.
//  Copyright (c) 2015年 Purdue Bang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0{
            return 3
        } else if section == 1{
            return 2
        } else {
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "My Quest"
            } else if indexPath.row == 1{
                cell.textLabel?.text = "Accepted Quest"
            } else{
                cell.textLabel?.text = "Collection"
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                cell.textLabel?.text = "Profile"
            } else {
                cell.textLabel?.text = "Setting"
            }
        } else{
            cell.textLabel?.text =  "Log Out"
            
        }
        
        // Configure the cell...
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
