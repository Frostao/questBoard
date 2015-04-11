//
//  SignUpViewController.swift
//  JobSearch
//
//  Created by Carl Chen on 3/7/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController,UITextFieldDelegate {
    var name = UITextField()
    var email = UITextField()
    var profession = UITextField()
    var talents = UITextField()
    var phone = UITextField()
    var password = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 245, green: 146, blue: 108, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
            switch indexPath.row {
            case 0:
                cell.label1?.text = "Name        "
                self.name = cell.textField1
            case 1:
                cell.label1?.text = "Email         "
                self.email = cell.textField1
                cell.textField1.keyboardType = UIKeyboardType.EmailAddress
            case 2:
                cell.label1.text = "Profession "
                self.profession = cell.textField1
            case 3:
                cell.label1.text = "Talents         "
                self.talents = cell.textField1
            case 4:
                cell.label1.text = "Phone Number"
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                    cell.textField1.keyboardType = UIKeyboardType.PhonePad
                }
                self.phone = cell.textField1
            case 5:
                cell.label1.text = "Password       "
                cell.textField1.secureTextEntry = true
                self.password = cell.textField1
            default:
                break
            }
            cell.textField1.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("signup", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1  && indexPath.row == 0{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            ServerConst.sharedInstance.register(self.talents.text, name: self.name.text, email: self.email.text, profession: self.profession.text, password: self.password.text, phone: self.phone.text){(responseObject:Bool?, error:String?) in
                if responseObject! {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alert = UIAlertView(title: "Incorrect email or password", message: "Incorrect email or password, please check your input", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        } else {
            
        }
        
    }
}
