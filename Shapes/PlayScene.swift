//
//  PlayScene.swift
//  Shapes
//
//  Created by Chloé Laugier on 26/07/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import SpriteKit
import UIKit

protocol PlaySceneDelegate: class {
    func didStartGame(sender: PlayScene)
    func playGame(level : Int)
}

class PlayScene: SKScene, UITableViewDataSource, UITableViewDelegate {
    
    var levelTable : UITableView = UITableView()
    var levelsNumber = 16
    var levelTableInfos : [Level]?
    let rowHeight : CGFloat = 110.0;
    var rowWidth : CGFloat = 0.0;
    weak var sceneDelegate:PlaySceneDelegate?
    
    
   
    var interAdView = UIView()
    var closeButton = UIButton(type : UIButtonType.System)
    

    

    override func didMoveToView(view: SKView) {
        //let levelTable : LevelTableView = LevelTableView()
        //self.scene!.size = view.bounds.size
        
        //Player.sharedInstance.setLevel(0);
        levelTableInfos = []
        for  i in 0...levelsNumber-1 {
            levelTableInfos!.append(Level(_level : i))
        }
        
        self.rowWidth = self.view!.bounds.width-40;
        var gradientTexture : SKTexture = SKTexture(size: self.frame.size, firstColor: levelTableInfos![0].backgroundColors[0], lastColor: levelTableInfos![0].backgroundColors[1])
        if (Player.sharedInstance.level < levelsNumber) {
            gradientTexture = SKTexture(size: self.frame.size, firstColor: levelTableInfos![Player.sharedInstance.level].backgroundColors[0], lastColor: levelTableInfos![Player.sharedInstance.level].backgroundColors[1])
        }
        
        let bg : SKSpriteNode = SKSpriteNode(texture: gradientTexture)
        bg.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        bg.zPosition = -1
        bg.alpha = 0
        
        self.addChild(bg)
        bg.runAction(
            SKAction.fadeAlphaTo(1, duration: 1)
        )
        
        let logo : SKSpriteNode = SKSpriteNode(imageNamed: "shapes")
        logo.position = CGPoint(x : self.frame.size.width/2, y:self.frame.size.height-70)
        logo.setScale(0.5)
        logo.name = "shapes"
        self.addChild(logo)
        logo.runAction(
            SKAction.sequence([
                SKAction.waitForDuration(0.2),
                SKAction.scaleTo(0.9, duration: 0.3),
                SKAction.scaleTo(0.8, duration: 0.2)
            ])
        )
    
        if let fireEmmitter = SKEmitterNode(fileNamed: "MyParticle2.sks") {
            fireEmmitter.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height)
            fireEmmitter.name = "fireEmmitter"
            fireEmmitter.zPosition = 1
            fireEmmitter.targetNode = self
            self.addChild(fireEmmitter)
        }
        
        levelTable  = UITableView(frame: CGRectMake(20, 115, self.rowWidth, (self.view?.bounds.height)!-100))
        levelTable.dataSource = self
        levelTable.delegate = self
        levelTable.rowHeight = self.rowHeight
        levelTable.backgroundColor = UIColor.clearColor()
        levelTable.separatorStyle = UITableViewCellSeparatorStyle.None
        levelTable.showsHorizontalScrollIndicator = false;
        levelTable.showsVerticalScrollIndicator = false;
        levelTable.alpha = 0;
        self.view?.addSubview(levelTable)
        UIView.animateWithDuration(1.5, animations: {
            self.levelTable.alpha = 1.0
        })
    
        
        let indexPath = NSIndexPath(forRow: Player.sharedInstance.level, inSection:0)
        levelTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    
        sceneDelegate?.didStartGame(self)
    }
    

    /*override func didFinishUpdate() {
        levelTable.reloadData()
    }*/
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return levelsNumber + 1
    }
    
    class BorderedCell : UITableViewCell {
        var _border : CALayer = CALayer()
        var _imageView : UIImageView = UIImageView()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        required init(coder aDecoder: NSCoder) {
            //fatalError("init(coder:) has not been implemented")
            super.init(coder: aDecoder)!
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let size : CGSize = self.bounds.size
            let frame : CGRect = CGRectMake(0, 5, size.width-20, size.height-20)
            self.textLabel!.frame =  frame
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell:BorderedCell? = tableView.dequeueReusableCellWithIdentifier("CELL") as? BorderedCell
        
        if (cell == nil) {
            cell=BorderedCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CELL")
            cell?.backgroundColor = UIColor.clearColor()
            cell!.textLabel!.textAlignment = NSTextAlignment.Right
        
            cell!._border.frame = CGRectMake(0,5,self.rowWidth, self.rowHeight-20)
            cell!._border.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4).CGColor
            cell!._border.borderWidth = 1
            
            cell!._border.cornerRadius = 3.0
            cell!.layer.addSublayer(cell!._border)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            
            cell!._imageView.image = nil
            var imgFrame = cell!._border.frame
            imgFrame.origin.x = cell!._border.frame.origin.x + 20
            cell!._imageView.frame = imgFrame
            cell!._imageView.contentMode = UIViewContentMode.BottomLeft
            cell!.addSubview(cell!._imageView)
        }
        
       
        cell!.textLabel!.text="\(indexPath.row+1)"
        cell!.textLabel!.textColor = UIColor.whiteColor()
        
        //cell!.detailTextLabel!.text=levelTableInfos![indexPath.row].levelDescription
        //cell!.detailTextLabel!.textColor = UIColor.whiteColor()
        // levelTableInfos![indexPath.row].backgroundColors[0]/*.colorWithAlphaComponent(0.5)*/
        cell!._border.opacity = 1
        cell!._border.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        cell!._imageView.image = nil
        
        cell!.textLabel!.font = UIFont.boldSystemFontOfSize(40)
        
        var levelNumberMax = Player.sharedInstance.level
        if (levelNumberMax >= levelsNumber) {
            levelNumberMax = 0
        }
        if (indexPath.row >= levelsNumber) {
            cell!.textLabel!.text = "Ask for more!"
            cell!.textLabel!.font = UIFont.boldSystemFontOfSize(20)
            cell!.userInteractionEnabled = true
        }
        else if (Player.sharedInstance.level >= indexPath.row) {
            cell!._border.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0).CGColor
            cell!.userInteractionEnabled = true
            
            if (Player.sharedInstance.level > indexPath.row) {
                cell!._border.opacity = 0.5
                var textColor : UIColor = levelTableInfos![levelNumberMax].backgroundColors[1]
                textColor = darkerColorForColor(textColor)
                cell?.textLabel?.textColor = textColor
                let image : UIImage = UIImage(named: "cell\(indexPath.row)")!
                cell!._imageView.image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                cell!._imageView.tintColor = UIColor.whiteColor()
            }
            else if (Player.sharedInstance.level == indexPath.row) {
                let image : UIImage = UIImage(named: "cell\(indexPath.row)")!
                cell!._imageView.image = image
            }
            else {
                cell!._border.borderColor = UIColor.whiteColor().CGColor
                
            }
            

        }
        else {
            cell!._border.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
            cell!.userInteractionEnabled = false
        }
        return cell!
    }
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var rotation : CATransform3D;
        rotation = CATransform3DMakeRotation( (60.0*3.14)/180, 0.0, 0.2, 0)//0 ,0.7, 0.4
        //rotation.m34 = 1.0 / -600
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        //cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        //cell.layer.anchorPoint = CGPointMake(0, 0.5);
        UIView.beginAnimations("alpha", context: nil)
        UIView.setAnimationDuration(0.7);
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        //cell.layer.shadowOffset = CGSizeMake(0, 0);
        UIView.commitAnimations();
    }
    
    
    func darkerColorForColor(color: UIColor) -> UIColor {
    
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                return UIColor(red: max(r - 0.1, 0.0), green: max(g - 0.1, 0.0), blue: max(b - 0.1, 0.0), alpha: a)
        }
    
        return UIColor()
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row < 16) {
            playLevel(indexPath.row)
        }
        else {
            let application = UIApplication.sharedApplication()
            let urls = [
                "fb://profile/1145643698836408",
                "http://www.facebook.com/Shapes-game-1145643698836408"
            ]
            for url in urls {
                if application.canOpenURL(NSURL(string: url)!) {
                    application.openURL(NSURL(string: url)!)
                    return
                }
            }
        }
    }
    
    
    func playLevel (level : Int) {
        
        levelTable.removeFromSuperview()
        sceneDelegate!.playGame(level)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //playLevel(1)
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "shapes") {
                Player.sharedInstance.setDebug()
                //levelTable.removeFromSuperview()
                //let viewSize = self.view?.bounds.size
                //transitionAd.size = viewSize!
                //transitionAd.scaleMode = .AspectFill
                //self.view?.presentScene(transitionAd, transition : SKTransition.crossFadeWithDuration(0.5))
            }
        }
    }
    
    
   
    
   
    
   
}
