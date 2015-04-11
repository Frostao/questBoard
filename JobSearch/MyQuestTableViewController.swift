//
//  MyQuestTableViewController.swift
//  
//
//  Created by Gelei Chen on 15/3/18.
//
//

import UIKit

class MyQuestTableViewController: UITableViewController {

    var jobArray : [Job] = []
    var currentJob : Job?
    var from = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.jobArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.jobArray[indexPath.row].title
        cell.detailTextLabel?.text = self.jobArray[indexPath.row].salary
        // Configure the cell...

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentJob = self.jobArray[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if from == "toAccpted" {
            self.performSegueWithIdentifier("toJobDetail", sender: self)
        } else if from == "toMyQuest" {
            self.performSegueWithIdentifier("toQuestDetail", sender: self)
        }
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toQuestDetail" {
            let viewController = segue.destinationViewController as! QuestDetailViewController
            viewController.currentJob = self.currentJob
        } else if segue.identifier == "toJobDetail" {
            let viewController = segue.destinationViewController as! JobDetailViewController
            viewController.currentJob = self.currentJob
        }
    }
    

}
