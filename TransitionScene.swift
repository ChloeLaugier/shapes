//
//  TransitionScene.swift
//  Shapes
//
//  Created by Chloé Laugier on 19/06/2016.
//  Copyright © 2016 Chloé Laugier. All rights reserved.
//

import Foundation
import iAd
import SpriteKit
import UIKit

class TransitionScene : SKScene, ADInterstitialAdDelegate {

    
    var interAd:ADInterstitialAd?
    var interAdView = UIView()
    var closeButton = UIButton(type : UIButtonType.System)
    
    override func didMoveToView(view: SKView) {
        // Define a close button size:
        closeButton.frame = CGRectMake(20, 20, 70, 44)
        closeButton.layer.cornerRadius = 10
        // Give the close button some coloring layout:
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        // Wire up the closeAd function when the user taps the button
        closeButton.addTarget(self, action: #selector(TransitionScene.closeAd(_:)), forControlEvents: UIControlEvents.TouchDown)
        // Some funkiness to get the title to display correctly every time:
        closeButton.enabled = false
        closeButton.setTitle("skip", forState: UIControlState.Normal)
        closeButton.enabled = true
        closeButton.setNeedsLayout()
        
        // Try to show an ad
        let adShown = showAd()
        
        // If no ad, just move on
        if adShown == false {
            // Do whatever's next for your app
        }
    }
    
    // iAd
    func prepareAd() {
        print(" --- AD: Try Load ---")
        // Attempt to load a new ad:
        interAd = ADInterstitialAd()
        interAd?.delegate = self
    }
    
    // You can call this function from an external source when you actually want to display an ad:
    func showAd() -> Bool {
        if interAd != nil && interAd!.loaded {
            interAdView = UIView()
            interAdView.frame = self.view!.bounds
            self.view?.addSubview(interAdView)
            
            interAd!.presentInView(interAdView)
            UIViewController.prepareInterstitialAds()
            
            interAdView.addSubview(closeButton)
        }
        
        // Return true if we're showing an ad, false if an ad can't be displayed:
        return interAd?.loaded ?? false
    }
    
    // When the user clicks the close button, route to the adFinished function:
    func closeAd(sender: UIButton) {
        adFinished()
    }
    
    // A function of common functionality to run when the user returns to your app:
    func adFinished() {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        // (Do whatever is next in your app)
    }
    
    // The ad loaded successfully (we don't need to do anything for the basic implementation)
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Load Success ---")
    }
    
    // The ad unloaded (we don't need to do anything for the basic implementation)
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Unload --- ")
    }
    
    // This is called if the user clicks into the interstitial, and then finishes interacting with the ad
    // We'll call our adFinished function since we're returning to our app:
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        print(" --- ADD: Action Finished --- ")
        adFinished()
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    // Error in the ad load, print out the error
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print(" --- AD: Error --- ")
        print(error.localizedDescription)
    }
}