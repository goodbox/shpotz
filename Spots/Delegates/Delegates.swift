//
//  Delegates.swift
//  Spots
//
//  Created by goodbox on 3/2/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation

protocol DidTapAddPhotoButtonDelegate {
  func didTapAddPhoto(_ sender: Any?, numToAdd: Int?)
}

protocol DidSelectSpotTypeDelegate {
  func didSelectSpotType(_sender: Any?, spotType: String?)
}
