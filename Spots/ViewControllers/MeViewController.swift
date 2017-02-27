//
//  MeViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material

class MeViewController: UIViewController {
  
  @IBOutlet weak var btnSettings: UIBarButtonItem!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareTabBarItem()
    
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    btnSettings.image = Icon.settings?.tint(with: UIColor.white)
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
    tabBarItem.image = Icon.person?.tint(with: Color.blueGrey.base)
    tabBarItem.selectedImage = Icon.person?.tint(with: UIColor.spotsGreen())
  }
}
