//
//  ProfileViewController.swift
//  Spots
//
//  Created by Alexander Grach on 3/31/18.
//  Copyright © 2018 goodbox. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import AlamofireImage
import FacebookCore
import FacebookLogin

class ProfileViewController : UITableViewController {
 
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var imgGroupAdd: UIImageView!
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var imgBookmark: UIImageView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTabBarItem()
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad();
        
        vHeader.backgroundColor = UIColor.spotsGreen()
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.width/2
        self.imgProfilePic.layer.masksToBounds = true
        self.imgProfilePic.layer.borderColor = UIColor.white.cgColor
        self.imgProfilePic.layer.borderWidth = 2
        
        
        self.imgGroupAdd.image = UIImage(named: "ic_group_add_white_18pt")?.tint(with: Color.grey.darken1)
        self.imgLock.image = UIImage(named: "ic_lock_white_18pt")?.tint(with: Color.grey.darken1)
        self.imgBookmark.image = UIImage(named: "ic_bookmark")?.tint(with: Color.grey.darken1)
        
        if let userId = UserDefaults.FacebookUserId {
            
            let profilePicUrl = "https://graph.facebook.com/v2.8/" + userId + "/picture?type=large"
            
            self.imgProfilePic.af_setImage(
                withURL: URL(string: profilePicUrl)!,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.row) {
            
        case 0 :
            let textToShare = "Find and share dispersed and reserved campspots privately with your friends!"
            if let myWebsite = NSURL(string: "https://goodspotsapp.com/") {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
                //
                
                activityVC.popoverPresentationController?.sourceView = tableView
                
                present(activityVC, animated: true) { }
            }
            
        case 1:
            
            self.performSegue(withIdentifier: "BookmarksSegue", sender: self)
            
        case 2:
            let loginManager = LoginManager()
            
            loginManager.logOut()
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        default:
            print("nothing selected")
        }
    }
    
    private func showShareDialog() {
        
    }
    
    private func prepareTabBarItem() {
        tabBarItem.title = nil
        tabBarItem.image = SpotIcons.person?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = SpotIcons.person?.tint(with: UIColor.spotsGreen())
        tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
    }
}
