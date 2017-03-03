//
//  UserSettingsViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin

public class UserSettingsViewController : UITableViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Settings"
    
    // self.tableView.separatorStyle = .none
    
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    self.tableView.deselectRow(at: indexPath, animated: true)
    
    switch(indexPath.section) {
      
    case 0 :
      print("selected 1")
    case 1:
      print("selected 2")
    case 2:
      print("logout")
      
      let loginManager = LoginManager()
      
      loginManager.logOut()
      
     self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
      
    default:
      print("nothing selected")
    }
  }
}
