//
//  AppBottomNavigationController.swift
//  Spots
//
//  Created by goodbox on 2/26/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import Material


class AppBottomNavigationController: BottomNavigationController {
  open override func prepare() {
    super.prepare()
    prepareTabBar()
  }
  
  private func prepareTabBar() {
    tabBar.depthPreset = .none
    tabBar.dividerColor = Color.grey.lighten3
  }
}
