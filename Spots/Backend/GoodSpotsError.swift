//
//  GoodSpotsError.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectiveC

public enum GoodspotsErrorType : Int {
  case unknownError = 1
  case unauthorized = 2
  case loginError = 3
  case signupError = 4
  
}

public let GoodspotsErrorDomain = "GoodspotsErrorDomain"

private var errorJson : JSON = JSON.null

extension NSError {
  
  var jsonError: JSON! {
    get {
      return objc_getAssociatedObject(self, &errorJson) as? JSON
    }
    set(newValue) {
      objc_setAssociatedObject(self, &errorJson, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  public convenience init(type: GoodspotsErrorType) {
    self.init(domain: GoodspotsErrorDomain, code: type.rawValue, userInfo: nil)
  }
}
