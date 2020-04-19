//
//  ViewController.swift
//  Voorhees GPS
//
//  Created by Caleb Voorhees on 3/23/20.
//  Copyright © 2020 Caleb Voorhees. All rights reserved.
//

import UIKit
import CoreLocation
import WebKit
import MessageUI

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate  {
   
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    let locMan: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    // Tybee Island
    let tybeeLatitude: CLLocationDegrees = 0
    let tybeeLongitude: CLLocationDegrees = 0
    
    
    // New function to set up GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation: CLLocation=locations[0]
        NSLog("Something is happening")
        
        // Horizontal accuracy less than 0 means failure with core gps functions
        if newLocation.horizontalAccuracy >= 0 {
          
            
            let tybee:CLLocation = CLLocation(latitude: tybeeLatitude, longitude: tybeeLongitude)
           
            let delta:CLLocationDistance = tybee.distance(from: newLocation)
           
            let miles: Double = (delta * 0.000621371) + 0.5 // formula for meters to rounded miles
        
        if miles < 3 {
                          
            // Stop updating the location
                locMan.stopUpdatingLocation()
                
            // Arrival Message
                distanceLabel.text = "Welcome to Tybee Island"
        } else {
            let commaDelimited: NumberFormatter = NumberFormatter()
                commaDelimited.numberStyle = NumberFormatter.Style.decimal
               
               distanceLabel.text=commaDelimited.string(from: NSNumber(value: miles))!+" miles to Tybee Island"
            }
        }
    }
    
    // Web site implementation
    @IBOutlet weak var webView: WKWebView!
    @IBAction func openSite(_ sender: Any) {
    // if statement validates site being reached
               
        if let url = URL(string: "https://tybeeisland.com")
               {
        UIApplication.shared.open(url, options: [:])
               }
    }
    
    // SMS
    @IBAction func sendSMS(_ sender: Any) {
        let composeVC = MFMessageComposeViewController()
               composeVC.messageComposeDelegate = self
               
               // Configure the fields of the interface
               composeVC.recipients = ["3157445877"]
               composeVC.body = "Hello"
               
               // Present the view controller modally
               if MFMessageComposeViewController.canSendText() {
                   self.present(composeVC, animated: true, completion: nil)
               } else {
                   print("Can't send messages")
               }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load web content
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
               webView.load(myRequest)
        
        // GPS
        locMan.delegate = self
        locMan.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locMan.distanceFilter = 1609; // A mile in kilometers
        locMan.requestWhenInUseAuthorization()
        locMan.startUpdatingLocation()
        startLocation = nil
    }

    
    
    
    
}


