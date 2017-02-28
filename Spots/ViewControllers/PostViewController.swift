//
//  PostViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material
import GoogleMaps

class PostViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var vHeader: UIView!
  @IBOutlet weak var svLoading: UIStackView!
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  open override func viewDidLoad() {
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
    mapView.isHidden = true
    
  }

  @IBAction func btnCancelTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  
  // #MARK -  CLLocationManagerDelegate
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.last != nil {
      
      
      let location: CLLocation = locations.last!
      print("Location: \(location)")
      
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
      self.svLoading.isHidden = true
      
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
