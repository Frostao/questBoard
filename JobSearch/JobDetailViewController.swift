//
//  JobDetailViewController.swift
//
//
//  Created by Gelei Chen on 15/3/7.
//
//

import UIKit
import MapKit

class JobDetailViewController: UIViewController,UIAlertViewDelegate {
    
    
    var currentJob:Job?
    var socket = SIOSocket()
    var phoneNumber : String?
    var email : String?
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var apply: UIButton!
    @IBAction func apply(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token:String = defaults.valueForKey("token") as? String {
            SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
                self.socket = socket;
                let dict = NSDictionary(objectsAndKeys: token,"token",self.currentJob!.postID,"postid")
                self.socket.emit("accept", args: [dict])
                self.socket.on("response", callback: { (args:[AnyObject]!)  in
                    let arg = args as SIOParameterArray
                    let dict = arg[0] as NSDictionary
                    println(dict)
                    
                })
            })
            
            
            let alertController = UIAlertController(title: "Publisher's Contact", message: nil, preferredStyle: .Alert)
            
            var oneAction:UIAlertAction
            var twoAction:UIAlertAction
            
            if let thePhone = phoneNumber {
                
                oneAction = UIAlertAction(title: "Phone: \(thePhone)", style: .Default, handler: nil)
                if let theEmail = email {
                    twoAction = UIAlertAction(title: "Email:\(theEmail)", style: .Default, handler: nil)
                } else {
                    twoAction = UIAlertAction(title: "Email: N/A", style: .Default, handler: nil)
                }
                
            } else {
                oneAction = UIAlertAction(title: "Phone: N/A", style: .Default, handler: nil)
                if let theEmail = email {
                    twoAction = UIAlertAction(title: "Email:\(theEmail)", style: .Default, handler: nil)
                } else {
                    twoAction = UIAlertAction(title: "Email: N/A", style: .Default, handler: nil)
                }
            }
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            
            alertController.addAction(oneAction)
            alertController.addAction(twoAction)
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion: nil)
            self.apply.backgroundColor = UIColor(red: 81/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1)
            self.apply.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
            self.apply.setTitle("Show Publisher's Contact", forState: UIControlState.Normal)
            
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
            
        }
        
    }
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var jobID: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
            self.socket = socket;
            let dict = NSDictionary(objectsAndKeys: self.currentJob!.UUID,"uuid")
            self.socket.emit("uuid2phone", args: [dict])
            self.socket.on("response", callback: { (args:[AnyObject]!)  in
                let arg = args as SIOParameterArray
                let dict = arg[0] as NSDictionary
                self.email = dict.objectForKey("data")![0] as? String
                self.phoneNumber = dict.objectForKey("data")![1] as? String
                
            })
        })
        salary.textColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.apply.backgroundColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.apply.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        map.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentJob!.latitude, currentJob!.longitude), 5000, 5000), animated: true)
        
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(currentJob!.latitude, currentJob!.longitude)
        map.addAnnotation(annotation)
        
        */
        
        self.map.zoomEnabled = false;
        self.map.scrollEnabled = false;
        self.map.userInteractionEnabled = false;
        
        self.jobDescription.text = currentJob!.detail
        self.postTime.text = "Update : \(currentJob!.date)"
        self.jobTitle.text = currentJob!.title
        self.salary.text = currentJob!.salary
        self.endDate.text = currentJob!.expireDate
        self.jobID.text = "Job ID :\(currentJob!.jobID)"
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
