//
//  PhotosContainerViewController.swift
//  Spots
//
//  Created by goodbox on 4/19/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material

class PhotosContainerViewController : UIViewController {
  
  
  @IBOutlet weak var cvPhotos: UICollectionView!
  
  var didTapPhotoDelegate: DidTapFacilityImageDelegate!
  
  var facilityDetail: FacilityDetail!
  
  fileprivate let cellResuseIdenitfier = "FacilityImageCell"
  fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  
  fileprivate let itemsPerRow: CGFloat = 3
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    cvPhotos.dataSource = self
    cvPhotos.delegate = self
    
    cvPhotos.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
  }
  
  
  
}


// MARK: UICollectionViewDataSource
extension PhotosContainerViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if self.facilityDetail != nil && self.facilityDetail.Media != nil && self.facilityDetail.Media.count > 0 {
      return self.facilityDetail.Media.count
    }
    
    return 0 // self.facilityDetail.Media.count
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: true)
    
    print("didSelectItem : \(indexPath.row)")
    
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                  for: indexPath) as! FacilityImageCell
    
    
    cell.configure(self.facilityDetail.Media[indexPath.row].Url)
    
    
    // cell.configure(self.activityName[indexPath.row])
    // Configure the cell
    return cell
    
  }
}



// MARK: UICollectionViewDelegateFlowLayout
extension PhotosContainerViewController : UICollectionViewDelegateFlowLayout {
  
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
    
    print("did select photo : \(indexPath.row)")
    
    self.didTapPhotoDelegate.didTapFacilityImage(self, index: indexPath.row)

    
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



