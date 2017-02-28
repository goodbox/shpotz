//
//  LoginViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import Material

public class LoginViewController : UIViewController {
  
  @IBOutlet weak var btnLogin: RaisedButton!
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()
    
    if let accessToken = AccessToken.current {
      
      // User is logged in, use 'accessToken' here.
      // UserDefaults.FacebookAuthToken = accessToken.authenticationToken
      
      let connection = GraphRequestConnection()
      
      connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
        switch result {
        case .success(let response):
          
          print("Graph Request Succeeded: \(response)")
          
          self.performSegue(withIdentifier: "LoginSegue", sender: self)
        
        case .failed(let error):
          
          print("Graph Request Failed: \(error)")
          
          self.btnLogin.isEnabled = true
          
          self.btnLogin.hideLoading()
        
        }
      }
      connection.start()
    } else {
      self.btnLogin.isEnabled = true
      
      self.btnLogin.hideLoading()
    }
  }
  
  @IBAction func btnLoginTapped(_ sender: Any) {
    
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()

    let loginManager = LoginManager()
    
    loginManager.logIn([.publicProfile, .email, .userFriends], viewController: self) { (loginResult) in
      
      switch loginResult {
        
      case .failed(let error):
        
        print(error)
        
        self.btnLogin.hideLoading()
        
      case .cancelled:
        print("User cancelled login.")
        
        self.btnLogin.hideLoading()
      
      case .success(let grantedPermissions, let declinedPermissions, let accessToken):
        
        print("Logged in!")
        
        UserDefaults.FacebookUserId = accessToken.userId
        
        UserDefaults.FacebookAuthToken = accessToken.authenticationToken
        
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
      
      }
    }
    
    /*
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    fbLoginManager.loginBehavior = FBSDKLoginBehavior.native
    
    fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { (result, error) in
      
      if(error == nil) {
        
        let fbLoginResult : FBSDKLoginManagerLoginResult = result!
        
        let fbAccessToken = fbLoginResult.token.tokenString!
        
        UserDefaults.FacebookAuthToken = fbAccessToken
        
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
      
      } else {
        print("login error")
        self.btnLogin.hideLoading()
        self.btnLogin.isEnabled = true
      }
      
    }
    */
  }
}
