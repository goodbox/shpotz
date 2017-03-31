//
//  ApiServiceController.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import SwiftyJSON

// Manage all the ApiService calls
// User will performs ApiService operations using the Controller
// Components like UIControllers will interact with this

class ApiServiceController {
  
  static let sharedInstance = ApiServiceController()
  
  // Perform Task
  
  // Task's details ??
  
  // log the operations
  
  typealias CompletionFunc = (_ success: Bool, _ error: Error?) -> Void
  
  
  enum TaskLogItemState {
    case none, inProgress, success, failure
  }
  
  struct TaskLogItem {
    let dateStamp: Date
    var success: Bool = false
  }
  
  // account api
  typealias CompletionUserFunc = (_ success: Bool, _ user: LoginModel?, _ error: NSError?) -> Void
  
  
  func performFbAuth(_ fbAccessToken: String, completion: @escaping CompletionUserFunc) -> Bool {
    
    let task = ApiServiceTask.CreateLoginTask(fbAccessToken)
    
    _ = task.performTask { (success, json, headerFields, error) in
      
      if error != nil {
        completion(false, nil, error)
        return
      }
     
      if success {
        
        let loginModel = LoginModel(json: json!)
        
        completion(success, loginModel, nil)
        
      } else {
        completion(false, nil, nil)
      }
      
    }
    
    return true
  }
  
  // spots api
  typealias PostSpotCompletionUserFunc = (_ success: Bool, _ spot: SpotsModel?, _ error: NSError?) -> Void
  
  func performPostSpot(_ authToken: String, spotsModel: SpotsModel, completion: @escaping PostSpotCompletionUserFunc) -> Bool {
   
    let task = ApiServiceTask.CreatePostSpotTask(authToken, spotsModel: spotsModel)
    
    _ = task.performTask({ (success, json, headerFields, error) in
      
      if error != nil {
        completion(false, nil, error)
        return
      }
      
      if success {
        
        let spot = SpotsModel(json: json!)
        
        completion(success, spot, nil)
        
      } else {
        completion(success, nil, nil)
      }
      
    })
    
    return true
  }
  
  typealias GetSpotsCompletionFunc = (_ success: Bool, _ spots: [SpotsModel]?, _ error: NSError?) -> Void
  
  func getSpots(_ accessToken: String, bllat: String, bllong: String, brlat: String, brlong: String,
                fllat: String, fllong: String, frlat: String, frlong: String, completion: @escaping GetSpotsCompletionFunc) -> Bool {
    
    let task = ApiServiceTask.GetSpots(accessToken, bllat: bllat, bllong: bllong, brlat: brlat, brlong: brlong, fllat: fllat, fllong: fllong, frlat: frlat, frlong: frlong)
    
    _ = task.performTask({ (success, json, headerFields, error) in
      
      if error != nil {
        completion(false, nil, error)
        return
      }
      
      if success {
        
        var spots: [SpotsModel]! = []
        
        for(_, subJson):(String, JSON) in json! {
          
          let spot = SpotsModel(json: subJson)
          
          spots.append(spot)
          
        }
        
        completion(success, spots, nil)
        
      } else {
        completion(success, nil, nil)
      }
      
    })
    
    return true
  }
}
