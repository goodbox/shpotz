//
//  InfoViewController.swift
//  Spots
//
//  Created by Alexander Grach on 3/31/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class InfoViewController : UITableViewController {
    
    @IBOutlet weak var imgDispersedCamping: UIImageView!
    
    @IBOutlet weak var imgReservedCamping: UIImageView!
    
    @IBOutlet weak var imgEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgReservedCamping.image = UIImage(named: "ic_place_white-1")?.tint(with: UIColor.totesBlueColor())
        
        imgDispersedCamping.image = UIImage(named: "ic_place_white-1")?.tint(with: UIColor.totesGreenColor())
        
        imgEmail.image = UIImage(named:"ic_email_white")?.tint(with: MDCPalette.grey.tint500)
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            // open email dialog
            let email = "goodspotsapp@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
    }
}
