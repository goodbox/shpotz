//
//  SelectSpotTypeCell.swift
//  Spots
//
//  Created by goodbox on 3/6/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

public class SelectSpotTypeCell: UICollectionViewCell {
  
  @IBOutlet weak var lblSpotType: UILabel!
  @IBOutlet weak var imgSpotType: UIImageView!
  @IBOutlet weak var imgSpotIcon: UIImageView!

  
  func configure(_ spotType: String) {
    
    lblSpotType.text = spotType
    
    imgSpotType.backgroundColor = MDCPalette.grey.tint300
    
    imgSpotType.layer.cornerRadius = imgSpotType.layer.frame.width/2
    
    imgSpotType.layer.masksToBounds = true
    
    imgSpotIcon.contentMode = .scaleAspectFit
    
    switch spotType {
    case "Diving":
        imgSpotIcon.image = SpotIcons.diving//? .tint(with: MDCPalette.grey.tint600)
    case "Camping":
      imgSpotIcon.image = SpotIcons.camping//?.tint(with: MDCPalette.grey.tint600)
    case "Fishing":
      imgSpotIcon.image = SpotIcons.fishing//?.tint(with: MDCPalette.grey.tint600)
    case "Hiking":
      imgSpotIcon.image = SpotIcons.hiking//?.tint(with: MDCPalette.grey.tint600)
    case "Rock Climbing":
      imgSpotIcon.image = SpotIcons.rockclimbing//?.tint(with: MDCPalette.grey.tint600)
    case "Mtn Biking":
      imgSpotIcon.image = SpotIcons.mtnbiking//?.tint(with: MDCPalette.grey.tint600)
    case "Ice Climbing":
      imgSpotIcon.image = SpotIcons.iceclimbing//?.tint(with: MDCPalette.grey.tint600)
    case "Rafting":
      imgSpotIcon.image = SpotIcons.rafting//?.tint(with: MDCPalette.grey.tint600)
    case "Canoeing":
      imgSpotIcon.image = SpotIcons.canoeing//?.tint(with: MDCPalette.grey.tint600)
    case "Surfing":
      imgSpotIcon.image = SpotIcons.surfing//?.tint(with: MDCPalette.grey.tint600)
    case "Swimming":
      imgSpotIcon.image = SpotIcons.swimming//?.tint(with: MDCPalette.grey.tint600)
    case "Hot Springs":
      imgSpotIcon.image = SpotIcons.hottub//?.tint(with: MDCPalette.grey.tint600)
    case "Beach":
      imgSpotIcon.image = SpotIcons.beach//?.tint(with: MDCPalette.grey.tint600)
    default:
      imgSpotIcon.image = SpotIcons.other//?.tint(with: MDCPalette.grey.tint600)
    }
  }
  
}
