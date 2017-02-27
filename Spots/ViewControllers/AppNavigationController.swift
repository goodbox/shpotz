//
//  AppNavigationController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation

import UIKit
import Material

class AppNavigationController: NavigationController {
  open override func prepare() {
    super.prepare()
    guard let v = navigationBar as? NavigationBar else {
      return
    }
    
    v.depthPreset = .none
    v.dividerColor = Color.grey.lighten3
  }
}
