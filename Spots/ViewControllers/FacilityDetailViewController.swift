//
//  FacilityDetailViewController.swift
//  Spots
//
//  Created by goodbox on 4/13/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import PopupDialog
import AlamofireImage
import Serrata
import GoogleMaps
import Alamofire

public class FacilityDetailViewController: UITableViewController {
    
    @IBOutlet weak var vHeader: UIView!
  
    @IBOutlet weak var imgHeaderPic: UIImageView!

    @IBOutlet weak var lblFacilityName: UILabel!
  
    @IBOutlet weak var lblFacilityPhone: UILabel!
  
    @IBOutlet weak var wvDescription: UIWebView!
  
    @IBOutlet weak var cvActivities: UICollectionView!
  
    @IBOutlet weak var photosContainer: UIView!
  
    @IBOutlet weak var tvCellDescription: UITableViewCell!
    
    @IBOutlet weak var vLocation: UIView!
    
    @IBOutlet weak var btnGetDirections: UIButton!
    
    @IBOutlet weak var lblReserved: UILabel!
    
    @IBOutlet weak var btnAddReview: UIButton!
    
    @IBOutlet weak var btnAddFavorite: UIButton!
    
    var activityName: [String]! = []
  
    var facilityDetail: FacilityDetail!
  
    var spotMapModel: SpotMapModel!
  
    var api: ApiServiceController!
  
    fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  
    fileprivate let itemsPerRow: CGFloat = 3
  
    var photosColContainer: PhotosContainerViewController!
    
    var webViewHeight : CGFloat = 100
  
    var mapView : GMSMapView!
    var zoomLevel: Float = 15.0
    
    @IBAction func btnAddReviewAction(_ sender: Any) {
    }
    
    public override func viewDidLoad() {
    
        super.viewDidLoad()
    
        api = ApiServiceController.sharedInstance
    
        wvDescription.scrollView.isScrollEnabled = false
        wvDescription.delegate = self
    
        cvActivities.delegate = self
        cvActivities.dataSource = self
    
        cvActivities.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
        btnGetDirections.backgroundColor = UIColor.spotsGreen()
        btnGetDirections.setTitle("Get Directions", for: .normal)
        btnGetDirections.setTitleColor(UIColor.white, for: .normal)
        
        btnAddFavorite.backgroundColor = UIColor.red
        
        btnAddReview.backgroundColor = UIColor.green
        
        lblFacilityName.textColor = UIColor.white
    
        loadFacility()
    
    }
    
    func setReserved() {
        
        self.lblReserved.text = "Designated Camping"
        
        self.lblReserved.layer.backgroundColor = UIColor.totesBusinessMedia().cgColor
        
        self.lblReserved.textColor = UIColor.white
        
        // self.lblReserved.font = UIFont.totesChallengeCategory()
        
        (self.lblReserved as! RoundedBGLabel).textInsets = UIEdgeInsets(top:4, left: 8, bottom: 4, right: 8)
        
        self.lblReserved.layer.cornerRadius = 5
        
        self.lblReserved.sizeToFit()
    }
  
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "PhotosSegue" {
      
            if let vc = segue.destination as? PhotosContainerViewController {
        
                vc.didTapPhotoDelegate = self
        
                self.photosColContainer = vc
            }
        } else if segue.identifier == "PhotoGallerySegue" {
      
      
            print("PhotoGallerySegue")
            /*
             if let vc = segue.destination as? UINavigationController {
        
             if let vd = vc.topViewController as? PhotoGalleryViewController {
             vd.facilityDetail = self.facilityDetail
             }
             }
             */
        }
        
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
                
                self.imgHeaderPic.image = SpotIcons.other?.tint(with: Color.lightGray)
                self.imgHeaderPic.contentMode = .center
            }
            
            self.lblFacilityName.text = "Some really long text thta will definiely take up more than one line" // self.facilityDetail.Model.Name
            
            self.lblFacilityName.sizeToFit()
            
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
            
            self.setReserved()
            
            self.wvDescription.loadHTMLString(self.facilityDetail.Model.Description, baseURL: nil)
            
            if self.facilityDetail.Activities != nil && self.facilityDetail.Activities.count > 0 {
                
                self.setActivities()
                
                if self.activityName != nil && self.activityName.count > 0 {
                    
                    self.cvActivities.reloadData()
                    
                }
            }
            
            if self.facilityDetail.Media != nil && self.facilityDetail.Media.count > 0 {
                self.photosColContainer.images = self.facilityDetail.Media
            }
            
            // set the map and location
            
            let camera = GMSCameraPosition.camera(withLatitude: self.facilityDetail.Model.Latitude,
                                                  longitude: self.facilityDetail.Model.Longitude,
                                                  zoom: self.zoomLevel)
            self.mapView = GMSMapView.map(withFrame: self.vLocation.bounds, camera: camera)
            // mapView.settings.myLocationButton = true
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.mapView.isMyLocationEnabled = false
            self.mapView.settings.scrollGestures = false
            self.mapView.settings.zoomGestures = false
            
            // Add the map to the view, hide it until we've got a location update.
            // mapView.isHidden = true
            
            let position = CLLocationCoordinate2D(latitude: self.facilityDetail.Model.Latitude, longitude: self.facilityDetail.Model.Longitude)
            let marker = GMSMarker(position: position)
            
            marker.map = self.mapView
            
            self.vLocation.addSubview(self.mapView)
            
            self.tableView.reloadData()
            
            
        })
    }
    
    func setActivities() {
        let sortedActivities = self.facilityDetail.Activities.sorted { (f1, f2) -> Bool in
            f1.Name.first! < f2.Name.first!
        }
        for act in sortedActivities as [FacilityActivity] {
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
                
            case "SWIMMING":
                
                self.activityName.append("Swimming")
                
            default:
                continue
            }
        }
    }
    
    
    @IBAction func btnGetDirectionsTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Directions", message: "Select Navigation App", preferredStyle: .actionSheet)
        
        let googleUrl = URL(string:"comgooglemaps://")
        
        if (UIApplication.shared.canOpenURL(googleUrl!)) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
                
                let gUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(self.facilityDetail.Model.Latitude),\(self.facilityDetail.Model.Longitude)&directionsmode=driving")
                
                UIApplication.shared.open(gUrl!, options: [:], completionHandler: nil)
                
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (action) in
            let gUrl = URL(string: "http://maps.apple.com/?daddr=\(self.facilityDetail.Model.Latitude),\(self.facilityDetail.Model.Longitude)")
            
            UIApplication.shared.open(gUrl!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
  
    // MARK: uitableview
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            // make phone call
            if let url = URL(string: "tel://\(self.facilityDetail.Model.Phone)"), UIApplication.shared.canOpenURL(url) {
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (bool) in
                    
                })
                
                // UIApplication.shared.open(url, options: , completionHandler: { (bool) in
                
                // })
            }
        }
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return (webViewHeight + 20)
        } else if indexPath.section == 2 {
            return 220
        } else if indexPath.section == 3 {
            if facilityDetail != nil && facilityDetail.Media != nil && facilityDetail.Media.count > 0 {
                return 200
            } else {
                return 0
            }
        } else if indexPath.section == 4 {
            return 300
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if facilityDetail != nil {
            if(section == 0 && facilityDetail.Model != nil && self.facilityDetail.Model.Phone.isEmpty) {
                return UIView(frame: CGRect.zero)
            } else if section == 3 && ((facilityDetail.Media != nil && facilityDetail.Media.count == 0) || facilityDetail.Media == nil) {
                return UIView(frame: CGRect.zero)
            } else {
                return super.tableView(tableView, viewForHeaderInSection: section)
            }
        }
        else {
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
    }
  
    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
        if facilityDetail != nil {
            if(section == 0 && facilityDetail.Model != nil && self.facilityDetail.Model.Phone.isEmpty) {
                return UIView(frame: CGRect.zero)
            } else if section == 3 && facilityDetail.Media != nil && facilityDetail.Media.count == 0 {
                return UIView(frame: CGRect.zero)
            } else {
                return super.tableView(tableView, viewForFooterInSection: section)
            }
        }
        else {
            return super.tableView(tableView, viewForFooterInSection: section)
        }
    }
  
    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("section : \(section)")
        if facilityDetail != nil {
            if(section == 0 && facilityDetail.Model != nil && self.facilityDetail.Model.Phone.isEmpty) {
                return 0.0
            } else if section == 3 && ((facilityDetail.Media != nil && facilityDetail.Media.count == 0) || facilityDetail.Media == nil) {
                return 0.0
            } else {
                return super.tableView(tableView, heightForHeaderInSection: section)
            }
        }
        else {
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
   
    }

    override public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        print("section : \(section)")
        if facilityDetail != nil {
            if(section == 0 && facilityDetail.Model != nil && self.facilityDetail.Model.Phone.isEmpty) {
                return 0.0
            } else if section == 3 && ((facilityDetail.Media != nil && facilityDetail.Media.count == 0) || facilityDetail.Media == nil) {
                return 0.0
            } else {
                return super.tableView(tableView, heightForFooterInSection: section)
            }
        }
        else {
            return super.tableView(tableView, heightForFooterInSection: section)
        }
    
    }

  
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section : \(section)")
        if facilityDetail != nil {
            if(section == 0 && facilityDetail.Model != nil && self.facilityDetail.Model.Phone.isEmpty) {
                return 0
            } else if section == 3 && ((facilityDetail.Media != nil && facilityDetail.Media.count == 0) || facilityDetail.Media == nil) {
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


// MARK: DidTapPhotoDelegate
extension FacilityDetailViewController: DidTapFacilityImageDelegate {
  
    func didTapFacilityImage(_ sender: Any?, index: Int?, imageCell: FacilityImageCell?) {
        print("did tap photo")
    
        let slideLeafs: [SlideLeaf] = facilityDetail.Media.enumerated().map { SlideLeaf(imageUrlString: $0.1.Url, title: "", caption: "") }
    
        let slideImageViewController = SlideLeafViewController.make(leafs: slideLeafs,
                                                                startIndex: index!,
                                                                fromImageView: imageCell?.imgPhoto!)
    
        slideImageViewController.delegate = self
        present(slideImageViewController, animated: true, completion: nil)
    }
}

// MARK: SlideLeafViewControllerDelegate
extension FacilityDetailViewController: SlideLeafViewControllerDelegate {
    
    public func tapImageDetailView(slideLeaf: SlideLeaf, pageIndex: Int) {
        print("tapImageDetailView")
        print(pageIndex)
        print(slideLeaf)
        
        //let viewController = DetailViewController.make(detailTitle: slideLeaf.title)
        //self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func longPressImageView(slideLeafViewController: SlideLeafViewController, slideLeaf: SlideLeaf, pageIndex: Int) {
        print("longPressImageView")
        print(slideLeafViewController)
        print(slideLeaf)
        print(pageIndex)
    }
    
    public func slideLeafViewControllerDismissed(slideLeaf: SlideLeaf, pageIndex: Int) {
        print("slideLeafViewControllerDismissed")
        print(slideLeaf)
        print(pageIndex)
        
        //let indexPath = IndexPath(row: pageIndex, section: 0)
        //self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
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
    
        cell.configure(SpotTypeModel(name: self.activityName[indexPath.row]))
        // Configure the cell
        return cell
        
    }
}



// MARK: UICollectionViewDelegateFlowLayout
extension FacilityDetailViewController : UICollectionViewDelegateFlowLayout {
  
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.deselectItem(at: indexPath, animated: false)
    
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




// MARK: UIWebViewDelegate

extension FacilityDetailViewController: UIWebViewDelegate {
  
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webViewHeight = wvDescription.scrollView.contentSize.height
        
        self.tableView.reloadData()
    
    }
  
}











