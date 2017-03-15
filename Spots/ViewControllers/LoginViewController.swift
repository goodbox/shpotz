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
import PopupDialog

public class LoginViewController : UIViewController {
  
  @IBOutlet weak var btnLogin: RaisedButton!
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  
    self.btnLogin.isEnabled = false
    
    self.btnLogin.showLoading()
    
    if let accessToken = AccessToken.current {
      
      // User is logged in, use 'accessToken' here.
      // UserDefaults.FacebookAuthToken = accessToken.authenticationToken
        /*
      UserProfile.loadCurrent({ (userProfile) in
        
        print(UserProfile.current?.profileURL ?? "profile url")
        
      })*/
      
      let connection = GraphRequestConnection()
      
      connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
        switch result {
        case .success(let response):
          
          print("Graph Request Succeeded: \(response)")
          
          let userId = accessToken.userId!
          
          UserDefaults.FacebookUserId = userId
          
          UserDefaults.FacebookAuthToken = accessToken.authenticationToken

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
        
        // TODO: log error maybe
        
        self.btnLogin.hideLoading()
    
        self.btnLogin.isEnabled = true
        
      case .cancelled:
        
        self.btnLogin.hideLoading()
      
        self.btnLogin.isEnabled = true
        
      case .success(let grantedPermissions, let declinedPermissions, let accessToken):
        
        if declinedPermissions.contains("email") {
          
          // show popup dialog saying email is required
          self.showValidationPopup(theTitle: "Email is Required", theMessage: "Email is required to use this app.")
        
        } else if declinedPermissions.contains("user_friends") {
          
          // show popup dialog saying email is required
          self.showValidationPopup(theTitle: "Friends List is Required", theMessage: "Friends List is required to use this app.")
          
        } else {
          
          UserDefaults.FacebookUserId = accessToken.userId
          
          UserDefaults.FacebookAuthToken = accessToken.authenticationToken
          
          // authenticate user against spot api
          
          self.performSegue(withIdentifier: "LoginSegue", sender: self)
          
        }
      }
    }
  }
  
  func showValidationPopup(theTitle: String?, theMessage: String?) {
    
    let popup = PopupDialog(title: theTitle, message: theMessage, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
    
    let buttonOne = DefaultButton(title: "Dismiss") {
      
    }
    
    popup.addButton(buttonOne)
    
    self.present(popup, animated: true, completion: nil)
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

