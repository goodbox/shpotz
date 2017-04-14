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
  
  // @IBOutlet weak var vSpotInfo: UIView!
  
  // @IBOutlet weak var spotInfoTopConstraint: NSLayoutConstraint!
  
  // @IBOutlet weak var btnViewSpot: FABButton!
  
  @IBOutlet weak var btnAdd: FABButton!
  
  // @IBOutlet weak var lblSpotName: UILabel!
  
  var mapViewController: MapViewController!
  
  // var spotInfoIsOpen: Bool = false
  
  var spotsModel: SpotMapModel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareTabBarItem()
    
  }

  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareAddButton()
    
    // prepareViewSpotButton()
    
    // self.vSpotInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapViewSpot(_:))))
    
  }
  
  /*
  func didTapViewSpot(_ sender: UITapGestureRecognizer) {
    
    performSegue(withIdentifier: "SpotDetailSegue", sender: self)
  
  }
 */
  /*
  @IBAction func btnViewSpotTapped(_ sender: Any) {
    
      performSegue(withIdentifier: "SpotDetailSegue", sender: self)
  
  }
 */
  
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
      
      if let vc = segue.destination as? SpotDetailViewController {
        
        vc.spotMapModel = spotsModel
        
        // vc.navigationController?.navigationItem.backBarButtonItem = SimpleBackUIBarButton()
      }
      
    } else if segue.identifier == "FacilityDetailSegue"  {
     
      self.navigationItem.backBarButtonItem = SimpleBackUIBarButton()
      
      if let vc = segue.destination as? FacilityDetailViewController {
        
        vc.spotMapModel = spotsModel
        
        // vc.navigationController?.navigationItem.backBarButtonItem = SimpleBackUIBarButton()
      }
    }
  }
  
  /*
  private func prepareViewSpotButton() {
    
    btnViewSpot.backgroundColor = UIColor.spotsGreen()
    btnViewSpot.layer.cornerRadius = btnViewSpot.frame.width/2
    btnViewSpot.setImage(SpotIcons.arrow_right?.tint(with: Color.white), for: .normal)
    
    
  }
 
 */
  
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
  
  func didSelectMapMarker(_sender: Any?, spot: SpotMapModel) {
    
    // self.lblSpotName.text = spot.Name
    
    spotsModel = spot
    
    if spot.SpotSystemType == SpotsSystemType.facility {
    
        performSegue(withIdentifier: "FacilityDetailSegue", sender: self)
      
    } else if spot.SpotSystemType == SpotsSystemType.goodSpot {
    
      performSegue(withIdentifier: "SpotDetailSegue", sender: self)
    
    }
    
    /*
    if spotInfoIsOpen == false {
      
      self.spotInfoIsOpen = true
    
      UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
        self.spotInfoTopConstraint.constant = 0
        
        self.vSpotInfo.layer.shadowColor = UIColor.black.cgColor
        self.vSpotInfo.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vSpotInfo.layer.shadowRadius = 2
        self.vSpotInfo.layer.shadowOpacity = 0.4
        
        self.view.layoutIfNeeded()
        
        
      }, completion: nil)
      
    }
 */
  }
}

