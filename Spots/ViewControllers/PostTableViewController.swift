//
//  PostTableViewController.swift
//  Spots
//
//  Created by goodbox on 2/28/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import GoogleMaps
//import ImagePicker
//import Lightbox
import XLActionController

public class PostTableViewController : UITableViewController {
  
  @IBOutlet weak var svLoading: UIStackView!
  @IBOutlet weak var vHeader: UIView!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtDescription: UITextView!
  @IBOutlet weak var btnAddPhoto: MDCFloatingButton!
  @IBOutlet weak var imgFirst: UIImageView!
  @IBOutlet weak var btnFirstDelete: UIButton!
  @IBOutlet weak var imgSecond: UIImageView!
  @IBOutlet weak var btnSecondDelete: UIButton!
  @IBOutlet weak var imgThird: UIImageView!
  @IBOutlet weak var btnThirdDelete: UIButton!
  @IBOutlet weak var swShareToFacebook: UISwitch!
  @IBOutlet weak var lblSpotType: UILabel!
  @IBOutlet weak var lblSpotPrivacy: UILabel!
  @IBOutlet weak var imgSpotPrivacy: UIImageView!
  
  var firstImage: UIImage!
  var secondImage: UIImage!
  var thirdImage: UIImage!
  
  var spotType: String!
  
  var spotVisibility: SpotsVisibility! = SpotsVisibility.none
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  var didTapAddPhotoDelegate : DidTapAddPhotoButtonDelegate!
  
  var privacyActionController: TwitterActionController!
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    firstImage = nil
    secondImage = nil
    thirdImage = nil
   
    spotType = ""
    
    txtName.delegate = self
    
    // btnAddPhoto.setImage(Icon.photoCamera?.tint(with: UIColor.white), for: .normal)
    // btnAddPhoto.pulseColor = UIColor.white
    btnAddPhoto.backgroundColor = UIColor.spotsGreen()
    
    setDefaultImage(imageToSet: imgFirst)
    
    setDefaultImage(imageToSet: imgSecond)
    
    setDefaultImage(imageToSet: imgThird)
    
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
    
    self.privacyActionController = TwitterActionController()
    
    self.privacyActionController.headerData = "Select Visibility"
    
    self.privacyActionController.addAction(
      Action(
        ActionData(title: "Public",
                   subtitle: "Visibile to everyone",
                   image: (UIImage(named: "ic_public_white"))!),//!?.tint(with: MDCPalette.grey.tint600))!),
        style: .default,
        handler: { action in
          
          self.spotVisibility = SpotsVisibility.public
          self.lblSpotPrivacy.text = "Public"
          self.imgSpotPrivacy.image = UIImage(named: "ic_public_white")//?.tint(with: MDCPalette.grey.tint600)
    }))
    
    
    self.privacyActionController.addAction(
      Action(
        ActionData(title: "Private",
                   subtitle: "Visibile to friends only",
                   image: (UIImage(named: "ic_lock_white"))!),//?.tint(with: MDCPalette.grey.tint600))!),
        style: .default,
        handler: { action in
          self.spotVisibility = SpotsVisibility.private
          self.lblSpotPrivacy.text = "Private"
            self.imgSpotPrivacy.image = UIImage(named: "ic_lock_white")//?.tint(with: MDCPalette.grey.tint600)
    }))
    
  }
  
  override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == 2 {
      self.performSegue(withIdentifier: "SelectSpotTypeSegue", sender: self)
    } else if indexPath.section == 3 {
      self.present(self.privacyActionController, animated: true, completion: nil)
    }
    
  }
  
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SelectSpotTypeSegue" {
      
      let destinationVC = segue.destination as! UINavigationController
      let selectSpotTypeVC = destinationVC.topViewController as! SelectSpotTypeViewController
      
      selectSpotTypeVC.spotTypeDelegate = self
    }
  }
  
  func setDefaultImage(imageToSet: UIImageView) {
    imageToSet.backgroundColor = MDCPalette.grey.tint600
    // imageToSet.image = Icon.photoLibrary?.tint(with: Color.grey.base)
    imageToSet.contentMode = .center
    imageToSet.layer.cornerRadius = 5.0

  }
  
  @IBAction func btnAddPhotoTapped(_ sender: Any) {
    
    var numToAdd = 0;
    
    if firstImage == nil {
      numToAdd += 1
    }
    
    if secondImage == nil {
      numToAdd += 1
    }
    
    if thirdImage == nil {
      numToAdd += 1
    }
    
    if numToAdd > 0 {
      didTapAddPhotoDelegate.didTapAddPhoto(self, numToAdd: numToAdd)
    }
  }
  
  // MARK: delete image methods
  @IBAction func btnFirstDeleteTapped(_ sender: Any) {
    if firstImage != nil {
     
      firstImage = nil
      
      setDefaultImage(imageToSet: imgFirst)
      
      btnAddPhoto.isEnabled = true
    }
  }
  
  @IBAction func btnSecondDeleteTapped(_ sender: Any) {
    if secondImage != nil {
      
      secondImage = nil
      
      setDefaultImage(imageToSet: imgSecond)
      
      btnAddPhoto.isEnabled = true
    }
  }
  
  @IBAction func btnThirdDeleteTapped(_ sender: Any) {
    if thirdImage != nil {
      
      thirdImage = nil
      
      setDefaultImage(imageToSet: imgThird)
      
      btnAddPhoto.isEnabled = true
    }
  }
  
}

// MARK: SpotTypeDelegate
extension PostTableViewController : DidSelectSpotTypeDelegate {
  
  public func didSelectSpotType(_sender: Any?, spotType: String?, spotName: String?) {
    
    lblSpotType.text = spotName!
    
    self.spotType = spotType!
  }
  
}


// MARK: ImagePickerDelegate
/*
extension PostTableViewController : ImagePickerDelegate {
  
  public func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
  public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    guard images.count > 0 else { return }
    
    let lightboxImages = images.map {
      return LightboxImage(image: $0)
    }
    
    let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
    imagePicker.present(lightbox, animated: true, completion: nil)
  }
  
  public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    imagePicker.dismiss(animated: true, completion: nil)
    
    if images.count > 0 {
      
      if firstImage == nil {
        
        firstImage = images[0]
        
        imgFirst.contentMode = .scaleToFill
        imgFirst.layer.cornerRadius = 5.0
        imgFirst.clipsToBounds = true
        imgFirst.image = images[0]
        
      } else if secondImage == nil {
        
        secondImage = images[0]
        
        imgSecond.contentMode = .scaleToFill
        imgSecond.layer.cornerRadius = 5.0
        imgSecond.clipsToBounds = true
        imgSecond.image = images[0]
      
      } else if thirdImage == nil {
        thirdImage = images[0]
        
        imgThird.contentMode = .scaleToFill
        imgThird.layer.cornerRadius = 5.0
        imgThird.clipsToBounds = true
        imgThird.image = images[0]
      }
    }
    
    if images.count > 1 {
      
      if firstImage == nil {
        
        firstImage = images[1]
        
        imgFirst.contentMode = .scaleToFill
        imgFirst.layer.cornerRadius = 5.0
        imgFirst.clipsToBounds = true
        imgFirst.image = images[1]
        
      } else if secondImage == nil {
        
        secondImage = images[1]
        
        imgSecond.contentMode = .scaleToFill
        imgSecond.layer.cornerRadius = 5.0
        imgSecond.clipsToBounds = true
        imgSecond.image = images[1]
        
      } else if thirdImage == nil {
        thirdImage = images[1]
        
        imgThird.contentMode = .scaleToFill
        imgThird.layer.cornerRadius = 5.0
        imgThird.clipsToBounds = true
        imgThird.image = images[1]
      }
    }
    
    if images.count > 2 {
      
      if firstImage == nil {
        
        firstImage = images[2]
        
        imgFirst.contentMode = .scaleToFill
        imgFirst.layer.cornerRadius = 5.0
        imgFirst.clipsToBounds = true
        imgFirst.image = images[2]
        
      } else if secondImage == nil {
        
        secondImage = images[2]
        
        imgSecond.contentMode = .scaleToFill
        imgSecond.layer.cornerRadius = 5.0
        imgSecond.clipsToBounds = true
        imgSecond.image = images[0]
        
      } else if thirdImage == nil {
        thirdImage = images[0]
        
        imgThird.contentMode = .scaleToFill
        imgThird.layer.cornerRadius = 5.0
        imgThird.clipsToBounds = true
        imgThird.image = images[2]
      }
    }
    
    if firstImage != nil && secondImage != nil && thirdImage != nil {
      btnAddPhoto.isEnabled = false
    }
    
  }
}

*/

// MARK: textfield delegate
extension PostTableViewController : UITextFieldDelegate {
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField.tag == 1 {
      txtDescription.becomeFirstResponder()
      
      let indexPath = IndexPath(row: 0, section: 1)
      
      tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
      
      return false
    }
    
    return true
  }
}

// MARK:  CLLocationManagerDelegate
extension PostTableViewController : CLLocationManagerDelegate {
  
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
      self.svLoading.isHidden = true
     
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
