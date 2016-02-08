//
//  RangeWindowsLayer.swift
//  TimeIt
//
//  Created by knut on 31/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import QuartzCore

class RangeWindowsLayer: CALayer {
    weak var rangeSlider: RangeSlider?

    var value:Double?

    
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {

            // Fill the highlighted range

            //CGContextSetFillColorWithColor(ctx, UIColor.greenColor().colorWithAlphaComponent(0.5).CGColor)
            //let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue + 1))
            //let upperValuePosition = CGFloat(slider.positionForValue(slider.lowerValue - 1))
            //let valuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
            
            
            //let testValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
            
            
            //println("\(valueUpperPosition) ---test \(testValuePosition)")
            
            if(value != nil)
            {
                
                let valuePosition = CGFloat(slider.positionForValue(value!))
                renderPosition(ctx,valuePosition: valuePosition)

            }

            
        }
    }
        
    func renderPosition(ctx:CGContext, valuePosition:CGFloat)
    {

        // + - 20%
        CGContextSetFillColorWithColor(ctx, UIColor(red: 0.6, green: 0.95, blue: 0.0, alpha: 1.0).CGColor)
        //let rect20 = CGRect(x: valuePosition - bounds.width * CGFloat(0.1), y: 0.0, width: bounds.width * CGFloat(0.2) , height: bounds.height)
        let rect20 = CGRect(x: valuePosition - bounds.width * CGFloat(GlobalConstants.highPercentWindow / 2), y: 0.0, width: bounds.width * CGFloat(GlobalConstants.highPercentWindow) , height: bounds.height)
        CGContextFillRect(ctx, rect20)
        
        
        // + - 10 %
        CGContextSetFillColorWithColor(ctx, UIColor(red: 0.5, green: 1, blue: 0.0, alpha: 1.0).CGColor)
        //let rect10 = CGRect(x: valuePosition - bounds.width * CGFloat(0.05), y: 0.0, width: bounds.width * CGFloat(0.1) , height: bounds.height)
        let rect10 = CGRect(x: valuePosition - bounds.width * CGFloat(GlobalConstants.lowPercentWindow / 2), y: 0.0, width: bounds.width * CGFloat(GlobalConstants.lowPercentWindow) , height: bounds.height)
        CGContextFillRect(ctx, rect10)
        
        //on the spot
        
        CGContextSetFillColorWithColor(ctx, UIColor.orangeColor().CGColor)
        let rect = CGRect(x: valuePosition - 2, y: 0.0, width: 4 , height: bounds.height)
        CGContextFillRect(ctx, rect)
    }
}
