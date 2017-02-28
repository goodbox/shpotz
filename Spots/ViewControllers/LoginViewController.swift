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
  
  @IBOutlet weak var btnLogin: ActivityIndicatorRaisedButton!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    /*
    // if the token exists, use it to get the current user
    if let accessToken = FBSDKAccessToken.current() {
      // User is logged in, use 'accessToken' here.
      
      
      
    }
     */
    
  }
  
  @IBAction func btnLoginTapped(_ sender: Any) {
    
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()

    
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
