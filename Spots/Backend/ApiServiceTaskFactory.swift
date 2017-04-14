//
//  ApiServiceTaskFactory.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation


extension ApiServiceTask {
  
  static func CreateLoginTask(_ fbAccessToken: String) -> ApiServiceTask {
    
    let serviceUrl = "/api/account/fbAuth"
    let headerParameters = ["fbAccessToken": fbAccessToken]

    return ApiServiceTask(serviceMethod: .POST, serviceUrl: serviceUrl, urlParameters: nil, headerParameters: headerParameters as [String : AnyObject]?, authToken: nil)
  }

  static func CreatePostSpotTask(_ accessToken: String, spotsModel: SpotsModel) -> ApiServiceTask {
  
    let serviceUrl = "/api/spots";
    
    let headerParams = spotsModel.encodeToDictionary();
    
    return ApiServiceTask(serviceMethod: .POST, serviceUrl: serviceUrl, urlParameters: nil, headerParameters: headerParams, authToken: accessToken)
  }
  
  static func GetSpots(_ accessToken: String, bllat: String, bllong: String, brlat: String, brlong: String,
                       fllat: String, fllong: String, frlat: String, frlong: String) -> ApiServiceTask {
    
    let serviceUrl = "/api/spots/bllat/" + bllat + "/bllong/" + bllong + "/brlat/" + brlat + "/brlong/" + brlong + "/fllat/" + fllat +
      "/fllong/" + fllong + "/frlat/" + frlat + "/frlong/" + frlong + "/"
    
    return ApiServiceTask(serviceMethod: .GET, serviceUrl: serviceUrl, urlParameters: nil, headerParameters: nil, authToken: accessToken)
  }
  
  static func GetFacility(_ accessToken: String, facilityId: String) -> ApiServiceTask {
    
    let serviceUrl = "/api/spots/facility/" + facilityId
    
    return ApiServiceTask(serviceMethod: .GET, serviceUrl: serviceUrl, urlParameters: nil, headerParameters: nil, authToken: accessToken)
  }
}
