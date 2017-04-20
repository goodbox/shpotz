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
import AlamofireImage


public class FacilityImageCell: UICollectionViewCell {
  
  @IBOutlet weak var imgPhoto: UIImageView!
  
  
  func configure(_ imageUrl: String) {
    
    self.imgPhoto.af_setImage( withURL: URL(string: (imageUrl))!,
                               placeholderImage: nil,
                               filter: nil,
                               imageTransition: .crossDissolve(0.2)
    )
    
  }
  
}
