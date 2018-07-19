//
//  PhotosContainerViewController.swift
//  Spots
//
//  Created by goodbox on 4/19/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialPalettes
// import AXPhotoViewer

class PhotosContainerViewController : UIViewController {
  
  
    @IBOutlet weak var cvPhotos: UICollectionView!
  
    var didTapPhotoDelegate: DidTapFacilityImageDelegate!
    
    var images: [FacilityMedia] = []
  
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
    
   return self.images.count
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: true)
    
    print("didSelectItem : \(indexPath.row)")
    
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                  for: indexPath) as! FacilityImageCell
    
    cell.configure(self.images[indexPath.row].Url)
    
    return cell
    
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PhotosContainerViewController : UICollectionViewDelegateFlowLayout {
  
  public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath)
    
    cell?.backgroundColor = MDCPalette.grey.tint600
  }
  
  public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath)
    
    cell?.backgroundColor = UIColor.clear
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: false)
    
    print("did select photo : \(indexPath.row)")
    
    guard let selectedCell = collectionView.cellForItem(at: indexPath) as? FacilityImageCell else {
        return
    }
    
    self.didTapPhotoDelegate.didTapFacilityImage(self, index: indexPath.row, imageCell: selectedCell)
    
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = (availableWidth / itemsPerRow)
    
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



