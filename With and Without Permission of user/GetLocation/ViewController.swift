//
//  ViewController.swift
//  GetLocation
//
//  Created by mallikarjun on 14/05/19.
//  Copyright © 2019 Mallikarjun H. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //Create Location Manger constant
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // FOr use when app is open and in the background mode
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
       // locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //get actual locatioln
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        
        if let location = locations.first{
            
            print(location.coordinate) // prints - CLLocationCoordinate2D(latitude: 12.981415456172993, longitude: 77.72726012401071)
            
            //Getting lattitude - location.coordinate.latitude
            // Getting longitude - location.coordinate.longitude
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.denied{
            
            showLocationDisabledPopUp()
        }
    }

    func showLocationDisabledPopUp(){
        
        let alertView = UIAlertController(title: "Background location Access Disabled", message: "In order to deliver food we need your location", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default){ (action) in
            
            if let url = URL(string: UIApplication.openSettingsURLString){
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        
        alertView.addAction(openAction)
        present(alertView, animated: true, completion: nil)
    }

}

