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

public class MapViewController : UIViewController {
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  var api: ApiServiceController!
  
  var didSelectMapMarkerDelegate: DidSelectMapMarkerDelegate!
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    self.api = ApiServiceController.sharedInstance
    
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
    
    mapView.delegate = self
    
    // Add the map to the view, hide it until we've got a location update.
    view.addSubview(mapView)
    mapView.isHidden = false
    
  }
  
}

extension MapViewController: GMSMapViewDelegate {
  
  public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    
    let vr = mapView.projection.visibleRegion()
    
    _ = self.api.getSpots(
      UserDefaults.SpotsToken!,
      bllat: String(vr.nearLeft.latitude),
      bllong: String(vr.nearLeft.longitude),
      brlat: String(vr.nearRight.latitude),
      brlong: String(vr.nearRight.longitude),
      fllat: String(vr.farLeft.latitude),
      fllong: String(vr.farLeft.longitude),
      frlat: String(vr.farRight.latitude),
      frlong: String(vr.farRight.longitude)) {
        (success, spots, error) in
      
        if error != nil {
        
          print(error ?? "an error occurred")
        
        } else {
        
          for spot in spots! {
            
            let position = CLLocationCoordinate2D(latitude: spot.Lat, longitude: spot.Long)
            let marker = GMSMarker(position: position)
            marker.title = spot.Name
            marker.map = mapView
          }
        }
    }
  }
  
  public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    
    self.didSelectMapMarkerDelegate.didSelectMapMarker(_sender: self)
  }
  
  public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    
  }
}

extension MapViewController: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.last != nil {
      
      
      let location: CLLocation = locations.last!
      
      let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)
      
      if mapView.isHidden {
        mapView.isHidden = false
        mapView.camera = camera
      } else {
        mapView.animate(to: camera)
      }
     
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
      mapView.settings.myLocationButton = true
    }
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

