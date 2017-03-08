//
//  SelectSpotTypeCell.swift
//  Spots
//
//  Created by goodbox on 3/6/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit


public class SelectSpotTypeCell: UICollectionViewCell {
  
  @IBOutlet weak var lblSpotType: UILabel!
  @IBOutlet weak var imgSpotType: UIImageView!

  
  func configure(_ spotType: String) {
    
    lblSpotType.text = spotType
    
    imgSpotType.backgroundColor = UIColor.spotsGreen()
    
    imgSpotType.layer.cornerRadius = imgSpotType.layer.width/2
  }
  
}
