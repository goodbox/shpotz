//
//  NewUserViewController.swift
//  Spots
//
//  Created by Alexander Grach on 4/3/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit



class NewUserViewController : UIViewController {
    
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    
    var didCloseNewUserDelegate: DidCloseNewUserScreenDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyOnboard.style = .dark
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        // swiftyOnboard.backgroundColor = UIColor(red: 46/256, green: 46/256, blue: 76/256, alpha: 1)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == 2 {
            
            self.dismiss(animated: true) {
                self.didCloseNewUserDelegate.didCloseNewUserScree(self)
            }
        } else {
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
    }
}


extension NewUserViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
        
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
        
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        
        
        view?.titleLabel.textColor = UIColor.black
        view?.subTitleLabel.textColor = UIColor.black
        
        if index == 0 {
            // On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "Share dispersed camp spots privately with your friends!"
            view?.subTitleLabel.text = "If you make the spot private, only your facebook friends that use the app will see it."
            view?.subTitleLabel.font = UIFont(name: "Lato-Regular", size: 22)
            view?.image.image = UIImage(named: "logo_image")
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "What is dispersed camping?"
            view?.subTitleLabel.text = "Dispersed camping is the term used for camping anywhere in the National Forest or BLM land OUTSIDE of a designated campground."
            view?.subTitleLabel.font = UIFont(name: "Lato-Regular", size: 18)
            view?.image.image = UIImage(named: "logo_image")
        } else {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "Find designated campsites too!"
            view?.subTitleLabel.text = "You can also find designated campsites that you can reserve."
            view?.subTitleLabel.font = UIFont(name: "Lato-Regular", size: 22)
            view?.image.image = UIImage(named: "logo_image")
        }
        return view
    }
        
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.buttonContinue.setTitle("Continue", for: .normal)
            overlay.skip.setTitle("Skip", for: .normal)
            overlay.skip.isHidden = false
        } else {
            overlay.buttonContinue.setTitle("Get Started!", for: .normal)
            overlay.skip.isHidden = true
        }
    }
}
