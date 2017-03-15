//
//  SelectSpotTypeViewController.swift
//  Spots
//
//  Created by goodbox on 3/5/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material

public class SelectSpotTypeViewController : UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
  
  fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
  fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  fileprivate let itemsPerRow: CGFloat = 3
  fileprivate let spotTypes: [String] = ["Camping", "Fishing", "Hiking", "Rock Climbing", "Mtn Biking",
                                         "Ice Climbing", "Rafting", "Surfing", "Swimming", "Diving", "Other"];
  
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
    
    cell?.backgroundColor = Color.grey.lighten4
  }
  
  public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath)
    
    cell?.backgroundColor = Color.clear
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: false)
    
    dismiss(animated: true, completion: nil)
    
    spotTypeDelegate.didSelectSpotType(_sender: self, spotType: spotTypes[indexPath.row])
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
