//
//  SKTexture+Gradient.swift
//  Shapes
//
//  Created by Chloé Laugier on 17/03/2016.
//  Copyright © 2016 Chloé Laugier. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTexture {
    
    
    convenience init(size: CGSize, firstColor: UIColor, lastColor: UIColor) {
        
        guard let gradientFilter = CIFilter(name: "CILinearGradient") else {
            self.init()
            return
        }
        
        gradientFilter.setDefaults()
        
        let startVector = CIVector(x: size.width/2.0, y: 0)
        let endVector = CIVector(x: size.width/2.0, y: size.height)
        gradientFilter.setValue(startVector, forKey: "inputPoint0")
        gradientFilter.setValue(endVector, forKey: "inputPoint1")
        
        let transformedFirstColor = CIColor(color: firstColor)
        let transformedLastColor = CIColor(color: lastColor)
        gradientFilter.setValue(transformedFirstColor, forKey: "inputColor1")
        gradientFilter.setValue(transformedLastColor, forKey: "inputColor0")
        
        guard let outputImage = gradientFilter.outputImage else {
            self.init()
            return
        }
        
        let context = CIContext()
        let image = context.createCGImage(outputImage, fromRect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        self.init(CGImage: image)
    }
}