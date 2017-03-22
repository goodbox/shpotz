//
//  Models.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: Enums : SpotType
enum SpotsType : Int {
  case all = 0
  case camping = 1
  case fishing = 2
  case hiking = 3
  case rockclimbing = 4
  case mtnbiking = 5
  case iceclimbing = 6
  case canoeing = 7
  case surfing = 8
  case swimming = 9
  case diving = 10
  case rafting = 11
  case hotsprings = 12
  case other = 10000
}

// MARK: ENums Visibility
enum SpotsVisibility: Int {
  case `public` = 1
  case friends = 3
  case `private` = 4
}

// MARK: login model
public class LoginModel {
  
  var BearerToken: String!
  
  var Id: Int64!
  
  var FacebookId: String!
  
  var Name: String!
  
  var Email: String!
  
  init() {}
  
  init(json: JSON) {
    
    self.Id = json["id"].int64!
    
    self.BearerToken = json["bearerToken"].string!
    
    self.Email = json["email"].string!
    
    self.FacebookId = json["facebookId"].string!
    
    self.Name = json["name"].string!
  }
  
  func populateUserDefaults() {
    
  }
}

// MARK: spots model
public class SpotsModel {
  
  var Id: Int64!
  
  var UserId: Int64!
  
  var Lat: Double!
  
  var Long: Double!
  
  var SpotType: SpotsType!
  
  var Visibility: SpotsVisibility!
  
  var State: Int!
  
  var Name: String!
  
  var Description: String!
  
  var SpotTypeName: String!
  
  var SharedToFacebook: Bool!
  
  init() {}
  
  init(json: JSON) {
    
    self.Id = json["id"].int64!
    
    self.UserId = json["userId"].int64!
    
    self.Lat = json["latitude"].double!
    
    self.Long = json["longitude"].double!
    
    if let spotType = json["spotType"].int {
      self.SpotType = SpotsType.init(rawValue: spotType)
    }
    
    if let visibility = json["visibility"].int {
      self.Visibility = SpotsVisibility.init(rawValue: visibility)
    }

    self.State = json["state"].int!
    
    self.Name = json["name"].string!
    
    self.Description = json["description"].string!
    
    self.SpotTypeName = json["spotTypeName"].string!
    
    self.SharedToFacebook = json["sharedToFacebook"].bool!
    
  }
  
  func encodeToDictionary() -> [String:AnyObject] {
    
    var data = [ String : AnyObject ]()
    
    data["latitude"] = self.Lat as AnyObject?
    
    data["longitude"] = self.Long as AnyObject?
    
    data["spotType"] = NSNumber(value: self.SpotType.rawValue as Int)
    
    data["visibility"] = NSNumber(value: self.Visibility.rawValue as Int)
    
    data["name"] = self.Name as AnyObject?
    
    data["description"] = self.Description as AnyObject?
    
    data["spotTypeName"] = self.SpotTypeName as AnyObject?
    
    data["sharedToFacebook"] = self.SharedToFacebook as AnyObject?

    return data
  }
}











