//
//  ApiServices.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation

open class APIServices {
  
  public enum ReslutType {
    case success(result: NSDictionary?)
    case error(error: NSError)
  }
  
  
  public static let GoodspotsApiErrorDomain = "GoodspotsApiError"
  public static let GoodspotsApiErrorUnknownStatusCode: Int = 0
  
  
  public struct PageDefinition {
    public var currentPage: UInt32 = 0
    public var totalRecords: UInt32?
    public var recordsPerPage: UInt32 = 0
    public var totalPages: UInt32?
    public var sortExpression: String?
    public var sortDirection: String?
    
    init() {
      
    }
    
    init(currentPage: UInt32, recordsPerPage: UInt32) {
      
      self.currentPage = currentPage
      self.recordsPerPage = recordsPerPage
    }
    
    init(resultJsonData: NSDictionary) {
      if let val = resultJsonData["totalRecords"] {
        self.totalRecords = (val as! UInt32)
      }
      if let val = resultJsonData["recordsPerPage"] {
        self.recordsPerPage = (val as! UInt32)
      }
      if let val = resultJsonData["totalPages"] {
        self.totalPages = (val as! UInt32)
      }
      if let val = resultJsonData["currentPage"] {
        self.currentPage = (val as! UInt32)
      }
      if let val = resultJsonData["sortExpression"] {
        self.sortExpression = (val as! String)
      }
      if let val = resultJsonData["sortDirection"] {
        self.sortDirection = (val as! String)
      }
    }
    
    // String format -> "numPerPage={numPerPage}&page={page}"
    public var URLString: String  {
      get {
        return "numPerPage=\(self.recordsPerPage)&page=\(self.currentPage)"
      }
    }
  }
  
}
