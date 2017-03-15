//
//  UIImageExtension.swift
//  Spots
//
//  Created by goodbox on 3/5/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
  
  /// Returns a image that fills in newSize
  func resizedImage(newSize: CGSize) -> UIImage {
    // Guard newSize is different
    guard self.size != newSize else { return self }
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
  /// Note that the new image size is not rectSize, but within it.
  func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
    let widthFactor = size.width / rectSize.width
    let heightFactor = size.height / rectSize.height
    
    var resizeFactor = widthFactor
    if size.height > size.width {
      resizeFactor = heightFactor
    }
    
    let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
    let resized = resizedImage(newSize: newSize)
    return resized
  }
}
