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

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var model: SpotMapModel!
    
    init(position: CLLocationCoordinate2D, name: String, spotMapModel: SpotMapModel) {
        self.position = position
        self.name = name
        self.model = spotMapModel;
    }
}

public class MapViewController : UIViewController {
  
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView : GMSMapView!
    var clusterManager: GMUClusterManager!
    var zoomLevel: Float = 15.0
  
    var api: ApiServiceController!
  
    var didSelectMapMarkerDelegate: DidSelectMapMarkerDelegate!
  
    var selectedMarker: GMSMarker!
    
    var isCluster: Bool = false
    
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
        
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self as! GMUClusterRendererDelegate
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        clusterManager.setDelegate(self, mapDelegate: self)
    }
}


extension MapViewController: GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate{

    // GMUClusterManagerDelegate
    
    public func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        print("renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {")
        if let poiItem = object as? POIItem {
            let position = CLLocationCoordinate2D(latitude: poiItem.model.Latitude, longitude: poiItem.model.Longitude)
            let marker = GMSMarker(position: position)
            if poiItem.model.SpotSystemType == SpotsSystemType.goodSpot {
                marker.icon = GMSMarker.markerImage(with: UIColor.spotsGreen())
            }
            return marker
        } else {
            return nil
        }
       
        
    }
    
    public func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        isCluster = true;
        return false
    }
    
    //GMSPAPVIEWDELEGATE
    
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            if poiItem.model.SpotSystemType == SpotsSystemType.goodSpot {
                marker.icon = GMSMarker.markerImage(with: UIColor.spotsGreen())
            }
            marker.title = poiItem.name
            marker.userData = poiItem.model
            isCluster = true
            return false
        } else {
            NSLog("Did tap a normal marker")
            //marker.title = poiItem.name
            //marker.userData = poiItem.model
            
        }
        return true
    }
  
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    
        if !isCluster {
            
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
                        
                        self.clusterManager.clearItems()
                        
                        for spot in spots! {
                            
                            /*
                             let position = CLLocationCoordinate2D(latitude: spot.Latitude, longitude: spot.Longitude)
                             let marker = GMSMarker(position: position)
                             
                             
                             marker.title = spot.Name
                             
                             marker.appearAnimation = .none
                             
                             marker.userData = spot
                             
                             
                             if spot.SpotSystemType == SpotsSystemType.facility {
                             
                             // marker.icon?  //  = UIImage(named: "ic_place_white_48pt")?.tint(with: UIColor.totesBlueColor())
                             
                             } else if spot.SpotSystemType == SpotsSystemType.goodSpot {
                             marker.icon = GMSMarker.markerImage(with: UIColor.spotsGreen())
                             
                             }
                             
                             
                             marker.layer.shadowColor = UIColor.black.cgColor
                             marker.layer.shadowOpacity = 0.5
                             marker.layer.shadowOffset = CGSize.zero
                             marker.layer.shadowRadius = 1;
                             
                             marker.map = mapView
                             
                             */
                            
                            let lat = spot.Latitude
                            let lng = spot.Longitude
                            let name = spot.Name
                            let item = POIItem(position: CLLocationCoordinate2DMake(lat!, lng!), name: name!, spotMapModel: spot)
                            self.clusterManager.add(item)
                            
                        }
                        
                        self.clusterManager.cluster()
                    }
            }
        }
        
        self.isCluster = false
    }
  
    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.didSelectMapMarkerDelegate.didSelectMapMarker(_sender: self, spot: marker.userData as! SpotMapModel)
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

