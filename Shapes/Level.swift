//
//  Level.swift
//  Shapes
//
//  Created by Chloé Laugier on 15/03/2016.
//  Copyright © 2016 Chloé Laugier. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Level {
    var backgroundColors : [UIColor] = [UIColor.whiteColor(), UIColor.whiteColor()]
    var shapesTypes : [String] = ["Triangle"]
    var targetShape : String =  "Triangle"
    var uiColor : UIColor = UIColor.whiteColor()
    var targetColor : UIColor = UIColor.whiteColor()
    var shapesColor : [UIColor] = [UIColor.whiteColor()]
    var numberOfGoodSprite : Int = 10
    var numberOfBadSprite : Int = 10
    var limitTime : Int = 20
    var animation : Int = 0
    init (_level: Int) {
        if (_level < 9) {
            let path = NSBundle.mainBundle().pathForResource("Level", ofType: "json")
            let jsonData = NSData(contentsOfFile: path!)
            var json : [AnyObject] = []
            do {
                json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! Array
                var clevel = json[_level] as! [String: AnyObject]
                targetShape = clevel["targetShape"] as! String
                numberOfGoodSprite = clevel["numberOfGoodSprite"] as! Int
                animation = clevel["animation"] as! Int
                numberOfBadSprite = clevel["numberOfBadSprite"] as! Int
                limitTime = clevel["limitTime"] as! Int
                shapesTypes = clevel["shapesTypes"] as! [String]
                uiColor = colorWithJson(clevel["uiColor"] as! [CGFloat])
                targetColor = colorWithJson(clevel["targetColor"] as! [CGFloat])
                backgroundColors = colorsWithJson(clevel["backgroundColors"] as! [[CGFloat]])
                shapesColor = colorsWithJson(clevel["shapesColor"] as! [[CGFloat]])
            } catch {
                print(error)
            }
        }
    }
    
    func colorWithJson(color : [CGFloat]) -> UIColor {
        return UIColor(red:color[0]/255, green:color[1]/255, blue:color[2]/255, alpha: 1)
    }
    
    func colorsWithJson(colors : [[CGFloat]]) -> [UIColor] {
        var uicolors : [UIColor] = []
        for color in colors {
            uicolors.append(colorWithJson(color))
        }
        return uicolors
    }
    
    
}
