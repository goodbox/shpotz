//
//  ButtonExtension.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material
import ObjectiveC

private var xoOriginalButtonText: String? = ""
private var xoActivityIndicator: UIActivityIndicatorView!

extension Button {
  
  var originalButtonText: String! {
    get {
      return objc_getAssociatedObject(self, &xoOriginalButtonText) as? String
    }
    set(newValue) {
      objc_setAssociatedObject(self, &xoOriginalButtonText, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  var activityIndicator: UIActivityIndicatorView! {
    get {
      return objc_getAssociatedObject(self, &xoActivityIndicator) as? UIActivityIndicatorView
    }
    set(newValue) {
      objc_setAssociatedObject(self, &xoActivityIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  open func showLoading() {
    originalButtonText = self.titleLabel?.text
    self.setTitle("", for: UIControlState.normal)
    
    if (activityIndicator == nil) {
      activityIndicator = createActivityIndicator()
    }
    
    showSpinning()
  }
  
  open func hideLoading() {
    self.setTitle(originalButtonText, for: UIControlState.normal)
    activityIndicator.stopAnimating()
  }
  
  fileprivate func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = UIColor.white
    return activityIndicator
  }
  
  fileprivate func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
  }
  
  fileprivate func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
    self.addConstraint(xCenterConstraint)
    
    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
  }

  
}

public class ActivityIndicatorButton : UIButton {
  var originalButtonText: String?
  var activityIndicator: UIActivityIndicatorView!
  
  open func showLoading() {
    originalButtonText = self.titleLabel?.text
    self.setTitle("", for: UIControlState.normal)
    
    if (activityIndicator == nil) {
      activityIndicator = createActivityIndicator()
    }
    
    showSpinning()
  }
  
  open func hideLoading() {
    self.setTitle(originalButtonText, for: UIControlState.normal)
    activityIndicator.stopAnimating()
  }
  
  fileprivate func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = UIColor.white
    return activityIndicator
  }
  
  fileprivate func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
  }
  
  fileprivate func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
    self.addConstraint(xCenterConstraint)
    
    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
  }

}


