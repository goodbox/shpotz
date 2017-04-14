//
//  UIGradientImageView.swift
//  Totes
//
//  Created by goodbox on 10/11/16.
//  Copyright © 2016 JMR Designs, LLC. All rights reserved.
//

import Foundation
import UIKit

class UIGradientImageView: UIImageView {
  
  let myGradientLayer: CAGradientLayer
  
  override init(frame: CGRect){
    myGradientLayer = CAGradientLayer()
    super.init(frame: frame)
    self.setup()
    addGradientLayer()
  }
  
  
  func addGradientLayer(){
    if myGradientLayer.superlayer == nil{
      self.layer.addSublayer(myGradientLayer)
    }
  }
  
  required init(coder aDecoder: NSCoder){
    myGradientLayer = CAGradientLayer()
    super.init(coder: aDecoder)!
    self.setup()
    addGradientLayer()
  }
  
  func getColors() -> [CGColor] {
    return [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
  }
  
  func getLocations() -> [CGFloat]{
    return [0.3,  0.7]
  }
  
  func setup() {
    //myGradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
    //myGradientLayer.endPoint = CGPoint(x: 0.0, y: 0.7)
    
    let colors = getColors()
    myGradientLayer.colors = colors
    myGradientLayer.isOpaque = false
    //myGradientLayer.locations = getLocations()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    myGradientLayer.frame = self.layer.bounds
  }
  
  func showGradientLayer(_ show: Bool) {
    myGradientLayer.isHidden = show
  }
}
