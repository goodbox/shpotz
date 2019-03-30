//
//  InfoViewController.swift
//  Spots
//
//  Created by Alexander Grach on 3/31/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialPalettes

class InfoViewController : UITableViewController {
    
    @IBOutlet weak var imgDispersedCamping: UIImageView!
    
    @IBOutlet weak var imgReservedCamping: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgReservedCamping.image = UIImage(named: "reserved_marker")
        
        imgDispersedCamping.image = UIImage(named: "dispersed_marker")
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /*
        if indexPath.section == 1 && indexPath.row == 0 {
            // open email dialog
            let email = "info@goodspotsapp.com"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
 */
    }
}
