//
//  FacilityDetailViewController.swift
//  Spots
//
//  Created by goodbox on 4/13/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import Material
import PopupDialog

public class FacilityDetailViewController: UITableViewController {
  
  
  @IBOutlet weak var vHeader: UIView!
  
  @IBOutlet weak var imgHeaderPic: UIImageView!

  @IBOutlet weak var lblFacilityName: UILabel!
  
  @IBOutlet weak var lblFacilityPhone: UILabel!
  
  @IBOutlet weak var wvDescription: UIWebView!
  
  @IBOutlet weak var cvActivities: UICollectionView!
  
  
  var facilityDetail: FacilityDetail!
  
  var spotMapModel: SpotMapModel!
  
  var api: ApiServiceController!
  
  fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()
    
    api = ApiServiceController.sharedInstance
    
    //wvDescription.delegate = self
    
    // self.tableView.isHidden = true
    
    cvActivities.delegate = self
    cvActivities.dataSource = self
    cvActivities.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
    
    loadFacility()
    
  }
  
  func loadFacility() {
    
    _ = api.getFacility(UserDefaults.SpotsToken!, facilityId: String(spotMapModel.Id), completion: { (success, facilityDetail, error) in
      
      // self.tableView.isHidden = false
      self.facilityDetail = facilityDetail
      
      if self.facilityDetail.Media != nil && self.facilityDetail.Media.count > 0 {
       
        self.imgHeaderPic.af_setImage(
          withURL: URL(string: (self.facilityDetail.Media.first?.Url)!)!,
          placeholderImage: nil,
          filter: nil,
          imageTransition: .crossDissolve(0.2)
        )
      }
      
      self.lblFacilityName.text = self.facilityDetail.Model.Name
      
      self.lblFacilityName.font = UIFont.spotsFacilityName()
      
      self.lblFacilityName.layer.shadowColor = UIColor.black.cgColor
      self.lblFacilityName.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
      self.lblFacilityName.layer.shadowRadius = 0.0
      self.lblFacilityName.layer.shadowOpacity = 1
      
      self.lblFacilityName.textAlignment = NSTextAlignment.left
      self.lblFacilityName.contentMode = UIViewContentMode.bottom

      self.lblFacilityPhone.text = self.facilityDetail.Model.Phone
      
      self.wvDescription.loadHTMLString(self.facilityDetail.Model.Description, baseURL: nil)
      
      if self.facilityDetail.Activities != nil && self.facilityDetail.Activities.count > 0 {
        
        self.cvActivities.reloadData()
        
      }
      
    })
  }
}

// MARK: UICollectionView
extension FacilityDetailViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.facilityDetail.Activities.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                  for: indexPath) as! SelectSpotTypeCell
    // cell.configure(spotTypes[indexPath.row])
    // Configure the cell
    return cell
    
  }
}



// MARK: UICollectionViewDelegateFlowLayout
extension FacilityDetailViewController : UICollectionViewDelegateFlowLayout {
  
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
    
  }
  
}




// MARK: UIWebViewDelegate
/*
extension FacilityDetailViewController: UIWebViewDelegate {
  
  func webViewDidFinishLoad(webView: UIWebView) {
    
    var frame = self.wvDescription.frame;
    frame.size.height = 1;
    self.wvDescription.frame = frame;
    
    // [aWebView sizeThatFits:CGSizeZero];
    let fittingSize = self.wvDescription.sizeThatFits(CGSize.zero)
    
    frame.size = fittingSize;
    self.wvDescription.frame = frame;
    
    // NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    
  }
  
}

 */











