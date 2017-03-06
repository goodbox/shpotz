//
//  MapViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

public class MapViewController : UIViewController, CLLocationManagerDelegate {
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.distanceFilter = 50
    locationManager.delegate = self
    locationManager.requestLocation()
    
    let camera = GMSCameraPosition.camera(withLatitude: 39.742043,
                                          longitude: -104.991531,
                                          zoom: zoomLevel)
    mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
    mapView.settings.myLocationButton = true
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.isMyLocationEnabled = true
    
    // Add the map to the view, hide it until we've got a location update.
    view.addSubview(mapView)
    mapView.isHidden = false
    
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.last != nil {
      
      
      let location: CLLocation = locations.last!
      print("Location: \(location)")
      
      let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)
      
      if mapView.isHidden {
        mapView.isHidden = false
        mapView.camera = camera
      } else {
        mapView.animate(to: camera)
      }
      
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
      mapView.settings.myLocationButton = true
    }
  }
  
  

  
  /*
  override public func loadView() {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    
    view = mapView
    
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker.title = "Sydney"
    marker.snippet = "Australia"
    marker.map = mapView
  }
   */
}

