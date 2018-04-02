//
//  InfoViewController.swift
//  Spots
//
//  Created by Alexander Grach on 3/31/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController : UITableViewController {
    
    
    @IBOutlet weak var imgDispersedCamping: UIImageView!
    
    @IBOutlet weak var imgReservedCamping: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgReservedCamping.image = UIImage(named: "ic_place_white-1")?.tint(with: UIColor.totesBlueColor())
        
        imgDispersedCamping.image = UIImage(named: "ic_place_white-1")?.tint(with: UIColor.totesGreenColor())
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
}
