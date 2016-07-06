//
//  Player.swift
//  Shapes
//
//  Created by Chloé Laugier on 29/02/2016.
//  Copyright © 2016 Chloé Laugier. All rights reserved.
//

import Foundation

class Player {
    static let sharedInstance = Player()
    var level : Int = 0
    var DEBUG : Int = -1
    
    init() {
        level = getStoredLevel()
    }

    
    func getStoredLevel() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let levelStored : Int? = defaults.integerForKey("level")
        {
            level = levelStored!
        }
        else {
            level = 0
        }
        return level
    }
    
    func setDebug() {
        level = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(level, forKey: "level")
    }
    
    
    
    func setLevel(l : Int) {
        if (DEBUG != -1) {
            level = DEBUG
        }
        else {
            if (l > level) {
                 level = l
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(level, forKey: "level")
        
        
    }
    
    
}
