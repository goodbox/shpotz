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
import MaterialComponents
import PopupDialog
import Reachability

public class LoginViewController : UIViewController, DidCancelNoNetworkSaveDelegate {
    
    
    func didTapCloseNoNetowrk(_ sender: Any?) {
        
        self.btnLogin.hideLoading()
        
        self.btnLogin.isEnabled = true
        
        self.tryLogin = false
    }
  
    @IBOutlet weak var btnLogin: MDCRaisedButton!
  
    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
  
    
    var readPermissions: [ReadPermission] = [.publicProfile, .email, .userFriends]
  
    var tryLogin: Bool = true
    
    public override func viewDidLoad() {
    
        super.viewDidLoad()
    
        imgLogo.image = UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500)
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.layer.masksToBounds = true
    
        lblAppTitle.font = UIFont(name:"Roboto-Light", size: 50)!
    }
    
    public func loadReachableScreen() {
        
        if let accessToken = AccessToken.current {
            
            let api = ApiServiceController.sharedInstance
            
            _ = api.performFbAuth(accessToken.authenticationToken, completion: { (success, loginModel, error) in
                
                if success {
                    
                    UserDefaults.SpotsToken = loginModel?.BearerToken
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                    
                } else {
                    
                    // TODO: modal to say there was an error
                    
                }
            })
            
            
        } else {
            self.btnLogin.isEnabled = true
            
            self.btnLogin.hideLoading()
        }
        
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier == "NoNetworkSegue") {
        
            let destinationVC = segue.destination as! UINavigationController
            let noNetworkVC = destinationVC.topViewController as! NoNetworkViewController
            noNetworkVC.didCancelNoNetworkSaveDelegate = self
        }
    }
  
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        if self.tryLogin {
        
        
            self.btnLogin.isEnabled = false
        
            self.btnLogin.showLoading()
        
            //declare this property where it won't go ou d     t of scope relative to your listener
            let reachability = Reachability()!
        
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi || reachability.connection == .cellular {
                    self.loadReachableScreen()
                } else {
                    self.performSegue(withIdentifier: "ShowPostSpotSegue", sender: self)
                }
            }
            reachability.whenUnreachable = { _ in
                self.performSegue(withIdentifier: "ShowPostSpotSegue", sender: self)
            }
        
       
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
  
  
    @IBAction func btnLoginTapped(_ sender: Any) {
    
        self.tryLogin = true
    
        self.btnLogin.isEnabled = false
    
        self.btnLogin.showLoading()

        let loginManager = LoginManager(loginBehavior: .native, defaultAudience: .friends)
    
        loginManager.logIn(readPermissions: readPermissions, viewController: self) { (loginResult) in
      
            switch loginResult {
        
            case .failed(let error):
        
                // TODO: log error maybe
        
                self.btnLogin.hideLoading()
    
                self.btnLogin.isEnabled = true
        
            case .cancelled:
        
                self.btnLogin.hideLoading()
      
                self.btnLogin.isEnabled = true
        
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
        
                self.btnLogin.isEnabled = false
        
                self.btnLogin.showLoading()
        
                if declinedPermissions.contains("email") {
          
                    // show popup dialog saying email is required
                    self.showValidationPopup(theTitle: "Email is Required", theMessage: "Email is required to use this app.")
        
                } else if declinedPermissions.contains("user_friends") {
          
                    // show popup dialog saying friends list is required
                    self.showValidationPopup(theTitle: "Friends List is Required", theMessage: "Friends List is required to use this app.")
          
                } else {
          
                    UserDefaults.FacebookUserId = accessToken.userId
          
                    UserDefaults.FacebookAuthToken = accessToken.authenticationToken
          
                    // authenticate user against spot api
                    let api = ApiServiceController.sharedInstance
          
                    _ = api.performFbAuth(accessToken.authenticationToken, completion: { (success, loginModel, error) in
            
                        if success {
                            
                            if (loginModel?.IsNewUser)! {
                                
                                // show welcome screen
                                
                            } else {
                                UserDefaults.SpotsToken = loginModel?.BearerToken
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                            }
                        } else {
              
                            // TODO: modal to say there was an error
                            self.showValidationPopup(theTitle: "Login failed", theMessage: "An error occurred logging in with Facebook.")
              
                        }
                    })
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

