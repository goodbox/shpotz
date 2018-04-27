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
    
    func configure(_ spotModel: SpotTypeModel) {
        
        lblSpotType.text = spotModel.SpotName
        
        if spotModel.IsSelected {
            imgSpotType.backgroundColor = UIColor.spotsGreen()
        } else {
            imgSpotType.backgroundColor = Color.grey.lighten3
        }
        
        imgSpotType.layer.cornerRadius = imgSpotType.layer.frame.width/2
        
        imgSpotType.layer.masksToBounds = true
        
        imgSpotIcon.contentMode = .scaleAspectFit
        
        switch spotModel.SpotName {
        case "Diving":
            imgSpotIcon.image = SpotIcons.diving?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Camping":
            imgSpotIcon.image = SpotIcons.camping?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Fishing":
            imgSpotIcon.image = SpotIcons.fishing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Hiking":
            imgSpotIcon.image = SpotIcons.hiking?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Rock Climbing":
            imgSpotIcon.image = SpotIcons.rockclimbing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Mtn Biking":
            imgSpotIcon.image = SpotIcons.mtnbiking?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Ice Climbing":
            imgSpotIcon.image = SpotIcons.iceclimbing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Rafting":
            imgSpotIcon.image = SpotIcons.rafting?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Canoeing":
            imgSpotIcon.image = SpotIcons.canoeing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Surfing":
            imgSpotIcon.image = SpotIcons.surfing?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Swimming":
            imgSpotIcon.image = SpotIcons.swimming?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Hot Springs":
            imgSpotIcon.image = SpotIcons.hottub?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Beach":
            imgSpotIcon.image = SpotIcons.beach?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        case "Add Custom":
            imgSpotIcon.image = SpotIcons.add_button?.tint(with: Color.grey.darken3)
        case "Firepit":
            imgSpotIcon.image = SpotIcons.firepit?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        default:
            imgSpotIcon.image = SpotIcons.other?.tint(with: spotModel.IsSelected ? Color.white : Color.grey.darken3)
        }
    }
}
