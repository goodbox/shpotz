//
//  ApiServiceTaskFactory.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation


extension ApiServiceTask {

  static func CreatePostSpotTask(_ accessToken: String, spotsModel: SpotsModel) -> ApiServiceTask {
  
    let serviceUrl = "/api/spots";
    
    let headerParams = spotsModel.encodeToDictionary();
    
    return ApiServiceTask(serviceMethod: .POST, serviceUrl: serviceUrl, urlParameters: nil, headerParameters: headerParams, authToken: accessToken)
  }
}
