//
//  UserSettingsViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit


public class UserSettingsViewController : UITableViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Settings"
    
    self.tableView.separatorStyle = .none
    
    self.tableView.backgroundColor = UIColor.lightGray
  }
  
}
