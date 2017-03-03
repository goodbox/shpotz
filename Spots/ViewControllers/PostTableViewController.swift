//
//  PostTableViewController.swift
//  Spots
//
//  Created by goodbox on 2/28/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material
import GoogleMaps

public class PostTableViewController : UITableViewController {
  
  @IBOutlet weak var svLoading: UIStackView!
  @IBOutlet weak var vHeader: UIView!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtDescription: UITextView!
  @IBOutlet weak var btnAddPhoto: FABButton!
  @IBOutlet weak var imgFirst: UIImageView!
  @IBOutlet weak var btnFirstDelete: UIButton!
  @IBOutlet weak var imgSecond: UIImageView!
  @IBOutlet weak var btnSecondDelete: UIButton!
  @IBOutlet weak var imgThird: UIImageView!
  @IBOutlet weak var btnThirdDelete: UIButton!
  @IBOutlet weak var swShareToFacebook: UISwitch!
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  var didTapAddPhotoDelegate : DidTapAddPhotoButtonDelegate!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
   
    txtName.delegate = self
    
    btnAddPhoto.setImage(Icon.photoCamera?.tint(with: UIColor.white), for: .normal)
    btnAddPhoto.pulseColor = UIColor.white
    btnAddPhoto.backgroundColor = UIColor.spotsGreen()
    // btnAddPhoto.cornerRadius = 5.0
    
    imgFirst.backgroundColor = Color.grey.lighten3
    imgFirst.image = Icon.photoLibrary?.tint(with: Color.grey.base)
    imgFirst.contentMode = .center
    imgFirst.cornerRadius = 5.0

    imgSecond.backgroundColor = Color.grey.lighten3
    imgSecond.image = Icon.photoLibrary?.tint(with: Color.grey.base)
    imgSecond.contentMode = .center
    imgSecond.cornerRadius = 5.0

    imgThird.backgroundColor = Color.grey.lighten3
    imgThird.image = Icon.photoLibrary?.tint(with: Color.grey.base)
    imgThird.contentMode = .center
    imgThird.cornerRadius = 5.0

    
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
  
  @IBAction func btnAddPhotoTapped(_ sender: Any) {
    didTapAddPhotoDelegate.didTapAddPhoto(self)
  }
  
}


// MARK: textfield delegate
extension PostTableViewController : UITextFieldDelegate {
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField.tag == 1 {
      txtDescription.becomeFirstResponder()
      
      let indexPath = IndexPath(row: 0, section: 1)
      
      tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    return true
  }
}

// MARK:  CLLocationManagerDelegate
extension PostTableViewController : CLLocationManagerDelegate {
  
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
