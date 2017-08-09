//
//  PhotoGalleryViewController.swift
//  Spots
//
//  Created by goodbox on 4/29/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryViewController: UIViewController {
  
  @IBOutlet weak var cvPhotos: UICollectionView!
  
  
  
  
  var facilityDetail: FacilityDetail!
  
  
  
  @IBOutlet weak var didDismiss: UIBarButtonItem!
  @IBAction func didTapDismiss(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.black
    
    self.navigationController?.navigationBar.barTintColor = UIColor.black
    
    
    cvPhotos.delegate = self
    cvPhotos.dataSource = self
    
  }
}


extension PhotoGalleryViewController: UICollectionViewDataSource {
 
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
    
    return UICollectionViewCell()
  }

  
}


extension PhotoGalleryViewController : UICollectionViewDelegateFlowLayout {

}
