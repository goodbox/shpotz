//
//  Models.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import SwiftyJSON

import Realm
import RealmSwift

enum SpotsSystemType: Int {
  
  case unknown = 0
  
  case facility = 1
  
  case goodSpot = 2
  
}

// MARK: Enums : SpotType
enum SpotsType : Int {
    case all = 0
    case camping = 1
    case firepit = 14
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
    case beach = 13
    case other = 10000
    case add = 10001
  
  
    static func getSpotTypeFromSpotName(spotName: String) -> Int {
    
        switch spotName {
      
        case "All":
            return SpotsType.all.rawValue
      
        case "Camping":
            return SpotsType.camping.rawValue
      
        case "Fishing":
            return SpotsType.fishing.rawValue
      
        case "Hiking":
            return SpotsType.hiking.rawValue
      
        case "Rock Climbing":
            return SpotsType.rockclimbing.rawValue
      
        case "Mtn Biking":
            return SpotsType.mtnbiking.rawValue
      
        case "Ice Climbing":
            return SpotsType.iceclimbing.rawValue
      
        case "Canoeing":
            return SpotsType.canoeing.rawValue
      
        case "Surfing":
            return SpotsType.surfing.rawValue
      
        case "Swimming":
            return SpotsType.swimming.rawValue
      
        case "Diving":
            return SpotsType.diving.rawValue
      
        case "Rafting":
            return SpotsType.rafting.rawValue
      
        case "Hot Springs":
            return SpotsType.hotsprings.rawValue
      
        case "Beach":
            return SpotsType.beach.rawValue
      
        case "Add":
            return SpotsType.add.rawValue
            
        case "Firepit":
            return SpotsType.firepit.rawValue
            
        default:
            return SpotsType.other.rawValue
        }
    }
}

// MARK: ENums Visibility
enum SpotsVisibility: Int {
  case none = 0
  case `public` = 1
  case friends = 3
  case `private` = 4
}

// MARK: spot type model
public class SpotTypeModel {
    
    var IsSelected: Bool = false
    
    var SpotType: SpotsType! = SpotsType.other
    
    var SpotName: String = ""
    
    init() {}
    
    init(json: JSON) {
        
        self.SpotName = json["name"].string!
        
        if let spotTypeId = json["spotTypeId"].int {
            self.SpotType = SpotsType.init(rawValue: spotTypeId)
        }
        
        self.IsSelected = true
    }
    
    init(type: SpotsType, name: String) {
        self.SpotType = type
        self.SpotName = name
    }
    
    init(type: SpotsType, name: String, isSelected: Bool) {
        self.SpotName = name
        self.SpotType = type
        self.IsSelected = isSelected
    }
    
    init(name: String) {
        self.SpotName = name
        self.SpotType = SpotsType(rawValue: SpotsType.getSpotTypeFromSpotName(spotName: name))!
    }
}

// MARK: login model
public class LoginModel {
  
  var BearerToken: String!
  
  var Id: Int64!
  
  var FacebookId: String!
  
  var Name: String!
  
  var Email: String!
  
  var IsNewUser: Bool!
  
  init() {}
  
  init(json: JSON) {
    
    self.Id = json["id"].int64!
    
    self.BearerToken = json["bearerToken"].string!
    
    self.Email = json["email"].string!
    
    self.FacebookId = json["facebookId"].string!
    
    self.Name = json["name"].string!
    
    if let isNewUser = json["isNewUser"].bool {
      self.IsNewUser = isNewUser
    }
  }
  
  func populateUserDefaults() {
    
  }
}


// MARK: user view model
public class UserViewModel {
    var FacebookUserId: String! = ""
    var FirstName: String! = ""
    var LastName: String! = ""
    
    init() {}
    
    init(json: JSON) {
        
        if let facebookUserId = json["facebookUserId"].string {
            self.FacebookUserId = facebookUserId
        }
        
        if let firstName = json["firstName"].string {
            self.FirstName = firstName
        }
        
        if let lastName = json["lastName"].string {
            self.LastName = lastName
        }
    }
    
    func fullName() -> String {
        return FirstName + " " + LastName
    }
}

// MARK: spots model
public class SpotsModel {
  
    var Id: Int64! = 0
  
    var UserId: Int64! = 0
  
    var Lat: Double! = 0
  
    var Long: Double! = 0
  
    var selectedSpotTypes: [SpotTypeModel] = []
  
    var Visibility: SpotsVisibility! = SpotsVisibility.none
  
    var State: Int! = 0
  
    var Name: String! = ""
  
    var Description: String! = ""
  
    var PhotoUrl1: String! = ""
    
    var PhotoUrl2: String! = ""
    
    var PhotoUrl3: String! = ""
  
    var SharedToFacebook: Bool! = false
    
    var spotImages: [FacilityMedia]! = []
    
    var User: UserViewModel! = nil
    
    init() {}
  
    init(json: JSON) {
    
        self.Id = json["id"].int64!
    
        self.UserId = json["userId"].int64!
    
        self.Lat = json["latitude"].double!
    
        self.Long = json["longitude"].double!
    
        let spotTypes = json["spotTypes"]
    
        if(spotTypes != JSON.null) {
            for(_, subJson):(String, JSON) in spotTypes {
                self.selectedSpotTypes.append(SpotTypeModel(json: subJson))
            }
        }
    
        let spotImages = json["spotImages"]
        if spotImages != JSON.null {
            for(_, subJson):(String, JSON) in spotImages {
                self.spotImages.append(FacilityMedia(json: subJson))
            }
        }
    
    /*
    if let spotType = json["spotType"].int {
      self.SpotType = SpotsType.init(rawValue: spotType)
    }
 */
    
        if let visibility = json["visibility"].int {
            self.Visibility = SpotsVisibility.init(rawValue: visibility)
        }

        self.State = json["state"].int!
    
        self.Name = json["name"].string!
    
        if let description = json["description"].string {
            self.Description = description
        }
    
    
    
    /*
    
    if let spotTypeName = json["spotTypeName"].string {
        self.SpotTypeName = spotTypeName
    }
 */
    
        self.SharedToFacebook = json["sharedToFacebook"].bool!
    
        
        self.User = UserViewModel(json: json["userViewModel"])
  }
  
  
  func encodeToDictionary() -> [String:AnyObject] {
    
    var data = [ String : AnyObject ]()
    
    data["latitude"] = self.Lat as AnyObject?
    
    data["longitude"] = self.Long as AnyObject?
    
    // data["spotType"] = NSNumber(value: self.SpotType.rawValue as Int)
    
    data["visibility"] = NSNumber(value: self.Visibility.rawValue as Int)
    
    data["name"] = self.Name as AnyObject?
    
    data["description"] = self.Description as AnyObject?
    
    // data["spotTypeName"] = self.SpotTypeName as AnyObject?
    
    data["sharedToFacebook"] = self.SharedToFacebook as AnyObject?
    
    var spotTypes: [[String: AnyObject]] = []
    for object in self.selectedSpotTypes as [SpotTypeModel] {
        var item = [String:AnyObject]()
        
        item["spotTypeId"] = NSNumber(value: object.SpotType.rawValue)
        
        item["name"] = object.SpotName as AnyObject?
        
        spotTypes.append(item)
    }
    
    data["spotTypes"] = spotTypes as AnyObject?
    
    data["photo1Url"] = self.PhotoUrl1 as AnyObject?
    
    data["photo2Url"] = self.PhotoUrl2 as AnyObject?
    
    data["photo3Url"] = self.PhotoUrl3 as AnyObject?
    
    return data
  }
}

public class SpotMapModel {
  
  var Id: Int64!
  
  var Name: String!
  
  var Latitude: Double!
  
  var Longitude: Double!
  
  var SpotSystemType: SpotsSystemType! = SpotsSystemType.unknown
  
  init() {}
  
  init(json: JSON) {
    
    if let id = json["id"].int64 {
      self.Id = id
    }
    
    if let name = json["name"].string {
      self.Name = name
    }
    
    if let lat = json["latitude"].double {
      self.Latitude = lat
    }
    
    if let lon = json["longitude"].double {
      self.Longitude = lon
    }
    /*
    if let spotType = json["spoType"].int {
      self.SpotType = SpotsType.init(rawValue: spotType)
    }
    */
    if let spotSystemType = json["spotSystemType"].int {
      self.SpotSystemType = SpotsSystemType.init(rawValue: spotSystemType)
    }
    
  }
  
}

// MARK: Facility models
public class FacilityDetail {
  
  var Model: FacilityModel! = nil
  
  var Attributes: [FacilityAttribute]! = []
  
  var Media: [FacilityMedia]! = []
  
  var Activities: [FacilityActivity]! = []
  
  init() {}
  
  init(json: JSON) {
    
    // set the core poperties
    self.Model = FacilityModel(json: json["facilityModel"])
    
    // set activities
    let activities = json["facilityActivities"]
    
    if(activities != JSON.null) {
      for (_,subJson):(String, JSON) in activities {
        //Do something you want
        self.Activities.append(FacilityActivity(json: subJson))
      }
    }
    
    // set media
    let media = json["facilityMedia"]
    
    if(activities != JSON.null) {
      for (_,subJson):(String, JSON) in media {
        //Do something you want
        self.Media.append(FacilityMedia(json: subJson))
      }
    }

    // set attributes
    let attributes = json["facilityAttributes"]
    
    if(attributes != JSON.null) {
      for (_,subJson):(String, JSON) in attributes {
        //Do something you want
        self.Attributes.append(FacilityAttribute(json: subJson))
      }
    }
  }
}

public class FacilityModel {
  
  var Id: Int64 = 0
  
  var AdaAccess: String = ""
  
  var Description: String = ""
  
  var Directions: String = ""
  
  var Latitude: Double = 0
  
  var Longitude: Double = 0
  
  var MapUrl: String = ""
  
  var Name: String = ""
  
  var Phone: String = ""
  
  var TypeDescription: String = ""
  
  var UseFee: String = ""
  
  var StayLimit: String = ""
  
  var SpotType: SpotsType = SpotsType.camping
  
  init() {}
  
  init(json: JSON) {
    
    if let id = json["facilityId"].int64 {
      self.Id = id
    }
    
    if let adaAccess = json["facilityAdaAccess"].string {
      self.AdaAccess = adaAccess
    }
    
    if let description = json["facilityDescription"].string {
      self.Description = description
    }
    
    if let facilityDirections = json["facilityDirections"].string {
      self.Directions = facilityDirections
    }
    
    if let latitude = json["latitude"].double {
      self.Latitude = latitude
    }
    
    if let longitude = json["longitude"].double {
      self.Longitude = longitude
    }
    
    if let mapUrl = json["mapUrl"].string {
      self.MapUrl = mapUrl
    }
    
    if let name = json["name"].string {
      self.Name = name
    }
    
    if let phone = json["phone"].string {
      self.Phone = phone
    }
    
    if let typeDescription = json["typeDescription"].string {
      self.TypeDescription = typeDescription
    }
    
    if let useFee = json["useFee"].string {
      self.UseFee = useFee
    }
    
    if let stayLimit = json["stayLimit"].string {
      self.StayLimit = stayLimit
    }
    
  }
}

public class FacilityAttribute {
  
  var Name: String = ""
  
  var Value: String = ""
  
  init() {}
  
  init(json: JSON) {
    
    if let name = json["name"].string {
      self.Name = name
    }
    
    if let value = json["value"].string {
      self.Value = value
    }
    
  }
}

public class FacilityMedia {
  
  var Height: Int = 0
  
  var Width: Int = 0
  
  var MediaType: String = ""
  
  var Url: String = ""
  
  init() {}
  
  init(json: JSON) {
    
    if let height = json["height"].int {
      self.Height = height
    }
    
    if let width = json["width"].int {
      self.Width = width
    }
    
    if let mediaType = json["mediaType"].string {
      self.MediaType = mediaType
    }
    
    if let url = json["url"].string {
      self.Url = url
    }
  }
}

public class FacilityActivity {
  
  var Name: String = ""
  
  var Id: Int = 0
  
  init() { }
  
  init(json: JSON) {
    
    if let id = json["activityId"].int {
      self.Id = id
    }
    
    if let name = json["activityName"].string {
      self.Name = name
    }
  }
}

// MARK: realm image
public class RealmImage: Object {
    @objc dynamic var picture: Data? = nil
}

// MARK: realm spot type model
public class RealmSpotType: Object {

    @objc dynamic var SpotType = 0
    
    @objc dynamic var SpotName = ""
}

// MARK: Realm Spot
public class RealmSpot: Object {
 
    @objc dynamic var Id = UUID().uuidString
 
    @objc dynamic var UserId = 0
 
    @objc dynamic var Lat = ""
 
    @objc dynamic var Long = ""
 
    @objc dynamic var Visibility = 0
 
    @objc dynamic var State = 0
 
    @objc dynamic var Name = ""
 
    @objc dynamic var Description = ""
 
    @objc dynamic var SharedToFacebook = false
    
    let spotTypes = List<RealmSpotType>()
    
    let images = List<RealmImage>();
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
 
 }









