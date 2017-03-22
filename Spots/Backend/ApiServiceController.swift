//
//  ApiServiceController.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation

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
}
