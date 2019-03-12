//
//  AppUserDefaults.swift
//  Spots
//
//  Created by goodbox on 2/27/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation


extension UserDefaults {
  
    fileprivate static let _tryLogin = "TryLogin"
    static var TryLogin: Bool? {
        get {
            if let tryLogin = UserDefaults.standard.value( forKey: _tryLogin ) as? Bool {
                return tryLogin
            }
            return false
        }
        set(value) {
            if value != nil {
                UserDefaults.standard.setValue(value, forKey: _tryLogin)
            }
            else {
                UserDefaults.standard.removeObject(forKey: _tryLogin)
            }
        }
    }
    
    fileprivate static let _facebookUserIdKey = "FacebookUserIdKey"
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

    fileprivate static let _facebookAuthTokenKey = "FacebookAuthTokenKey"
    static var FacebookAuthToken: String? {
        get { return UserDefaults.standard.value( forKey: _facebookAuthTokenKey ) as? String }
        set(value) { UserDefaults.standard.setValue(value, forKey: _facebookAuthTokenKey) }
    }
  
    fileprivate static let _spotToken = "SpotsToken"
    static var SpotsToken: String? {
        get { return UserDefaults.standard.value( forKey: _spotToken ) as? String }
        set(value) { UserDefaults.standard.setValue(value, forKey: _spotToken) }
    }
  
}
