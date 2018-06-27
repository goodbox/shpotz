//
//  OnboardingViewController.swift
//  Spots
//
//  Created by Alexander Grach on 4/26/18.
//  Copyright © 2018 goodbox. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

public class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var onboardingView: OnboardingView!

    @IBOutlet weak var btnGetStarted: MDCRaisedButton!
    
    let onboardingItemInfoScreens = [OnboardingItemInfo(informationImage: (UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500))!, title: "Welcome!", description: "Goodspots is all about sharing dispersed campsites privately with your friends.", pageIcon: (UIImage(named: "ic_radio_button_white"))!, color: UIColor.white, titleColor: MDCPalette.grey.tint500, descriptionColor: MDCPalette.grey.tint500, titleFont: UIFont(name: "Roboto-Light", size: 26)!, descriptionFont: UIFont(name: "Roboto-Light", size: 20)!),
                                     OnboardingItemInfo(informationImage: (UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500))!, title: "What is dispersed camping?", description: "Dispersed camping is camping anywhere in the National Forest or on BLM land, outside of a designated campground.", pageIcon: (UIImage(named: "ic_radio_button_white"))!, color: UIColor.white, titleColor: MDCPalette.grey.tint500, descriptionColor: MDCPalette.grey.tint500, titleFont: UIFont(name: "Roboto-Light", size: 26)!, descriptionFont: UIFont(name: "Roboto-Light", size: 20)!),
                                     OnboardingItemInfo(informationImage: (UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500))!, title: "How it works.", description: "The next time you find yourself at an awesome dispersed campspot, just tap the green + button at the bottom right corner of the map(Yes, you actually have to be there). It'll work offline too!", pageIcon: (UIImage(named: "ic_radio_button_white"))!, color: UIColor.white, titleColor: MDCPalette.grey.tint500, descriptionColor: MDCPalette.grey.tint500, titleFont: UIFont(name: "Roboto-Light", size: 26)!, descriptionFont: UIFont(name: "Roboto-Light", size: 20)!),
                                     OnboardingItemInfo(informationImage: (UIImage(named: "logo_image")?.tint(with: MDCPalette.grey.tint500))!, title: "Find designated campsites too!", description: "Goodspots also has all of the reserved/designated campsites you would find in the National Forest too!", pageIcon: (UIImage(named: "ic_radio_button_white"))!, color: UIColor.white, titleColor: MDCPalette.grey.tint500, descriptionColor: MDCPalette.grey.tint500, titleFont: UIFont(name: "Roboto-Light", size: 26)!, descriptionFont: UIFont(name: "Roboto-Light", size: 20)!)]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // btnGetStarted.setTitleColor(UIColor.totesDarkGray(), for: .normal)
        (btnGetStarted as! MDCRaisedButton).setTitleColor(UIColor.totesDarkGray(), for: .normal)
        
        onboardingView.dataSource = self
        
        onboardingView.delegate = self
    }
    
    @IBAction func ShowLoginViewController(_ sender: Any) {
        // self.performSegue(withIdentifier: "ShowLoginViewControllerSegue", sender: self)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.switchRootViewController(rootViewController: loginVC, animated: true, completion: nil)
        
        // set the user defaults
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(true, forKey: "onboardingComplete")
        
        userDefaults.synchronize()
    }
    
    // MARK: onboarding date source
    public func onboardingItemsCount() -> Int {
        return 4
    }
    
    public func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItemInfoScreens[index]
    }
    
    // MARK: onboarding delegate
    public func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    public func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            if self.btnGetStarted.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.btnGetStarted.alpha = 0
                }
            }
        }
    }
    
    public func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.4) {
                self.btnGetStarted.alpha = 1
            }
        }
    }
}

