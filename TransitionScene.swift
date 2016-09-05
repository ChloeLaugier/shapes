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
        
    }
    
    
}