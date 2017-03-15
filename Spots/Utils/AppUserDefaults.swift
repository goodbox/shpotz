//
//  AppUserDefaults.swift
//  Spots
//
//  Created by goodbox on 2/27/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation


extension UserDefaults {
  
  static var FacebookUserId: String? {
    get {
      if let facebookUserId = UserDefaults.standard.value( forKey: _facebookUserIdKey ) as? String {
        return facebookUserId
      }
      return nil
    }
    set(value) {
      if value != nil {
        UserDefaults.standard.setValue(value, forKey: _facebookUserIdKey)
      }
      else {
        UserDefaults.standard.removeObject(forKey: _facebookUserIdKey)
      }
    }
  }
  fileprivate static let _facebookUserIdKey = "FacebookUserIdKey"

  
  static var FacebookAuthToken: String? {
    get { return UserDefaults.standard.value( forKey: _facebookAuthTokenKey ) as? String }
    set(value) { UserDefaults.standard.setValue(value, forKey: _facebookAuthTokenKey) }
  }
  
  fileprivate static let _facebookAuthTokenKey = "FacebookAuthTokenKey"
  
}
