//
//  SpotDetailViewController.swift
//  Spots
//
//  Created by goodbox on 3/9/17.
//  Copyright © 2017 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import PopupDialog
import AlamofireImage
import Serrata
import GoogleMaps

public class SpotDetailViewController: UITableViewController {
  
    // outlets
    
    @IBOutlet weak var imgHeaderPic: UIImageView!
    
    @IBOutlet weak var lblSpotName: UILabel!
    
    @IBOutlet weak var lblDispersed: UILabel!
    
    @IBOutlet weak var tvCellDescription: UITableViewCell!
    
    @IBOutlet weak var cvActivities: UICollectionView!
    
    @IBOutlet weak var photosContainer: UIView!
    
    @IBOutlet weak var vLocation: UIView!
    
    @IBOutlet weak var btnGetDirections: UIButton!
    
    @IBOutlet weak var wvDescription: UIWebView!
    
    // vars
    
    var spotDetail: SpotsModel!
  
    var spotMapModel: SpotMapModel!
  
    var api: ApiServiceController!
  
    fileprivate let cellResuseIdenitfier = "SelectSpotTypeCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    var photosColContainer: PhotosContainerViewController!
    
    var mapView : GMSMapView!
    var zoomLevel: Float = 15.0
    
    var webViewHeight : CGFloat = 300
    
    public override func viewDidLoad() {
    
        super.viewDidLoad()
        
        spotDetail = SpotsModel()
    
        api = ApiServiceController.sharedInstance
        
        wvDescription.scrollView.isScrollEnabled = false
        wvDescription.delegate = self
    
        cvActivities.delegate = self
        cvActivities.dataSource = self
        
        cvActivities.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
        
        btnGetDirections.backgroundColor = UIColor.spotsGreen()
        btnGetDirections.setTitle("Get Directions", for: .normal)
        btnGetDirections.setTitleColor(UIColor.white, for: .normal)
        
        // photosColContainer.spotSystemType = SpotsSystemType.goodSpot
        
        loadGoodSpot()
    }
    
    func setDispersed() {
        
        self.lblDispersed.text = "Dispersed Camping"
        
        self.lblDispersed.layer.backgroundColor = UIColor.totesBusinessMedia().cgColor
        
        self.lblDispersed.textColor = UIColor.white
        
        // self.lblReserved.font = UIFont.totesChallengeCategory()
        
        (self.lblDispersed as! RoundedBGLabel).textInsets = UIEdgeInsets(top:4, left: 8, bottom: 4, right: 8)
        
        self.lblDispersed.layer.cornerRadius = 5
        
        self.lblDispersed.sizeToFit()
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
    
    func loadGoodSpot() {
    
        _ = api.getSpot(UserDefaults.SpotsToken!, spotId: String(spotMapModel.Id), completion: { (success, spot, ewrror) in
        
            self.spotDetail = spot
            
            if self.spotDetail.spotImages != nil && self.spotDetail.spotImages.count > 0 {
                
                self.photosColContainer.images = self.spotDetail.spotImages
                self.photosColContainer.cvPhotos.reloadData()
                
                self.imgHeaderPic.contentMode = .scaleAspectFit
                
                self.imgHeaderPic.af_setImage(
                    withURL: URL(string: (self.spotDetail.spotImages.first?.Url)!)!,
                    placeholderImage: nil,
                    filter: nil,
                    imageTransition: .crossDissolve(0.2)
                )
            } else {
                
                self.imgHeaderPic.image = SpotIcons.other?.tint(with: Color.lightGray)
                self.imgHeaderPic.contentMode = .scaleAspectFit
            }
            
           
        
            self.lblSpotName.text = self.spotDetail.Name
            
            self.lblSpotName.font = UIFont.spotsFacilityName()
            
            self.lblSpotName.layer.shadowColor = UIColor.black.cgColor
            self.lblSpotName.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            self.lblSpotName.layer.shadowRadius = 0.0
            self.lblSpotName.layer.shadowOpacity = 1
            
            self.lblSpotName.textAlignment = NSTextAlignment.left
            self.lblSpotName.contentMode = UIViewContentMode.bottom
            
            self.setDispersed()
            
            self.wvDescription.loadHTMLString(String("<h3>" + self.spotDetail.Description + "</h3>"), baseURL: nil)
            
            if self.spotDetail.selectedSpotTypes.count > 0 {
                self.cvActivities.reloadData()
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: self.spotDetail.Lat,
                                                  longitude: self.spotDetail.Long,
                                                  zoom: self.zoomLevel)
            self.mapView = GMSMapView.map(withFrame: self.vLocation.bounds, camera: camera)
            // mapView.settings.myLocationButton = true
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.mapView.isMyLocationEnabled = false
            self.mapView.settings.scrollGestures = false
            self.mapView.settings.zoomGestures = false
            
            // Add the map to the view, hide it until we've got a location update.
            self.vLocation.addSubview(self.mapView)
            // mapView.isHidden = true
            
            let position = CLLocationCoordinate2D(latitude: self.spotDetail.Lat, longitude: self.spotDetail.Long)
            let marker = GMSMarker(position: position)
            
            marker.map = self.mapView
            
            self.tableView.reloadData()
        })
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (webViewHeight + 20)
        } else if indexPath.section == 1 {
            return 220
        } else if indexPath.section == 2 {
            return 200
        } else if indexPath.section == 3 {
            return 300
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    @IBAction func btnGetDirectionsTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Directions", message: "Select Navigation App", preferredStyle: .actionSheet)
        
        let googleUrl = URL(string:"comgooglemaps://")
        
        if (UIApplication.shared.canOpenURL(googleUrl!)) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
                
                let gUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(self.spotDetail.Lat!),\(self.spotDetail.Long!)&directionsmode=driving")
                
                UIApplication.shared.open(gUrl!, options: [:], completionHandler: nil)
                
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (action) in
            let gUrl = URL(string: "http://maps.apple.com/?daddr=\(self.spotDetail.Lat!),\(self.spotDetail.Long!)")
            
            UIApplication.shared.open(gUrl!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


// MARK: DidTapPhotoDelegate
extension SpotDetailViewController: DidTapFacilityImageDelegate {
    
    func didTapFacilityImage(_ sender: Any?, index: Int?, imageCell: FacilityImageCell?) {
        print("did tap photo")
        
        let slideLeafs: [SlideLeaf] = self.spotDetail.spotImages.enumerated().map { SlideLeaf(imageUrlString: $0.1.Url, title: "", caption: "") }
        
        let slideImageViewController = SlideLeafViewController.make(leafs: slideLeafs,
                                                                    startIndex: index!,
                                                                    fromImageView: imageCell?.imgPhoto!)
        
        slideImageViewController.delegate = self
        present(slideImageViewController, animated: true, completion: nil)
    }
}

// MARK: SlideLeafViewControllerDelegate
extension SpotDetailViewController: SlideLeafViewControllerDelegate {
    
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

// MARK: UICollectionViewDataSource for activities
extension SpotDetailViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.spotDetail.selectedSpotTypes.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseIdenitfier,
                                                      for: indexPath) as! SelectSpotTypeCell
        
        
        self.spotDetail.selectedSpotTypes[indexPath.row].IsSelected = false
        cell.configure(self.spotDetail.selectedSpotTypes[indexPath.row])
        // Configure the cell
        return cell
        
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension SpotDetailViewController : UICollectionViewDelegateFlowLayout {
    
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

extension SpotDetailViewController: UIWebViewDelegate {
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webViewHeight = wvDescription.scrollView.contentSize.height
        
        self.tableView.reloadData()
    }
}

