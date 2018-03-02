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

protocol DidSelectSpotTypesDelegate {
  func didSelectSpotType(_sender: Any?, spotTypes: [SpotTypeModel])
}


protocol DidSelectMapMarkerDelegate {
  func didSelectMapMarker(_sender: Any?, spot: SpotMapModel)
}


protocol DidTapFacilityImageDelegate {
    func didTapFacilityImage(_ sender: Any?, index: Int?, imageCell: FacilityImageCell?)
}

protocol DidCancelNoNetworkSaveDelegate {
    func didTapCloseNoNetowrk(_ sender: Any?)
}
