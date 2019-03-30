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
import MaterialComponents.MaterialPalettes
import PopupDialog
import MaterialComponents.MDCButton

public class LoginViewController : UIViewController, DidCancelNoNetworkSaveDelegate, DidCloseNewUserScreenDelegate {
  
    @IBOutlet weak var btnLogin: MDCRaisedButton!
  
    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
  
    var readPermissions: [ReadPermission] = [.publicProfile, .email, .userFriends]
  
    // var tryLogin: Bool = false
    
    var showHelp: Bool = false
    
    var setAsRoot: Bool = false
    
    let reachability = Reachability()!
    
    public override func viewDidLoad() {
    
        super.viewDidLoad()
    
        imgLogo.image = UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500)
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.layer.masksToBounds = true
    
        lblAppTitle.font = UIFont(name:"Roboto-Light", size: 50)!
        
        if setAsRoot == true {
            self.view.window?.rootViewController = self
        }
        
        btnLogin.originalButtonText = "Login via Facebook"
        
        UserDefaults.TryLogin = true
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
       
        if(segue.identifier == "ShowPostSpotSegue") {
        
            let destinationVC = segue.destination as! UINavigationController
            let postVC = destinationVC.topViewController as! PostViewController
            postVC.didCancelNoNetworkSaveDelegate = self
            postVC.showNoNetworkModal = true
            
        } else if(segue.identifier == "LoginSegue") {
            
            if self.showHelp {
                let destinationVC = segue.destination as! UITabBarController
                let navVC = destinationVC.viewControllers![0] as! UINavigationController
                let mapVC = navVC.topViewController as! MapContainerViewController
                mapVC.showHelpTip = true
            }
        }
    }
  
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.TryLogin! {
        
            self.btnLogin.isEnabled = false
        
            self.btnLogin.showLoading()
            
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
                print("REACHABILITY : \(reachability.connection)")
                
            } catch {
                print("Unable to start notifier")
            }
        } else {
            
            self.btnLogin.isEnabled = true
            
            self.btnLogin.hideLoading()
        }
    }
  
    public func loginViaFacebook() {
        
        UserDefaults.TryLogin = true
        
        self.btnLogin.isEnabled = false
        
        self.btnLogin.showLoading(UIColor.totesMidnightBlue())
        
        let loginManager = LoginManager(loginBehavior: .native, defaultAudience: .friends)
        
        loginManager.logIn(readPermissions: readPermissions, viewController: self) { (loginResult) in
            
            switch loginResult {
                
            case .failed(let error):
                
                // TODO: log error maybe
                
                self.btnLogin.hideLoading()
                
                self.btnLogin.isEnabled = true
                
                UserDefaults.TryLogin = false
                
            case .cancelled:
                
                self.btnLogin.hideLoading()
                
                self.btnLogin.isEnabled = true
                
                UserDefaults.TryLogin = false
                
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
                            
                            UserDefaults.SpotsToken = loginModel?.BearerToken
                            
                            self.performSegue(withIdentifier: "LoginSegue", sender: self)
  
                            /*
                             if (loginModel?.IsNewUser)! {
                             
                             // show welcome screen
                             self.performSegue(withIdentifier: "NewUserSegue", sender: self)
                             
                             } else {
                             
                             self.performSegue(withIdentifier: "LoginSegue", sender: self)
                             }
                             */
                        } else {
                            
                            // TODO: modal to say there was an error
                            self.showValidationPopup(theTitle: "Login failed", theMessage: "An error occurred logging in with Facebook.")
                            
                        }
                    })
                }
            }
        }
    }
  
    @IBAction func btnLoginTapped(_ sender: Any) {
    
        //declare this property where it won't go ou dt of scope relative to your listener
        
         if reachability.connection == .wifi || reachability.connection == .cellular {
             self.loginViaFacebook()
        } else {
            self.performSegue(withIdentifier: "ShowPostSpotSegue", sender: self)
        }
    }	
  
    func showValidationPopup(theTitle: String?, theMessage: String?) {
    
        let popup = PopupDialog(title: theTitle, message: theMessage, image: nil, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
    
        let buttonOne = DefaultButton(title: "Dismiss") {
            self.btnLogin.isEnabled = true
            self.btnLogin.hideLoading()
        }
    
        popup.addButton(buttonOne)
    
        self.present(popup, animated: true, completion: nil)
    }
    
    func didTapCloseNoNetowrk(_ sender: Any?) {
        
        self.btnLogin.hideLoading()
        
        self.btnLogin.isEnabled = true
        
        UserDefaults.TryLogin = false
    }
    
    func didCloseNewUserScree(_ sender: Any?) {
        UserDefaults.TryLogin = false
        self.showHelp = true
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
}


