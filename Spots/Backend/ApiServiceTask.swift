//
//  ApiServiceTask.swift
//  Spots
//
//  Created by goodbox on 3/20/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation



import Foundation
import Alamofire
import SwiftyJSON

// Will perform a singe server api operation
class ApiServiceTask {
  
  enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
  }
  
  var serviceMethod: Method
  
  var serviceUrl: String
  
  var urlParameters: [ String : String ]?
  
  var headerParameters: [ String : AnyObject ]?
  
  var authToken: String?
  
  init( serviceMethod: Method, serviceUrl: String, urlParameters: [ String : String ]?, headerParameters: [ String : AnyObject ]?, authToken: String? )
  {
    self.serviceMethod = serviceMethod
    self.serviceUrl = serviceUrl
    self.urlParameters = urlParameters
    self.headerParameters = headerParameters
    self.authToken = authToken
  }
  
  // TODO: Add methods to get info about request
  
  
  fileprivate var request: Alamofire.Request?
  
  
  var description: String {
    get {
      return "Task \(serviceMethod) \(serviceUrl)"
    }
  }
  
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  func performTask(_ completion: @escaping (_ success: Bool, _ json: JSON?, _ headerFields: [AnyHashable: Any]?, _ error: NSError?) -> Void) -> Bool
  {
    guard serviceUrl.characters.count > 0
      else {
        print("ApiServiceTask.performTask ERROR There is no Service URL String")
        return false
    }
    
    if request != nil {
      print("ApiServiceTask.performTask ERROR Tried to perform a task when there is already a pending request")
      return false
    }
    
    
    // Create full URL
    var url = APIConstants.apiUrl + serviceUrl
    
    if let urlParamStr = generateUrlParameterString() {
      url += urlParamStr
    }
    
    var headers = [ "Content-Type" : "application/json" ]
    if let token = authToken {
      headers[ "Authorization" ] = "Bearer \(token)"
    }
    
    let alamofireMethod = translateMethodType( serviceMethod )
    
    Alamofire.request(url, method: alamofireMethod, parameters: headerParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
      
      print("ApiServiceTask.performTask | \(self.serviceUrl) - Response:\n\(response)\nHeaderFileds: \(response.response?.allHeaderFields))")
      
      // var statusCode : String
      
      /*
       if let httpError = response.result.error {
       let statusCode = httpError.code
       print("status code:\(statusCode)")
       } else { //no errors
       let statusCode = (response.response?.statusCode)!
       print("status code:\(statusCode)")
       }
       
       */
      
      do {
        
        let statusCode = (response.response?.statusCode)!
        
        
        try self.verifyResponse(response);
        
        // check status code
        // if status code is 200 we are all good
        
        if(statusCode == 200) {
          
          let headerFields: [AnyHashable: Any]? = response.response != nil ? response.response!.allHeaderFields : nil
          completion(true, JSON(response.result.value!), headerFields, nil)
          
        } else if(statusCode == 400) {
          
          // bad request
          // model errors
          completion(false, JSON(response.result.value!), nil, nil)
          
        } else if(statusCode == 401) {
          
          // unauthorized
          // invalid access token
          let error = NSError(type: GoodspotsErrorType.unauthorized)
          
          completion(false, JSON(response.result.value!), nil, error)
          
        } else if(statusCode == 404) {
          
          // not found
          // resource not found or maybe
          completion(false, JSON(response.result.value!), nil, nil)
          
        } else if(statusCode == 500) {
          
          let error = NSError(type: GoodspotsErrorType.unknownError)
          
          // internal server error
          completion(false, JSON(response.result.value!), nil, error)
          
        }
        
      }
      catch _ as NSError {
        
        let unknownError = NSError(type: GoodspotsErrorType.unknownError)
        
        completion(false, nil, nil, unknownError)
      }
    }
    
    return true
  }
  
  
  
  // MARK: Private Methods
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  fileprivate func verifyResponse(_ response: DataResponse<Any>) throws
  {
    // Throw system errors
    if let error = response.result.error {
      throw error
    }
    
    /*
     if response.result.isFailure {
     // Else throw api error
     let message = response.result.value?[ "message" ] as? String
     throw CreateAPIError(response.response?.statusCode, message: message)
     }
     
     if response.response == nil {
     // Else throw api error
     let message = response.result.value?[ "message" ] as? String
     throw CreateAPIError(response.response?.statusCode, message: message)
     }
     */
    
    //    guard let urlResponse = response.response
    //      else {
    //        // Else throw api error
    //        let message = response.result.value?[ "message" ] as? String
    //        throw CreateAPIError(response.response?.statusCode, message: message)
    //    }
    
    //    // Check if response is "Okay"
    //    guard urlResponse.statusCode == 200
    //      else {
    //        // Else throw api error
    //        let message = response.result.value?[ "message" ] as? String
    //        throw CreateAPIError(urlResponse.statusCode, message: message)
    //    }
    //
    //    // TODO: Check API Version
    //
    //
    //    // Get BearerAuthToken
    //    if let token = urlResponse.allHeaderFields["BearerAuthToken"] as? String {
    //      return token;
    //    }
    //    return nil;
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  fileprivate func CreateAPIError(_ statusCode: Int?, message: String?) -> NSError
  {
    let code = statusCode != nil ? statusCode! : APIServices.GoodspotsApiErrorUnknownStatusCode
    let message = message != nil ? message! : "No Error Message"
    
    return NSError(domain: APIServices.GoodspotsApiErrorDomain, code: code, userInfo: [ NSLocalizedDescriptionKey : message ] )
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  fileprivate func generateUrlParameterString() -> String?
  {
    if urlParameters != nil {
      let urlParamStr: NSMutableString = "?"
      var urlParamCount = urlParameters!.count
      for (key, value) in urlParameters! {
        urlParamStr.append( "\(key)=\(value)" )
        urlParamCount -= 1
        if urlParamCount > 0 {
          urlParamStr.append("&")
        }
      }
      return String(urlParamStr)
    }
    
    return nil
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  fileprivate func translateMethodType( _ serviceMethod: Method) -> HTTPMethod
  {
    switch serviceMethod {
      
    case .OPTIONS:
      return HTTPMethod.options
      
    case .GET:
      return HTTPMethod.get
      
    case .HEAD:
      return HTTPMethod.head
      
    case .POST:
      return HTTPMethod.post
      
    case .PUT:
      return HTTPMethod.put
      
    case .PATCH:
      return HTTPMethod.patch
      
    case .DELETE:
      return HTTPMethod.delete
      
    case .TRACE:
      return HTTPMethod.trace
      
    case .CONNECT:
      return HTTPMethod.connect
      
    }
  }
  
}
