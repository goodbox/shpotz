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
    return UIImage(named: name, in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
  }
  
  public static let person = Icon.icon("ic_person_white")
  
  public static let world = Icon.icon("ic_public_white")
}
