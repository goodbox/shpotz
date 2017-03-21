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
  
  
  // spots api
  typealias PostSpotCompletionUserFunc = (_ success: Bool, _ spot: SpotsModel?, _ error: NSError?) -> Void
  
  func performPostSpot(_ authToken: String, spotsModel: SpotsModel, completion: @escaping PostSpotCompletionUserFunc) -> Void {
    
  }
  
}
