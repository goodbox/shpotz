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
    fileprivate var spotTypes: [SpotTypeModel] = [SpotTypeModel(name: "Camping"),
                                               SpotTypeModel(name: "Fishing"),
                                               SpotTypeModel(name: "Hiking"),
                                               SpotTypeModel(name: "Hot Springs"),
                                               SpotTypeModel(name: "Mtn Biking"),
                                               SpotTypeModel(name: "Surfing"),
                                               SpotTypeModel(name: "Rafting"),
                                               SpotTypeModel(name: "Canoeing"),
                                               SpotTypeModel(name: "Diving"),
                                               SpotTypeModel(name: "Rock Climbing"),
                                               SpotTypeModel(name: "Ice Climbing"),
                                               SpotTypeModel(name: "Beach"),
                                               SpotTypeModel(name: "Add Custom")]
    
    var selectedSpotTypes: [SpotTypeModel] = []
  
    var spotTypeDelegate: DidSelectSpotTypesDelegate!
  
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.register(UINib(nibName:cellResuseIdenitfier, bundle: nil), forCellWithReuseIdentifier: cellResuseIdenitfier)
    
        collectionView.dataSource = self
    
        collectionView.delegate = self
        
        setSelectedSpotTypes()
    }
    
    func setSelectedSpotTypes() {
        for spotType in selectedSpotTypes {
            let s = spotTypes.first(where: { (spot) -> Bool in
                spot.SpotName == spotType.SpotName
            })
            
            if s == nil {
                spotTypes.insert(SpotTypeModel(type: spotType.SpotType, name: spotType.SpotName, isSelected: true), at: spotTypes.count-1)
            } else {
                s?.IsSelected = true
            }
        }
    }
  
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntDoneTapped(_ sender: Any) {
        selectedSpotTypes = []
        
        for model in spotTypes {
            
            if model.IsSelected {
                selectedSpotTypes.append(model)
            }
        }
        
        if selectedSpotTypes.count == 0 {
            
            let uiImage = UIImage(named: "ic_error_red")
            
            showValidationPopup(theTitle: "Activity is Required", theMessage: "Please select at least one activity for this spot.", theImage: uiImage)
            
        } else {
            
            dismiss(animated: true, completion: nil)
            
            spotTypeDelegate.didSelectSpotType(_sender: self, spotTypes: selectedSpotTypes)
        }
    }
    
    func showValidationPopup(theTitle: String?, theMessage: String?, theImage: UIImage?) {
        
        
        let validationViewController = ValidationPopupViewController(nibName: "ValidationPopup", bundle: nil)
        
        let popup = PopupDialog(viewController: validationViewController, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true) {
            
            print("validation popup dismissed")
            
        }
        
        let buttonOne = DefaultButton(title: "Dismiss") {
            
        }
        
        popup.addButton(buttonOne)
        
        self.present(popup, animated: true, completion: nil)
        
        let vc = popup.viewController as! ValidationPopupViewController
        
        vc.imgValidationImage.image = theImage
        
        vc.lblValidationTitle.text = theTitle
        
        vc.lblValidationMessage.text = theMessage
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.row == spotTypes.count - 1 {
            // show dialog to add custom activity
            let ac = UIAlertController(title: "Add Activity", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0]
                // do something interesting with "answer" here
                self.spotTypes.insert(SpotTypeModel(type: SpotsType.other, name: answer.text!, isSelected: true), at: self.spotTypes.count - 1)
                
                self.collectionView.insertItems(at: [IndexPath(row: self.spotTypes.count - 2, section: 0)])
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            })
            
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            
            present(ac, animated: true)
            
        } else {
            spotTypes[indexPath.row].IsSelected = !spotTypes[indexPath.row].IsSelected
            
            let cell = collectionView.cellForItem(at: indexPath) as! SelectSpotTypeCell
            
            cell.configure(spotTypes[indexPath.row])
        }
    }
    /*
    
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
 
 */
  
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
