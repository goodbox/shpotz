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
  
  var activityName: [String]! = []
  
  var facilityDetail: FacilityDetail!
  
  var spotMapModel: SpotMapModel!
  
  var api: ApiServiceController!
  
  fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
  fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  
  fileprivate let itemsPerRow: CGFloat = 3
  
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
      } else {
        
        self.imgHeaderPic.image = SpotIcons.other?.tint(with: Color.grey.lighten1)
        self.imgHeaderPic.contentMode = .center
      }
      
      self.lblFacilityName.text = self.facilityDetail.Model.Name
      
      self.lblFacilityName.font = UIFont.spotsFacilityName()
      
      self.lblFacilityName.layer.shadowColor = UIColor.black.cgColor
      self.lblFacilityName.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
      self.lblFacilityName.layer.shadowRadius = 0.0
      self.lblFacilityName.layer.shadowOpacity = 1
      
      self.lblFacilityName.textAlignment = NSTextAlignment.left
      self.lblFacilityName.contentMode = UIViewContentMode.bottom

      if !self.facilityDetail.Model.Phone.isEmpty {
        self.lblFacilityPhone.text = self.facilityDetail.Model.Phone
      }
      
      self.wvDescription.loadHTMLString(self.facilityDetail.Model.Description, baseURL: nil)
      
      if self.facilityDetail.Activities != nil && self.facilityDetail.Activities.count > 0 {
        
        self.setActivities()
        
        if self.activityName != nil && self.activityName.count > 0 {
         
          self.cvActivities.reloadData()
          
        }
      }
      
      self.tableView.reloadData()
      
    })
  }
  
  func setActivities() {
    
    for act in self.facilityDetail.Activities as [FacilityActivity] {
      switch act.Name {
      case "CAMPING":
        
        self.activityName.append("Camping")
        
      case "BIKING":
        
        self.activityName.append("Mtn Biking")
  
      case "CLIMBING":
        
        self.activityName.append("Rock Climbing")

      case "FISHING":
        
        self.activityName.append("Fishing")
       
      case "HIKING":
        
        self.activityName.append("Hiking")
        
      case "HIKING":
        
        self.activityName.append("Hiking")
        
      case "SWIMMING":
        
        self.activityName.append("Swimming")
        
      default:
        continue
      }
    }
  }
  
  // MARK: uitableview 
  override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    print("section : \(section)")
    if facilityDetail != nil && facilityDetail.Model != nil {
      if(section == 0 && self.facilityDetail.Model.Phone.isEmpty) {
        return 0.0
      } else {
        return super.tableView(tableView, heightForHeaderInSection: section)
      }
    }
    else {
      return super.tableView(tableView, heightForHeaderInSection: section)
    }
   
  }
  
  override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("section : \(section)")
    if facilityDetail != nil && facilityDetail.Model != nil {
      if(section == 0 && self.facilityDetail.Model.Phone.isEmpty) {
        return 0
      } else {
        return super.tableView(tableView, numberOfRowsInSection: section)
      }
    }
    else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
}

// MARK: UICollectionViewDataSource
extension FacilityDetailViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.activityName.count
  
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                  for: indexPath) as! SelectSpotTypeCell
    
    
    
    cell.configure(self.activityName[indexPath.row])
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










