//
//  SelectSpotTypeCell.swift
//  Spots
//
//  Created by goodbox on 3/6/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material


public class SelectSpotTypeCell: UICollectionViewCell {
  
  @IBOutlet weak var lblSpotType: UILabel!
  @IBOutlet weak var imgSpotType: UIImageView!
  @IBOutlet weak var imgSpotIcon: UIImageView!

  
  func configure(_ spotType: String) {
    
    lblSpotType.text = spotType
    
    imgSpotType.backgroundColor = Color.grey.lighten3
    
    imgSpotType.layer.cornerRadius = imgSpotType.layer.width/2
    
    imgSpotType.masksToBounds = true
    
    imgSpotIcon.contentMode = .scaleAspectFit
    
    switch spotType {
    case "Diving":
      imgSpotIcon.image = SpotIcons.diving?.tint(with: Color.grey.darken3)
    case "Camping":
      imgSpotIcon.image = SpotIcons.camping?.tint(with: Color.grey.darken3)
    case "Fishing":
      imgSpotIcon.image = SpotIcons.fishing?.tint(with: Color.grey.darken3)
    case "Hiking":
      imgSpotIcon.image = SpotIcons.hiking?.tint(with: Color.grey.darken3)
    case "Rock Climbing":
      imgSpotIcon.image = SpotIcons.rockclimbing?.tint(with: Color.grey.darken3)
    case "Mtn Biking":
      imgSpotIcon.image = SpotIcons.mtnbiking?.tint(with: Color.grey.darken3)
    case "Ice Climbing":
      imgSpotIcon.image = SpotIcons.iceclimbing?.tint(with: Color.grey.darken3)
    case "Rafting":
      imgSpotIcon.image = SpotIcons.rafting?.tint(with: Color.grey.darken3)
    case "Surfing":
      imgSpotIcon.image = SpotIcons.surfing?.tint(with: Color.grey.darken3)
    case "Swimming":
      imgSpotIcon.image = SpotIcons.swimming?.tint(with: Color.grey.darken3)
    case "Canoeing":
      imgSpotIcon.image = SpotIcons.other?.tint(with: Color.grey.darken3)
    case "Hot Springs":
      imgSpotIcon.image = SpotIcons.other?.tint(with: Color.grey.darken3)
    case "Beach":
      imgSpotIcon.image = SpotIcons.other?.tint(with: Color.grey.darken3)
    default:
      imgSpotIcon.image = SpotIcons.other?.tint(with: Color.grey.darken3)
    }
  }
  
}
