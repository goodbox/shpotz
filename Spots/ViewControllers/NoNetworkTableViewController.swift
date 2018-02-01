//
//  NoNetworkTableViewController.swift
//  Spots
//
//  Created by Alexander Grach on 1/31/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

public class NoNetworkTableViewController : UITableViewController {
    
    @IBOutlet weak var vHeader: UIView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView : GMSMapView!
    var zoomLevel: Float = 15.0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.requestLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: 39.742043,
                                              longitude: -104.991531,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: vHeader.bounds, camera: camera)
        // mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        vHeader.addSubview(mapView)
    }
}


// MARK:  CLLocationManagerDelegate
extension NoNetworkTableViewController : CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            
            let location: CLLocation = locations.last!
            
            self.currentLocation = location
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
            // self.svLoading.isHidden = true
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            
            mapView.isMyLocationEnabled = true
            // mapView.settings.myLocationButton = true
        }
    }
}
