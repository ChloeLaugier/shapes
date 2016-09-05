//
//  GameScene.swift
//  Shapes
//
//  Created by Chloé Laugier on 06/07/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate: class {
    func didEndGame()
}

class GameScene: SKScene {
    
    var _allShapes: [Shape] = []
    
    var _main : Shape? = nil
    var _topView : SKShapeNode? = nil
    var _circle : SKShapeNode? = nil
    var _level = 0
    var _limitTime = 20
    var _chrono : SKLabelNode?
    var _chronoTime = 3
    var _levelObject : Level = Level(_level: 1)
    var _posTaken : [CGPoint]=[]
    weak var gameDelegate:GameSceneDelegate?
   
    
    override func didMoveToView(view: SKView) {

        
        _levelObject = Level(_level: _level)
        _limitTime = _levelObject.limitTime
        configureSceneForLevel()
        addAnimatedCircle(70, center: CGPointMake(frame.midX, frame.midY))
        
        _main = Shape(size : 30,posx: frame.midX,  posy: frame.midY, shapeType: _levelObject.targetShape, colors: [_levelObject.targetColor])
        _main?.sprite!.name = "main"
        
        
        _chrono = SKLabelNode(fontNamed:"RifficFree-Bold")
        _chrono!.text = String(self._chronoTime)+"s"
        _chrono!.fontSize = 80;
        _chrono!.fontColor = _levelObject.uiColor
        _chrono!.position = CGPoint(x:frame.midX, y:frame.midY+150);
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let scale = SKAction.scaleTo(1.3, duration: 0.3)
        let group = SKAction.group([fade, scale])
        self.addChild(_chrono!)
        _chrono!.runAction(group)
        let wait = SKAction.waitForDuration(0.6)
        let wait2 = SKAction.waitForDuration(0.2)
        let run = SKAction.runBlock {
            self._chronoTime-=1
            if (self._chronoTime <= 0) {
                
                self.startCatch()
            }
            else {
                self._chrono!.text = String(self._chronoTime)+"s"
                self._chrono!.alpha = 1
                self._chrono!.setScale(1)
                
                self._chrono!.runAction(SKAction.sequence([wait2, group]))
            }
            
        }
        _chrono!.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
        
       
  
        /*let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: frame.midX-30, y: frame.midY-30, width: 60, height: 60)).CGPath
        
        layer.fillColor = UIColor.whiteColor().CGColor
        
        let endShape = UIBezierPath(ovalInRect: CGRect(x: frame.midX-30, y: frame.midY-30, width: 60, height: 60)).CGPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endShape
        animation.duration = 1
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        layer.addAnimation(animation, forKey: animation.keyPath)
        
        _main?.sprite?.fillColor = SKColor.clearColor()
        _main?.sprite?.inputView?.layer.addSublayer(layer)*/
        self.addChild(_main!.sprite!)
  
        
    }
    /*
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if (flag) {
            //addAnimatedCircle()
        }
    }*/
    
    func startCatch() {
        
        _chrono!.removeAllActions()
        _chrono!.removeFromParent()
         _main?.sprite?.removeAllActions()
         _main?.sprite?.removeFromParent()
         _circle?.removeAllActions()
         _circle?.removeFromParent()
        
         addTopView()
         _allShapes = []
         self._posTaken =  []
         
         for j in 0..._levelObject.numberOfBadSprite {
            let randomIndex = arc4random_uniform(UInt32(_levelObject.shapesTypes.count));
            let randomShape  = _levelObject.shapesTypes[Int(randomIndex)];
            addShape(j, shapeType: randomShape)
         }
         for j in 0..._levelObject.numberOfGoodSprite {
            let node : SKNode = addShape(_levelObject.numberOfBadSprite+1+j, shapeType: _levelObject.targetShape)
            if (j == 0 && _level == 0) {
                addAnimatedCircle(40, center: node.position)
                node.zPosition = 2
            }
         }
    }
    
    func addShape( j : Int, shapeType :String ) -> SKNode {
        
        let ban :  CGFloat = 100.0;
        let space :  CGFloat = 30.0;
        let min :  CGFloat = 60.0;
        
        var rposx = space+CGFloat(arc4random_uniform(UInt32(frame.width-space*2)));
        var rposy = space+CGFloat(arc4random_uniform(UInt32(frame.height-space-ban)));
        
        var i = 0;
        while (i<self._posTaken.count) {
            var distance = pow(pow((rposx - self._posTaken[i].x), 2) + pow((rposy - self._posTaken[i].y), 2), 0.5);
            var generation = false;
            while (distance < min) {
                rposx = space+CGFloat(arc4random_uniform(UInt32(frame.width-space*2)));
                rposy = space+CGFloat(arc4random_uniform(UInt32(frame.height-space-ban)));
                distance = pow(pow((rposx - self._posTaken[i].x), 2) + pow((rposy - self._posTaken[i].y), 2), 0.5);
                generation = true;
                
            }
            if (generation) {
                i = 0;
            }
            else {
                i += 1;
            }
            
        }
        self._posTaken.append(CGPoint(x:rposx, y:rposy));
        
        let sh : Shape = Shape(size:15, posx: rposx, posy:rposy, shapeType: shapeType, colors: _levelObject.shapesColor)
        sh.sprite!.name = String(j);
        shapeAction(sh.sprite!)
        self.addChild(sh.sprite!)
        _allShapes.append(sh)
        return sh.sprite!
    }
    
    func shapeAction(sprite : SKNode) {
        switch _levelObject.animation {
        case 1:
            sprite.runAction(
                SKAction.moveToY(-5, duration: 10)
            )
            break
        case 2:
            sprite.runAction(
                SKAction.moveToX(sprite.position.x-(self.view?.bounds.size.width)!, duration: 15)
            )
            break
        case 3:
            sprite.runAction(
                SKAction.sequence([
                     SKAction.waitForDuration(Double(arc4random_uniform(5))),
                     SKAction.scaleTo(0, duration: 15)
                    ])
            )
            break
        case 4:
            let randSpeed = Double(1 + arc4random_uniform(5));
            sprite.runAction(
                SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.rotateByAngle(3.14, duration: randSpeed)])
                )
            )
            break
        case 5:
            let randSpeed = Double(1 + arc4random_uniform(5));
            sprite.runAction(
                SKAction.group([SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.rotateByAngle(3.14, duration: randSpeed)])
                    ), SKAction.moveToY(-5, duration: 10)])
                
            )
            break
        default:
            break
        }
    }
    
    func configureSceneForLevel() {

        self.backgroundColor = _levelObject.backgroundColors[0]
        
        let gradientTexture : SKTexture = SKTexture(size: self.view!.bounds.size, firstColor: _levelObject.backgroundColors[0], lastColor: _levelObject.backgroundColors[1])
        let bg : SKSpriteNode = SKSpriteNode(texture: gradientTexture)
        bg.position = CGPoint(x: self.view!.bounds.size.width/2.0, y: self.view!.bounds.size.height/2.0)
        bg.zPosition = -1
        self.addChild(bg)
        

    }
    
    func addTopView() {
        
        _topView = SKShapeNode(rectOfSize: CGSize(width: (self.view?.bounds.width)!, height: 60));
        _topView!.name = "quit"
        _topView!.position = CGPointMake((self.view?.bounds.width)!/2, (self.view?.bounds.height)!-30)
        _topView!.fillColor = _levelObject.targetColor.colorWithAlphaComponent(0.4)
        _topView!.strokeColor = _levelObject.targetColor.colorWithAlphaComponent(0.4)
        self.addChild(_topView!)
        
        addTimeView()
        
        let close = SKSpriteNode(imageNamed: "close")
        close.position = CGPointMake((_topView!.frame.width)/2-30, 0)
        close.name = "quit"
        _topView!.addChild(close)
    }
    
    
    func addTimeView() {
        let counter = SKLabelNode(fontNamed:"RifficFree-Bold")
        counter.text = String(self._limitTime)+"s"
        counter.fontSize = 35;
        counter.fontColor = _levelObject.uiColor
        counter.position = CGPoint(x:-_topView!.frame.width/2+30, y:-15);
        _topView!.addChild(counter)
        
        let wait = SKAction.waitForDuration(1)
        let run = SKAction.runBlock {
            self._limitTime-=1
            if (self._limitTime <= 0) {
                 self.endGame(3);
            }
            else {
                counter.text = String(self._limitTime)+"s"
            }
            
        }
        counter.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
    }
    
    
    func addAnimatedCircle(radius : CGFloat, center : CGPoint) {
        _circle = SKShapeNode(circleOfRadius: radius )
        _circle!.position = center
        _circle!.strokeColor = _levelObject.uiColor
        _circle!.glowWidth = 0.2
        _circle!.fillColor = _levelObject.backgroundColors[0].colorWithAlphaComponent(0)
        _circle!.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.scaleTo( 1.3, duration: 1.0),
                    SKAction.waitForDuration(0.1),
                    SKAction.scaleTo( 1.0, duration: 1.0),
                    ])
            )
        )
        self.addChild(_circle!)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if let ball = self.nodeAtPoint(location) as? SKNode {
                if (ball.name == "quit") {
                    gameDelegate!.didEndGame()
                }
                else if (ball.name == "main") {
                    startCatch()
                }
                else if (ball.name != nil){
                    
                    let current : Shape = _allShapes[Int(ball.name!)!];
                    if (current.shapeType == _main?.shapeType) {
                        current.fade()
                        _levelObject.numberOfGoodSprite -= 1
                        runAction(SKAction.playSoundFileNamed("7410.mp3", waitForCompletion:true))
                        if (_level == 0) {
                            _circle?.removeFromParent()
                        }
                        if (_levelObject.numberOfGoodSprite < 0) {
                            endGame(1);
                        }
                    }
                    else {
                        runAction(SKAction.playSoundFileNamed("1315.mp3", waitForCompletion:true))
                        endGame(2);
                    }
                    ball.name = nil
                    
                }
                
                
                
            }
            
            
            /*let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)*/
        }
    }
    
    
    func endGame( win : Int) {
        if (win == 1) {
            
            Player.sharedInstance.setLevel(_level+1)
        }
        for shape in _allShapes {
            if (intersectsNode(shape.sprite!)) {
                shape.explode()
            }
            
        }
        _topView!.removeFromParent()
        var imgName : String = "ok"
        if (win == 2) {
                imgName  = "loose"
        }
        else if (win == 3){
            imgName  = "hourglass"
        }
        let ok = SKSpriteNode(imageNamed: imgName)
        ok.position = CGPointMake(self.frame.midX, self.frame.midY)
        ok.name = "quit"
        ok.setScale(0)
        self.addChild(ok)
        let scale = SKAction.scaleTo(2.0, duration: 0.5)
        ok.runAction(scale, completion : {
            self.gameDelegate?.didEndGame()
            
        })
    }
    
    
   
/*    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }*/
    
    
    
    
    
}
