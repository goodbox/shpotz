//
//  AppDelegate.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import AWSCore
import Realm
import RealmSwift
import AWSS3
import Alamofire
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        
        GMSServices.provideAPIKey("AIzaSyBJNy5PDnzKCWq98NzQkuUv-L-1GBRaEPg")
    
        GMSPlacesClient.provideAPIKey("AIzaSyBJNy5PDnzKCWq98NzQkuUv-L-1GBRaEPg")
    
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        UINavigationBar.appearance().barTintColor = UIColor.spotsGreen()
    
        UINavigationBar.appearance().tintColor = UIColor.white
    
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                            identityPoolId:"us-east-1:112f5823-6d50-4575-97e1-9e730158b177")
    
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
    
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    
        AWSLogger.default().logLevel = .verbose
    
        let cacheSizeMemory = 1024 * 1024 * 200
        let cacheSizeDisk = 1024 * 1024 * 200
        let sharedCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: nil)
        URLCache.shared = sharedCache
        
        
        
        
        /*
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print(error)
        }
 */
 
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true)
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        window = UIWindow(frame:UIScreen.main.bounds)
        
        var initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onboardingComplete") {
            initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        window?.rootViewController = initialViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi || reachability.connection == .cellular {
                self.uploadSavedSpots()
                reachability.stopNotifier()
            }
        }
       
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if animated {
            UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window!.rootViewController = rootViewController
        }
    }
    
    func switchViewControllers() {
        
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        self.window?.rootViewController = nav
        
    }
    
    func uploadSavedSpots() {
        let realm = try! Realm()
        
        let realmSpots = realm.objects(RealmSpot.self).filter("State == 0")
        
        for realmSpot in realmSpots {
            
            let id = realmSpot.Id
            
            let spotModel = SpotsModel()
            
            let api = ApiServiceController.sharedInstance
            
            spotModel.Name = realmSpot.Name
            
            spotModel.Description = realmSpot.Description
            
            spotModel.Lat = Double(realmSpot.Lat)
            
            spotModel.Long = Double(realmSpot.Long)
            
            for spotType in realmSpot.spotTypes {
                spotModel.selectedSpotTypes.append(SpotTypeModel(type: SpotsType(rawValue: spotType.SpotType)!, name: spotType.SpotName))
            }
            
            if realmSpot.images.count == 1 {
                spotModel.PhotoUrl1 = uploadImage(img: realmSpot.images[0])
            }
            
            if realmSpot.images.count == 2 {
                spotModel.PhotoUrl1 = uploadImage(img: realmSpot.images[0])
                spotModel.PhotoUrl2 = uploadImage(img: realmSpot.images[1])
            }
            
            if realmSpot.images.count == 3 {
                spotModel.PhotoUrl1 = uploadImage(img: realmSpot.images[0])
                spotModel.PhotoUrl2 = uploadImage(img: realmSpot.images[1])
                spotModel.PhotoUrl3 = uploadImage(img: realmSpot.images[2])
            }
            
            _ = api.performPostSpot(UserDefaults.SpotsToken!, spotsModel: spotModel, completion: { (success, model, error) in
                
                if(error == nil) {
                    
                    if(success) {
                        
                        // update realm object
                        // let savedSpot = realm.objects(RealmSpot.self).filter("Id == \(id)").first
                        let savedSpot = realm.object(ofType: RealmSpot.self, forPrimaryKey: id)
                        try! realm.write {
                            savedSpot?.State = 1
                        }
                        
                    } else {
                        
                        // some other error happened
                        print("an error occurred")
                    }
                    
                } else {
                    
                    // there was some network error or something
                    print("an error occurred")
                    
                }
                
            })
        }
    }
    
    func uploadImage(img: RealmImage?) -> String! {
        
        let uuidFilename = UUID().uuidString + ".jpg"
        
        do {
            
            let uuidPrefix = uuidFilename.substring(to: uuidFilename.index(uuidFilename.startIndex, offsetBy: 4))
            
            let testFileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uuidFilename)
            
            try img?.picture?.write(to: testFileUrl!)
            
            let transferManager = AWSS3TransferManager.default()
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            
            uploadRequest?.bucket = "spots-app-bucket"
            
            uploadRequest?.key = "uploads/" + uuidPrefix + "/" + uuidFilename
            
            uploadRequest?.contentType = "image/jpeg"
            
            uploadRequest?.body = testFileUrl!
            
            transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                        }
                    } else {
                        print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                    }
                    return nil
                }
                
                let uploadOutput = task.result
                
                print("Upload complete for: \(String(describing: uploadRequest?.key))")
                
                // self.showSuccessPopupDialog()
                
                return uuidFilename
            })
            
            return uuidFilename
            
        } catch {
            
            print("other error occurred : \(error)")
            
        }
        
        return ""
    }
}

