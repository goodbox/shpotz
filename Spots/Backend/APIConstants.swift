//
//  APIConstants.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation

import Foundation

class APIConstants {
  
    static let transferProtocol = "http://"
  
    #if RELEASE
  
    static let baseUrl = "goodspotsapp.com"
  
    #else
  
    static let baseUrl = "dev.goodspotsapp.com/"
  
    #endif
  
    static var apiUrl: String
    {
        get
        {
            return transferProtocol + baseUrl   
        }
    }
  
}
