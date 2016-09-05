//
//  GameViewController.swift
//  Shapes
//
//  Created by Chloé Laugier on 06/07/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import SpriteKit
import UIKit
import GoogleMobileAds
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GADInterstitialDelegate, PlaySceneDelegate, GameSceneDelegate {
    
    var _interstitial: GADInterstitial!
    var _interstitialFrequency : Int = 0
    var _music:AVAudioPlayer = AVAudioPlayer()


    override func viewDidLoad() {
        super.viewDidLoad()
        _interstitial = createAndLoadInterstitial()
        showPlayScene()

        
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background", ofType: "mp3")!)
        do{
            _music = try AVAudioPlayer(contentsOfURL:sound)
            _music.numberOfLoops = -1
            _music.volume = 0.5
            _music.prepareToPlay()
            _music.play()
        }catch {
            
        }
        
    }
    
    func showAdd() {
        if _interstitial.isReady {
            _interstitial.presentFromRootViewController(self)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        _interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        _interstitial.delegate = self
        
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "518abfe44096c6c5c4d945c9a83eeea3" ]
        _interstitial.loadRequest(request)
        return _interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        _interstitial = createAndLoadInterstitial()
    }
    
    func didStartGame(sender: PlayScene) {
        
        _interstitialFrequency = _interstitialFrequency+1
        if (_interstitialFrequency == 3) {
            showAdd()
            _interstitialFrequency = 0
        }
       
        
    }
    
    func playGame(level: Int) {
        let skView = self.view as! SKView
        let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
        let viewSize = self.view?.bounds.size
        gameScene.size = viewSize!
        gameScene._level = level
        gameScene.scaleMode = .AspectFill
        gameScene.gameDelegate = self
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene, transition: SKTransition.crossFadeWithDuration(0.5))
    }
    
    func didEndGame() {
        showPlayScene();
    }
    
    
    func showPlayScene() -> PlayScene?{
        if let scene = PlayScene.unarchiveFromFile("PlayScene") as? PlayScene
        {
            let skView = self.view as! SKView
            //skView.showsFPS = false
            //skView.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.sceneDelegate = self
            skView.presentScene(scene, transition: SKTransition.crossFadeWithDuration(0.5))
            return scene
        }
        return PlayScene()
    }
}
