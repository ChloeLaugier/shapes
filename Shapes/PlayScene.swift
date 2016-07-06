//
//  PlayScene.swift
//  Shapes
//
//  Created by Chloé Laugier on 26/07/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import SpriteKit
import UIKit


class PlayScene: SKScene, UITableViewDataSource, UITableViewDelegate {
    
    var levelTable : UITableView = UITableView()
    var levelsNumber = 12
    var levelTableInfos : [Level]?
    let rowHeight : CGFloat = 110.0;
    var rowWidth : CGFloat = 0.0;
    var transition : TransitionScene = TransitionScene()
    

    

    override func didMoveToView(view: SKView) {
        //let levelTable : LevelTableView = LevelTableView()
        //self.scene!.size = view.bounds.size
        
        //Player.sharedInstance.setLevel(0);
        levelTableInfos = []
        for  i in 0...12 {
            levelTableInfos!.append(Level(_level : i))
        }
        
        self.rowWidth = self.view!.bounds.width-40;
        let gradientTexture : SKTexture = SKTexture(size: self.frame.size, firstColor: levelTableInfos![Player.sharedInstance.level].backgroundColors[0], lastColor: levelTableInfos![Player.sharedInstance.level].backgroundColors[1])
        let bg : SKSpriteNode = SKSpriteNode(texture: gradientTexture)
        bg.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        bg.zPosition = -1
        self.addChild(bg)
    
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
        
        self.view?.addSubview(levelTable)
    
        
        let indexPath = NSIndexPath(forRow: Player.sharedInstance.level, inSection:0)
        levelTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        transition.prepareAd()
        
        
    }
    
    /*override func didFinishUpdate() {
        levelTable.reloadData()
    }*/
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return levelsNumber
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
            cell!.textLabel!.font = UIFont.boldSystemFontOfSize(40)
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
        if (Player.sharedInstance.level >= indexPath.row) {
            
            cell!._border.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0).CGColor
            cell!.userInteractionEnabled = true
            
            if (Player.sharedInstance.level > indexPath.row) {
                cell!._border.opacity = 0.5
                var textColor : UIColor = levelTableInfos![Player.sharedInstance.level].backgroundColors[1]
                textColor = darkerColorForColor(textColor)
                cell?.textLabel?.textColor = textColor
                let imgIndex = indexPath.row < 9 ? indexPath.row : 1;
                let image : UIImage = UIImage(named: "cell\(imgIndex)")!
                cell!._imageView.image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                cell!._imageView.tintColor = UIColor.whiteColor()
            }
            else if (Player.sharedInstance.level == indexPath.row) {
                let imgIndex = indexPath.row < 9 ? indexPath.row : 1;
                let image : UIImage = UIImage(named: "cell\(imgIndex)")!
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
    
    
    func darkerColorForColor(color: UIColor) -> UIColor {
    
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                return UIColor(red: max(r - 0.1, 0.0), green: max(g - 0.1, 0.0), blue: max(b - 0.1, 0.0), alpha: a)
        }
    
        return UIColor()
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playLevel(indexPath.row)
    }
    
    
    func playLevel (level : Int) {
        levelTable.removeFromSuperview()
        if let view = view {
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
            let viewSize = self.view?.bounds.size
            gameScene.size = viewSize!
            gameScene._level = level
            gameScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            view.presentScene(gameScene, transition: transition)
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //playLevel(1)
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if (node.name == "shapes") {
                Player.sharedInstance.setDebug()
                
                let viewSize = self.view?.bounds.size
                transition.size = viewSize!
                transition.scaleMode = .AspectFill
                self.view?.presentScene(transition, transition : SKTransition.crossFadeWithDuration(0.5))
            }
        }
    }
    
    
   
}
