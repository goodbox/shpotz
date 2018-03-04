//
//  PostViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

import GoogleMaps
import PopupDialog
import ImagePicker
import Lightbox
import AWSS3
import Photos

class PostViewController: UIViewController {
  
  @IBOutlet weak var btnPost: ActivityIndicatorButton!
  
  @IBOutlet weak var btnPostBottomConstraint: NSLayoutConstraint!
  
  var postTableView : PostTableViewController!
  
  var spotModel: SpotsModel!
    
    var selectedSpotTypes : [SpotTypeModel] = []
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    
    btnPost.backgroundColor = UIColor.spotsGreen()
    btnPost.setTitle("Add Spot", for: .normal)
    btnPost.setTitleColor(UIColor.white, for: .normal)
    
    spotModel = SpotsModel()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? PostTableViewController, segue.identifier == "PostTableViewSegue" {
      
      vc.didTapAddPhotoDelegate = self
      
      self.postTableView = vc
    }
  }

  @IBAction func btnCancelTapped(_ sender: Any) {
    
    if postTableView.txtName.isFirstResponder {
      postTableView.txtName.resignFirstResponder()
    }
    
    if postTableView.txtDescription.isFirstResponder {
      postTableView.txtDescription.resignFirstResponder()
    }
    
    self.dismiss(animated: true, completion: nil)
    
  }

  @IBAction func btnPostTapped(_ sender: Any) {
    
    //validate all fields
    if postTableView.txtName.text == "" {
      
      let uiImage = UIImage(named: "ic_error_red")
      
      showValidationPopup(theTitle: "Name is Required", theMessage: "Please enter a name for this spot.", theImage: uiImage)
    
      
    } else if postTableView.txtDescription.text == "" {
      
      let uiImage = UIImage(named: "ic_error_red")
      
      showValidationPopup(theTitle: "Description is Required", theMessage: "Please enter a description for this spot.", theImage: uiImage)
      
      
    } else if postTableView.selectedSpotTypes.count == 0 {
      
      let uiImage = UIImage(named: "ic_error_red")
      
      showValidationPopup(theTitle: "Activities are Required", theMessage: "Please select at least one activity for this spot.", theImage: uiImage)

    } else if postTableView.spotVisibility == SpotsVisibility.none {
      
      let uiImage = UIImage(named: "ic_error_red")
      
      showValidationPopup(theTitle: "Spot Privacy is Required", theMessage: "Please specify a visibility for this spot.", theImage: uiImage)
   
    } else if postTableView.firstImage == nil &&
      postTableView.secondImage == nil &&
      postTableView.thirdImage == nil {
      
      let uiImage = UIImage(named: "ic_error_red")
      
      showValidationPopup(theTitle: "At Least One Image is Required", theMessage: "Please add at least one image for this spot.", theImage: uiImage)
      
      
    } else {
    
      handleSpotPost()
      
    }
  }
  
  func handleSpotPost() {
    
    self.btnPost.showLoading()

    let api = ApiServiceController.sharedInstance
    
    spotModel.Name = postTableView.txtName.text
    
    spotModel.Description = postTableView.txtDescription.text
    
    spotModel.Lat = postTableView.currentLocation?.coordinate.latitude
    
    spotModel.Long = postTableView.currentLocation?.coordinate.longitude
    
    spotModel.selectedSpotTypes = postTableView.selectedSpotTypes
    
    // spotModel.SpotTypeName = postTableView.lblSpotType.text
    
    // spotModel.SpotType = SpotsType(rawValue: SpotsType.getSpotTypeFromSpotName(spotName: postTableView.lblSpotType.text!))
    
    spotModel.Visibility = postTableView.spotVisibility
    
    spotModel.SharedToFacebook = postTableView.swShareToFacebook.isOn
    
    if postTableView.firstImage != nil {
        spotModel.PhotoUrl1 = uploadImage(img: postTableView.firstImage)
    }
    
    if postTableView.secondImage != nil {
        spotModel.PhotoUrl2 = uploadImage(img: postTableView.secondImage)
        
    }
    
    if postTableView.thirdImage != nil {
        spotModel.PhotoUrl3 = uploadImage(img: postTableView.thirdImage)
    }
    
    
    _ = api.performPostSpot(UserDefaults.SpotsToken!, spotsModel: spotModel, completion: { (success, model, error) in
      
      if(error == nil) {
        
        if(success) {
          
          self.showSuccessPopupDialog()
            
            // now upload images to amazon in the background
          
        } else {
          
          // some other error happened
          print("an error occurred")
        }
        
      } else {
        
        // there was some network error or something
        print("an error occurred")
      
      }
      
    })
    
    /*
    
    
 
 */
  }
    
    func uploadImage(img: UIImage?) -> String! {
        
        let uuidFilename = UUID().uuidString + ".jpg"
        
        do {
            
            let uuidPrefix = uuidFilename.substring(to: uuidFilename.index(uuidFilename.startIndex, offsetBy: 4))
            
            let resizedImage = postTableView.firstImage.resizedImageWithinRect(rectSize: CGSize(width: 320, height: 240))
            
            // let resizedImage = postTableView.firstImage.resizedImage(newSize: CGSize(width: 320, height: 240))
            
            let testFileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uuidFilename)
            
            let data = UIImageJPEGRepresentation(resizedImage, 1.0)
            
            try data?.write(to: testFileUrl!)
            
            let transferManager = AWSS3TransferManager.default()
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            
            uploadRequest?.bucket = "spots-app-bucket"
            
            uploadRequest?.key = "uploads/" + uuidPrefix + "/" + uuidFilename
            
            uploadRequest?.contentType = "image/jpeg"
            
            uploadRequest?.body = testFileUrl!
            
            transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                        }
                    } else {
                        print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                    }
                    return nil
                }
                
                let uploadOutput = task.result
                
                print("Upload complete for: \(String(describing: uploadRequest?.key))")
                
                // self.showSuccessPopupDialog()
                
                return uuidFilename
            })
            
            return uuidFilename
            
        } catch {
            
            print("other error occurred : \(error)")
            
        }
        
        return ""
    }
  
  func showValidationPopup(theTitle: String?, theMessage: String?, theImage: UIImage?) {
    
    
    let validationViewController = ValidationPopupViewController(nibName: "ValidationPopup", bundle: nil)
    
    let popup = PopupDialog(viewController: validationViewController, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true) { 
      
      print("validation popup dismissed")
      
    }
    
    let buttonOne = DefaultButton(title: "Dismiss") {
      
    }

    popup.addButton(buttonOne)
    
    self.present(popup, animated: true, completion: nil)
    
    let vc = popup.viewController as! ValidationPopupViewController
    
    vc.imgValidationImage.image = theImage
    
    vc.lblValidationTitle.text = theTitle
    
    vc.lblValidationMessage.text = theMessage
    
    
  }
  
  func showSuccessPopupDialog() {
    
    let validationViewController = ValidationPopupViewController(nibName: "ValidationPopup", bundle: nil)
    
    let popup = PopupDialog(viewController: validationViewController, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true) {
      
      if let navController = self.navigationController {
        navController.dismiss(animated: true, completion: {
        })
      }
    }
    
    let buttonOne = DefaultButton(title: "OK") {
      if let navController = self.navigationController {
        navController.dismiss(animated: true, completion: {
        })
      }
    }

    
    popup.addButton(buttonOne)
    
    self.present(popup, animated: true, completion: nil)
    
    let vc = popup.viewController as! ValidationPopupViewController
    
    vc.imgValidationImage.image = UIImage(named: "ic_check")//?.tint(with: UIColor.spotsGreen())
    
    vc.lblValidationTitle.text = "Success!"
    
    vc.lblValidationMessage.text = "THis spot has been successfully added!"
    
  }

  
  
  
  // MARK: keyboard notifications
@objc func keyboardWillHide(_ notification: Notification) {
    
    let animationDuration = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
    
    self.btnPostBottomConstraint.constant = 0
    
    UIView.animate(withDuration: animationDuration, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  
@objc func keyboardWillShow(_ notification: Notification) {
    
    
    let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
    let animationDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
    
    let height = keyboardFrame.size.height
    
    self.btnPostBottomConstraint.constant = height
    
    UIView.animate(withDuration: animationDuration, animations: {
      self.view.layoutIfNeeded()
    })
  }
}


// MARK: DidTapAddPhotoButtonDelegate
extension PostViewController : DidTapAddPhotoButtonDelegate {
  
  func didTapAddPhoto(_ sender: Any?, numToAdd: Int?) {
    
    let imagePickerController = ImagePickerController()
    imagePickerController.imageLimit = numToAdd!
    imagePickerController.delegate = self.postTableView
    present(imagePickerController, animated: true, completion: nil)
  }
}
