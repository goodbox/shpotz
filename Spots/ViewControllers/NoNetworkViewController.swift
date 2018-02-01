//
//  NoNetworkViewController.swift
//  Spots
//
//  Created by goodbox on 8/25/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

class NoNetworkViewController : UIViewController {
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var didCancelNoNetworkSaveDelegate: DidCancelNoNetworkSaveDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
    
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
    
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        
        
        didCancelNoNetworkSaveDelegate.didTapCloseNoNetowrk(self)
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
