//
//  MapViewController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material
import GoogleMaps

class MapContainerViewController: UIViewController {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareTabBarItem()
    
  }
  
  
  @IBOutlet weak var btnAdd: FabButton!
  
  open override func viewDidLoad() {
    super.viewDidLoad()
  
    prepareAddButton()
    
  }
  
  @IBAction func btnAddTapped(_ sender: Any) {
    
    self.performSegue(withIdentifier: "PostLocationSegue", sender: self)
  
  }
  
  private func prepareAddButton() {
    btnAdd.layer.shadowColor = UIColor.black.cgColor
    btnAdd.layer.shadowOffset = CGSize(width: 0, height: 2)
    btnAdd.layer.shadowRadius = 2
    btnAdd.layer.shadowOpacity = 0.4
    btnAdd.setImage(Icon.add?.tint(with: Color.white), for: .normal)
    
  }
  
  private func prepareTabBarItem() {
    tabBarItem.title = nil
    tabBarItem.image = Icon.world?.tint(with: Color.blueGrey.base)
    tabBarItem.selectedImage = Icon.world?.tint(with: UIColor.spotsGreen())
  }
}
