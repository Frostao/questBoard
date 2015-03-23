//
//  QuestDetailViewController.swift
//  
//
//  Created by Gelei Chen on 15/3/18.
//
//

import UIKit

class QuestDetailViewController: UIViewController {

   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var jobID: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBAction func deletePressed(sender: UIButton) {
        //postid token
        let alertBigController = UIAlertController(title: "Please conform", message: "Are you sure you want to continue?", preferredStyle: .Alert)
        
        
        let yes = UIAlertAction(title: "Yes", style: .Default) { (_) in
            let defaults = NSUserDefaults.standardUserDefaults()
            if let token:String = defaults.valueForKey("token") as? String {
                SIOSocket.socketWithHost(ServerConst.sharedInstance.serverURL, response: { (socket:SIOSocket!) in
                    self.socket = socket;
                    let dict = NSDictionary(objectsAndKeys: token,"token",self.currentJob!.postID,"postid")
                    self.socket.emit("delete", args: [dict])
                    self.socket.on("response", callback: { (args:[AnyObject]!)  in
                        let arg = args as SIOParameterArray
                        let dict = arg[0] as NSDictionary
                        if dict.objectForKey("message") as String == "post delete failed" {
                            let alertController = UIAlertController(title: "Sorry", message: "Since you are not the poster of this quest, you can't delete this quest", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default) { (_) in
                        
                            }
                            
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: "Successful", message: "You have successfully deleted the quest", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default) { (_) in
                                NSNotificationCenter.defaultCenter().postNotificationName("addedJob", object: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    })
                })
            } else {
                self.performSegueWithIdentifier("showLogin", sender: self)
            }
            
            
        }
        
        let cancel = UIAlertAction(title: "No", style: .Default) { (_) in
            
            
        }
        alertBigController.addAction(yes)
        alertBigController.addAction(cancel)
        self.presentViewController(alertBigController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    @IBAction func edit(sender: UIButton) {
    }
    
    var currentJob:Job?
    var socket = SIOSocket()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edit.backgroundColor = UIColor(red: 255/255.0, green: 110/255.0, blue: 128/255.0, alpha: 1)
        self.edit.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        self.delete.backgroundColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.delete.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentJob!.latitude, currentJob!.longitude), 5000, 5000), animated: true)
        self.mapView.zoomEnabled = false;
        self.mapView.scrollEnabled = false;
        self.mapView.userInteractionEnabled = false;
        
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
    }
    

}
