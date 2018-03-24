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
import ImagePicker
import Lightbox
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
  
  @IBOutlet weak var lblSpotPrivacy: UILabel!
  @IBOutlet weak var imgSpotPrivacy: UIImageView!
    
    
    @IBOutlet weak var cvActivities: UICollectionView!
    
    @IBOutlet weak var btnAddActivity: UIButton!
    var firstImage: UIImage!
  var secondImage: UIImage!
  var thirdImage: UIImage!
  
    var selectedSpotTypes: [SpotTypeModel] = []
  
  var spotVisibility: SpotsVisibility! = SpotsVisibility.none
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView : GMSMapView!
  var zoomLevel: Float = 15.0
  
  var didTapAddPhotoDelegate : DidTapAddPhotoButtonDelegate!
  
  var privacyActionController: TwitterActionController!
  
    fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    fileprivate let itemsPerRow: CGFloat = 3
    
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    firstImage = nil
    secondImage = nil
    thirdImage = nil
    
    txtName.delegate = self
    
    cvActivities.delegate = self
    cvActivities.dataSource = self
    
    cvActivities.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
    btnAddPhoto.setImage(Icon.photoCamera?.tint(with: UIColor.white), for: .normal)
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
                   image: (UIImage(named: "ic_public_white")?.tint(with: Color.grey.darken2))!),
        style: .default,
        handler: { action in
          
          self.spotVisibility = SpotsVisibility.public
          self.lblSpotPrivacy.text = "Public"
          self.imgSpotPrivacy.image = UIImage(named: "ic_public_white")?.tint(with: Color.grey.darken2)
    }))
    
    
    self.privacyActionController.addAction(
      Action(
        ActionData(title: "Private",
                   subtitle: "Visibile to friends only",
                   image: (UIImage(named: "ic_lock_white")?.tint(with: Color.grey.darken2))!),
        style: .default,
        handler: { action in
          self.spotVisibility = SpotsVisibility.private
          self.lblSpotPrivacy.text = "Private"
            self.imgSpotPrivacy.image = UIImage(named: "ic_lock_white")?.tint(with: Color.grey.darken2)
    }))
    
    btnAddActivity.setTitle("Add/Edit Activities", for: .normal)
    btnAddActivity.setTitleColor(UIColor.white, for: .normal)
    
    btnAddActivity.backgroundColor = Color.grey.darken3
  }
  
    @IBAction func btnAddActivityTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SelectSpotTypeSegue", sender: self)
    }
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == 2 {
      
    } else if indexPath.section == 3 {
      self.present(self.privacyActionController, animated: true, completion: nil)
    }
    
  }
  
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SelectSpotTypeSegue" {
      
      let destinationVC = segue.destination as! UINavigationController
      let selectSpotTypeVC = destinationVC.topViewController as! SelectSpotTypeViewController
      selectSpotTypeVC.selectedSpotTypes = selectedSpotTypes
      selectSpotTypeVC.spotTypeDelegate = self
    }
  }
  
  func setDefaultImage(imageToSet: UIImageView) {
    imageToSet.backgroundColor = Color.grey.lighten3
    imageToSet.image = Icon.photoLibrary?.tint(with: Color.grey.base)
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
extension PostTableViewController : DidSelectSpotTypesDelegate {
  
    public func didSelectSpotType(_sender: Any?, spotTypes: [SpotTypeModel]) {
        
        selectedSpotTypes = spotTypes
        
        self.cvActivities.reloadData()
    }
}


// MARK: ImagePickerDelegate

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
        thirdImage = images[2]
        
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

// MARK: UICollectionViewDataSource
extension PostTableViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.selectedSpotTypes.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                      for: indexPath) as! SelectSpotTypeCell
        
        
        
        cell.configure(SpotTypeModel(name: self.selectedSpotTypes[indexPath.row].SpotName))
        // Configure the cell
        return cell
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PostTableViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = MDCPalette.grey.tint400
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor.clear
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem + 20)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

