//
//  PostViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material

class PostViewController: UIViewController {

  fileprivate var closeButton : IconButton!
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  @IBAction func btnCancelTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
