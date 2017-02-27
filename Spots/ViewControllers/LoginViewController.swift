//
//  LoginViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Material

public class LoginViewController : UIViewController {
  
  @IBOutlet weak var btnLogin: RaisedButton!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func btnLoginTapped(_ sender: Any) {
    
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    fbLoginManager.loginBehavior = FBSDKLoginBehavior.native
    
    fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { (result, error) in
      
      if(error == nil) {
        
        let fbLoginResult : FBSDKLoginManagerLoginResult = result!
        
        let fbAccessToken = fbLoginResult.token.tokenString!
        
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
      
      } else {
        print("login error")
        self.btnLogin.hideLoading()
        self.btnLogin.isEnabled = true
      }
      
    }
    
  }
}
