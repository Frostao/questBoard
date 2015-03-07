//
//  LocationViewController.swift
//  JobSearch
//
//  Created by Carl Chen on 3/6/15.
//  Copyright (c) 2015 Purdue Bang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class LocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var jobArray:[Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.426102, -86.9096881), 5000, 5000), animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        //The "Find me" button
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 70, self.view.frame.height - 110, 50, 50)
        button.setImage(UIImage(named: "MyLocation"), forState: .Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSizeMake(0, 0)
        button.layer.shadowRadius = 2
        self.view.addSubview(button)
        
        for job in jobArray {
            let annotation = MKPointAnnotation()
            annotation.title = job.title
            annotation.subtitle = job.salary
            annotation.coordinate = CLLocationCoordinate2DMake(job.longitude, job.latitude)
            mapView.addAnnotation(annotation)
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func buttonAction(sender:UIButton!)
    {
        let myLocation = mapView.userLocation.coordinate as CLLocationCoordinate2D
        let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation,5000,5000)
        self.mapView.setRegion(zoomRegion, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinAnnotation: MKPinAnnotationView?
        if annotation.isKindOfClass(MKPointAnnotation.classForCoder()) {
            let PinIdentifier = "PinIdentifier"
            pinAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier(PinIdentifier) as? MKPinAnnotationView
            if pinAnnotation == nil {
                pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: PinIdentifier)
            }
            pinAnnotation?.canShowCallout = true
            pinAnnotation?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        }
        return pinAnnotation
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
