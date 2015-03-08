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


    
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var apply: UIButton!
    @IBAction func apply(sender: UIButton) {
        let alertController = UIAlertController(title: "Congratulations", message: "You have successfully added this job to your account", preferredStyle: .Alert)
        
        let oneAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            //call API to add this job to my account
            
        }
        alertController.addAction(oneAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var jobDescription: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var jobID: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var currentJob:Job?
    override func viewDidLoad() {
        super.viewDidLoad()
        salary.textColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.apply.backgroundColor = UIColor(red: 245.0/255, green: 146.0/255, blue: 108.0/255, alpha: 1)
        self.apply.tintColor = UIColor(red: 245, green: 146, blue: 108, alpha: 1)
        map.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentJob!.latitude, currentJob!.longitude), 5000, 5000), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(currentJob!.latitude, currentJob!.longitude)
        map.addAnnotation(annotation)
        self.hidesBottomBarWhenPushed = true

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
