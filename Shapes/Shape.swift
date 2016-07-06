//
//  Shape.swift
//  Shapes
//
//  Created by Chloé Laugier on 06/07/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import Foundation
import SpriteKit



class Shape : CustomStringConvertible {
    var posx: CGFloat
    var posy: CGFloat
    let shapeType: String
    var sprite: SKNode?
    
    
    init(size : CGFloat, posx: CGFloat, posy: CGFloat, shapeType: String, colors: [UIColor]) {
        self.posx = posx
        self.posy = posy
        self.shapeType = shapeType.lowercaseString
        
        if ((self.shapeType.rangeOfString("img_")) != nil) {
            let img = self.shapeType.stringByReplacingOccurrencesOfString("img_", withString: "")
             self.sprite = SKSpriteNode(imageNamed: img)
        }
        else {
        
        switch (self.shapeType) {
        
        case "square" :
            self.sprite = SKShapeNode(rectOfSize: CGSize(width: size*2, height: size*2));
            break;
        case "triangle" :
            var points1 : [CGPoint]=[CGPoint(x: -size,y: -size), CGPoint(x: size,y: -size),CGPoint(x: 0,y: size)];
            self.sprite = SKShapeNode(points: &points1, count: 3);
            break;
        case "losange" :
            var points1 : [CGPoint]=[
                CGPoint(x: 0,y: -size),
                CGPoint(x: -size,y: 0),
                CGPoint(x: 0,y: size),
                CGPoint(x: size,y: 0),
                ];
            self.sprite = SKShapeNode(points: &points1, count: 4);
            break;
        case "star" :
            var points1 : [CGPoint]=[
                CGPoint(x: 0,y: -size),
                CGPoint(x: -size/3,y: -size/3),
                CGPoint(x: -size,y: 0),
                CGPoint(x: -size/3,y: size/3),
                CGPoint(x: 0,y: size),
                CGPoint(x: size/3,y: size/3),
                CGPoint(x: size,y: 0),
                CGPoint(x: size/3,y: -size/3),
                ];
            self.sprite = SKShapeNode(points: &points1, count: 8);
            break
        default:
            self.sprite = SKShapeNode(circleOfRadius: size )
            break;
        }
        }
        self.sprite!.position = CGPointMake(posx, posy)
        let ri = drand48()*Double(colors.count)
        let rcolor = colors[Int(ri)]
        if (self.sprite is SKShapeNode) {
            (self.sprite as! SKShapeNode).fillColor = rcolor
            (self.sprite as! SKShapeNode).strokeColor = rcolor
        }
        else {
            (self.sprite as! SKSpriteNode).color = rcolor
            (self.sprite as! SKSpriteNode).colorBlendFactor = 1
        }
    }
    
    func explode() {
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        let scale = SKAction.scaleTo(0.0, duration: 0.5)
        let group = SKAction.group([fade, scale])
        self.sprite!.runAction(group, completion : {self.sprite!.removeFromParent()})
    }
    
    func fade() {
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        let scale = SKAction.scaleTo(1.3, duration: 0.5)
        let group = SKAction.group([fade, scale])
        self.sprite!.runAction(group, completion : {self.sprite!.removeFromParent()})
    }
    
    
    var description: String {
        return "type:\(shapeType) position:(\(posx),\(posy))"
    }
}
