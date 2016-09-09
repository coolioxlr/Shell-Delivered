//
//  ViewController.swift
//  Shell Delivered
//
//  Created by Peter Ma on 9/8/16.
//  Copyright © 2016 Hackathon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 37.796896, longitude: -122.404928)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        mapView.showsUserLocation = true
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        centerMapOnLocation(initialLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        let location = newLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.mapView.userLocation.coordinate = center;
        //self.mapView.setRegion(region, animated: true)
    }*/

    @IBAction func orderGasGlicked(sender: AnyObject) {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://teamd-hackathon.revelup.com/specialresources/cart/submit/")!)
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            request.setValue("adc00a5c521b4a13b5c640181e53b25c:5b8ad3eef5934f0696e0c772255a1043ee514d476975491182cbb9344a3d00bd", forHTTPHeaderField: "API-AUTHENTICATION")
            request.HTTPMethod = "POST"
            
            let file = NSBundle.mainBundle().pathForResource("test", ofType: "json")
            let url = NSURL(fileURLWithPath: file!)
            let data = NSData(contentsOfURL: url)
            let json = try! NSJSONSerialization.JSONObjectWithData(data! as NSData, options: [])
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                guard let data = data where error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                let alertController = UIAlertController(title: "Success!", message: "Your gas is on the way", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            task.resume()
        }
}

