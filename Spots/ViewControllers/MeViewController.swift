//
//  MeViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class MeViewController: UIViewController {
  
  @IBOutlet weak var btnSettings: UIBarButtonItem!
  @IBOutlet weak var vHeader: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var imgProfilePic: UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareTabBarItem()
    
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    btnSettings.image = Icon.settings?.tint(with: UIColor.white)
    
    vHeader.backgroundColor = UIColor.spotsGreen() // Color.grey.darken1
    
    self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.width/2
    self.imgProfilePic.layer.masksToBounds = true
    self.imgProfilePic.layer.borderColor = UIColor.white.cgColor
    self.imgProfilePic.layer.borderWidth = 2
    
    
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
  
  @IBAction func btnSettingsTapped(_ sender: Any) {
    
    self.performSegue(withIdentifier: "UserSettingsSegue", sender: self)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if(segue.identifier == "UserSettingsSegue") {
      navigationItem.backBarButtonItem = SimpleBackUIBarButton()
    }
  }
  
  private func prepareTabBarItem() {
    tabBarItem.title = nil
    tabBarItem.image = SpotIcons.person?.tint(with: Color.blueGrey.base)
    tabBarItem.selectedImage = SpotIcons.person?.tint(with: UIColor.spotsGreen())
    
    
  }
}
