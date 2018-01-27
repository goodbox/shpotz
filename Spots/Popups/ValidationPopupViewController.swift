//
//  ValidationPopupViewController.swift
//  Spots
//
//  Created by goodbox on 3/22/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

class ValidationPopupViewController : UIViewController {
  
  @IBOutlet weak var imgValidationImage: UIImageView!
  
  @IBOutlet weak var lblValidationTitle: UILabel!
  
  @IBOutlet weak var lblValidationMessage: UILabel!
  
  @IBOutlet var containerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imgValidationImage.contentMode = .scaleAspectFit
    
    self.imgValidationImage.layer.masksToBounds = true
    
  }
}
