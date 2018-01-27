//
//  SelectSpotTypeViewController.swift
//  Spots
//
//  Created by goodbox on 3/5/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import PopupDialog

public class SelectSpotTypeViewController : UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
  
  fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
  fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  fileprivate let itemsPerRow: CGFloat = 3
  fileprivate let spotTypes: [String] = ["Camping", "Fishing", "Hiking", "Hot Springs",  "Mtn Biking", "Swimming", "Surfing",
                                         "Rafting", "Canoeing",  "Diving", "Rock Climbing", "Ice Climbing", "Beach", "Other"];
  
  var spotTypeDelegate: DidSelectSpotTypeDelegate!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
    collectionView.dataSource = self
    
    collectionView.delegate = self
    
  }
  
  @IBAction func btnCancelTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}



// MARK: UICollectionViewDataSource
extension SelectSpotTypeViewController: UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return spotTypes.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                  for: indexPath) as! SelectSpotTypeCell
    cell.configure(spotTypes[indexPath.row])
    // Configure the cell
    return cell
    
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SelectSpotTypeViewController : UICollectionViewDelegateFlowLayout {
  
  public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath)
    
    cell?.backgroundColor = MDCPalette.grey.tint400
  }
  
  public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath)
    
    cell?.backgroundColor = UIColor.clear
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: false)
    
    var spotName = spotTypes[indexPath.row]
    
    if spotName == "Other" {
      
      // make them enter the name of the spot
      let spotNameViewController = SpotTypeNameViewController(nibName: "SpotTypeName", bundle: nil)
      
      let popup = PopupDialog(viewController: spotNameViewController, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false) {
        
        // print("validation popup dismissed")
        
      }
      
      let btnCancel = CancelButton(title: "Cancel") {
        //print("validation popup dismissed : Cancel")
      }
      
      let btnOk = DefaultButton(title: "Select", action: { 
        
        let vc = popup.viewController as! SpotTypeNameViewController
        
        if vc.txtSpotName.text! == "" || (vc.txtSpotName.text?.count)! < 2 {
          
          // TODO: figure otu what to do here
          
        } else {
          
          self.dismiss(animated: true, completion: nil)
          
          spotName = (popup.viewController as! SpotTypeNameViewController).txtSpotName.text!
          
          self.spotTypeDelegate.didSelectSpotType(_sender: self, spotType: self.spotTypes[indexPath.row], spotName: spotName)

        }
      })
      
      popup.addButtons([btnCancel, btnOk])
      
      self.present(popup, animated: true, completion: nil)
      
    } else {
    
      dismiss(animated: true, completion: nil)
    
      spotTypeDelegate.didSelectSpotType(_sender: self, spotType: spotTypes[indexPath.row], spotName: spotName)
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem + 20)
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
