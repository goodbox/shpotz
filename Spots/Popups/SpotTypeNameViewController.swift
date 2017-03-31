//
//  SpotTypeNameViewController.swift
//  Spots
//
//  Created by goodbox on 3/24/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material

class SpotTypeNameViewController: UIViewController {
  
  @IBOutlet weak var lblHeader: UILabel!
  
  @IBOutlet var containerView: UIView!
  
  @IBOutlet weak var txtSpotName: TextField!
  
  override func viewDidLoad() {
    
    txtSpotName.placeholder = "Spot Type"
    txtSpotName.detail = "The type of this spot"
    txtSpotName.isClearIconButtonEnabled = false
    
  }
}

