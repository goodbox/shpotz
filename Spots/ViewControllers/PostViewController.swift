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
import PopupDialog
import ImagePicker
import Lightbox
import AWSS3
import Photos

class PostViewController: UIViewController {
  
  @IBOutlet weak var btnPost: ActivityIndicatorButton!
  
  @IBOutlet weak var btnPostBottomConstraint: NSLayoutConstraint!
  
  var postTableView : PostTableViewController!
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    
    btnPost.backgroundColor = UIColor.spotsGreen()
    btnPost.setTitle("Add Spot", for: .normal)
    btnPost.setTitleColor(UIColor.white, for: .normal)
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
      
    }
    
    if postTableView.txtDescription.text == "" {
      
    }
    
    if postTableView.spotType == "" {
      
    }
    
    if postTableView.firstImage == nil ||
      postTableView.secondImage == nil ||
      postTableView.thirdImage == nil {
      
      
    }
    
    self.btnPost.showLoading()
    
    // post spot
    // post images to amazon
    // post location to api
    
    do {
      
      let uuidFilename = UUID().uuidString + ".jpg"
      
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
        
        if let error = task.error as? NSError {
          if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
            switch code {
            case .cancelled, .paused:
              break
            default:
              print("Error uploading: \(uploadRequest?.key) Error: \(error)")
            }
          } else {
            print("Error uploading: \(uploadRequest?.key) Error: \(error)")
          }
          return nil
        }
        
        let uploadOutput = task.result
        
        print("Upload complete for: \(uploadRequest?.key)")
        
        self.showSuccessPopupDialog()
        
        return nil
      })
    
    } catch {
      
      print("other error occurred : \(error)")
      
    }
  }
  
  func showValidationPopup(theTitle: String?, theMessage: String?) {
    
    let popup = PopupDialog(title: theTitle, message: theMessage, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
    
    let buttonOne = DefaultButton(title: "Dismiss") {
      
    }
    
    popup.addButton(buttonOne)
    
    self.present(popup, animated: true, completion: nil)
  }
  
  func showSuccessPopupDialog() {
    let title = "Success!"
    
    let message = "Spot added"
    
    // let popup = PopupDialog(title: title, message: message)
    let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
    
    let buttonOne = DefaultButton(title: "OK") {
      if let navController = self.navigationController {
        navController.dismiss(animated: true, completion: {
          
          
          
        })
      }
    }
    
    popup.addButton(buttonOne)
    
    self.present(popup, animated: true, completion: nil)
  }

  
  // MARK: keyboard notifications
  func keyboardWillHide(_ notification: Notification) {
    
    let animationDuration = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
    
    self.btnPostBottomConstraint.constant = 0
    
    UIView.animate(withDuration: animationDuration, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  
  func keyboardWillShow(_ notification: Notification) {
    
    
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
