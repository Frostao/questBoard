//
//  LoginViewController.swift
//  JobSearch
//
//  Created by Carl Chen on 3/6/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate{
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var username:UITextField = UITextField()
    var password:UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 245, green: 146, blue: 108, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            return 3
        }
        return 2
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let cell = (tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell)
            cell.label1.text = "Email       "
            cell.textField1.delegate = self
            cell.textField1.keyboardType = UIKeyboardType.EmailAddress
            username = cell.textField1
            return cell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let cell = (tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell)
            cell.label1.text = "Password"
            cell.textField1.secureTextEntry = true;
            cell.textField1.delegate = self;
            password = cell.textField1
            return cell
            //Password row
        } else if indexPath.section == 0 && indexPath.row == 0 {
            let cell = (tableView.dequeueReusableCellWithIdentifier("image",forIndexPath: indexPath) as! CustomTableViewCell)
            cell.imageView1.image = UIImage(named: "Group")
            cell.backgroundColor = UIColor.clearColor()
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0{
            //Submit row
            let cell = tableView.dequeueReusableCellWithIdentifier("submit", forIndexPath:indexPath) as! UITableViewCell
            cell.textLabel?.text = "Login"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("submit", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "Sign Up"
            return cell
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1  && indexPath.row == 0{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            ServerConst.sharedInstance.login(self.username.text, password: self.password.text) {(responseObject:Bool?, error:String?) in
                if responseObject! {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alert = UIAlertView(title: "Incorrect email or password", message: "Incorrect email or password, please check your input", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        } else if indexPath.section == 1 {
            self.performSegueWithIdentifier("showSignup", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 200
        } else {
            return 40
        }
    }
    
}
