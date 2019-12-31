//
//  ViewController.swift
//  UsersLocationAndMaps
//
//  Created by mallikarjun on 15/05/19.
//  Copyright © 2019 Mallikarjun H. All rights reserved.

// YouTube Video Link: https://www.youtube.com/watch?v=vUvf_dlr6IU


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    //outlet of map view
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var preveousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding delegate programatically
        //mapView.delegate = self   // I already did through storyboard
        
        checkLocationServices()
        
    }
    
    func centerViewOnUserLocation(){
        
        if let location = locationManager.location?.coordinate{
            
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters:10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }

    func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled(){
           //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
            
        }else{
            //show an alert the user know they have to turn on this
            
        }
        
    }
    
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
            
         //When your app is open then and then only time app is authorised to get that users location
        case .authorizedWhenInUse:
            // do map stuff
            startTrackingUserLocation()
            break
            
        case .denied:
            //show alert instructing them how to turn on permission
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            //show an alert letting them know whats up
            break
            
        //app is authorised your location when app is also in background mode
        case .authorizedAlways:
            break
        
        @unknown default: break
            
            
        }
    }
    
    func startTrackingUserLocation() {
        
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() // it will call - didUpdateLocations - this delegate method
        preveousLocation = getCenterLocation(for: mapView)
        
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        
        let lattitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude:lattitude, longitude: longitude)
    }
    

}


extension ViewController: CLLocationManagerDelegate{
    
   /*
    // I am using this method to update the user location everytime
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
  
    } */
    
    // I am using this method to handle user authorization - means if user declined the permission, accep
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
    
    
}

extension ViewController: MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.preveousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.preveousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
}
