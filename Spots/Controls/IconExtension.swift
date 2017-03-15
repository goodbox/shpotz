//
//  IconExtension.swift
//  Spots
//
//  Created by goodbox on 2/27/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import Material

public struct SpotIcons {
  
  /// Get the icon by the file name.
  public static func icon(_ name: String) -> UIImage? {
    
    return UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
  }
  
  public static let person = SpotIcons.icon("ic_person_white")
  
  public static let world = SpotIcons.icon("ic_public_white")
  
  public static let diving = SpotIcons.icon("diving_image")
  
  public static let camping = SpotIcons.icon("camping_image")
  
  public static let fishing = SpotIcons.icon("fishing_image")
  
  public static let hiking = SpotIcons.icon("hiking_image")
  
  public static let iceclimbing = SpotIcons.icon("iceclimbing_image")
  
  public static let mtnbiking = SpotIcons.icon("mtnbiking_image")
  
  public static let rafting = SpotIcons.icon("rafting_image")
  
  public static let rockclimbing = SpotIcons.icon("rockclimbing_image")
  
  public static let surfing = SpotIcons.icon("surfing_image")
  
  public static let swimming = SpotIcons.icon("swimming_image")
  
  public static let other = SpotIcons.icon("other_image")
}
