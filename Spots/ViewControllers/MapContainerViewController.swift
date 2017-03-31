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
  
  var mapViewController: MapViewController!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareTabBarItem()
    
  }
    
  @IBOutlet weak var btnAdd: FABButton!
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepareAddButton()
  }
  
  @IBAction func btnAddTapped(_ sender: Any) {
    
    self.performSegue(withIdentifier: "PostLocationSegue", sender: self)
  
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SpotsMapSegue" {
      
      if let vc = segue.destination as? MapViewController {
        
        vc.didSelectMapMarkerDelegate = self
        
        self.mapViewController = vc
      }
    } else if segue.identifier == "SpotDetailSegue" {
      
       self.navigationItem.backBarButtonItem = SimpleBackUIBarButton()
      
    }
  }
  
  private func prepareAddButton() {
    btnAdd.layer.shadowColor = UIColor.black.cgColor
    btnAdd.layer.shadowOffset = CGSize(width: 0, height: 2)
    btnAdd.layer.shadowRadius = 2
    btnAdd.layer.shadowOpacity = 0.4
    btnAdd.layer.cornerRadius = btnAdd.frame.width/2
    btnAdd.setImage(Icon.add?.tint(with: Color.white), for: .normal)
    
  }
  
  private func prepareTabBarItem() {
    tabBarItem.title = nil
    tabBarItem.image = SpotIcons.world?.tint(with: Color.blueGrey.base)
    tabBarItem.selectedImage = SpotIcons.world?.tint(with: UIColor.spotsGreen())
  }
}


extension MapContainerViewController : DidSelectMapMarkerDelegate {
  
  func didSelectMapMarker(_sender: Any?) {
    
    performSegue(withIdentifier: "SpotDetailSegue", sender: self)
    
  }
}

