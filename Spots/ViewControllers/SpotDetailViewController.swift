//
//  SpotDetailViewController.swift
//  Spots
//
//  Created by goodbox on 3/9/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

public class SpotDetailViewController: UIViewController {
  
  @IBOutlet weak var tblSpotDetail: UITableView!
  
  
  
  
  var facilityDetail: FacilityDetail!
  
  var spotDetail: SpotsModel!
  
  var spotMapModel: SpotMapModel!
  
  var api: ApiServiceController!
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    api = ApiServiceController.sharedInstance
    
    if spotMapModel.SpotSystemType == SpotsSystemType.facility {
   
      loadFacility()
      
    } else if spotMapModel.SpotSystemType == SpotsSystemType.goodSpot {
      
      loadGoodSpot()
      
    }
  }
  
  func loadFacility() {
    
    _ = api.getFacility(UserDefaults.SpotsToken!, facilityId: String(spotMapModel.Id), completion: { (success, facilityDetail, error) in
      
      
    })
    
  }
  
  func loadGoodSpot() {
    
  }
}
