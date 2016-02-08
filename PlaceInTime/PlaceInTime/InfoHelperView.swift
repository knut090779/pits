//
//  InfoHelperView.swift
//  PlaceInTime
//
//  Created by knut on 28/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class InfoHelperView: UIView {
    
    var infoLabelLeft:UILabel!
    var infoLabelMain:UILabel!
    var infoLabelRight:UILabel!
    
    var arrowUp:UILabel!
    var arrowDown:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()

        infoLabelLeft = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.45, self.bounds.height / 2 ))
        infoLabelLeft.textAlignment = NSTextAlignment.Center
        //infoLabelLeft.adjustsFontSizeToFitWidth = true
        infoLabelLeft.transform = CGAffineTransformScale(infoLabelLeft.transform, 0.7, 0.7)
        infoLabelLeft.center = CGPointMake(self.bounds.width * 0.25, self.bounds.height * 0.75)
        infoLabelLeft.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        infoLabelLeft.alpha = 0.75
        infoLabelLeft.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        infoLabelMain = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.80, self.bounds.height / 2))
        infoLabelMain.textAlignment = NSTextAlignment.Center
        //infoLabelMain.adjustsFontSizeToFitWidth = true
        infoLabelMain.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        infoLabelMain.center = CGPointMake(self.bounds.width / 2, self.bounds.height * 0.25)
        infoLabelMain.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        infoLabelRight = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.45, self.bounds.height / 2))
        infoLabelRight.textAlignment = NSTextAlignment.Center
        //infoLabelRight.adjustsFontSizeToFitWidth = true
        infoLabelRight.transform = CGAffineTransformScale(infoLabelRight.transform, 0.7, 0.7)
        infoLabelRight.center = CGPointMake(self.bounds.width * 0.75, self.bounds.height * 0.75)
        infoLabelRight.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        infoLabelRight.alpha = 0.75
        infoLabelRight.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        arrowUp = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.1, self.bounds.width * 0.1))
        arrowUp.textAlignment = NSTextAlignment.Center
        arrowUp.text = "⇨"
        arrowUp.transform = CGAffineTransformScale(arrowUp.transform, 1.5, 1)
        arrowUp.transform = CGAffineTransformRotate(arrowUp.transform, -0.75)
        arrowUp.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        arrowUp.center = CGPointMake(infoLabelLeft.frame.maxX, infoLabelLeft.center.y - (arrowUp.frame.height / 3))
        
        
        arrowDown = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.1, self.bounds.width * 0.1))
        arrowDown.textAlignment = NSTextAlignment.Center
        arrowDown.text = "⇨"
        arrowDown.transform = CGAffineTransformScale(arrowDown.transform, 1.5, 1)
        arrowDown.transform = CGAffineTransformRotate(arrowDown.transform, 0.75)
        arrowDown.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        arrowDown.center = CGPointMake(infoLabelRight.frame.minX, infoLabelRight.center.y - (arrowDown.frame.height / 3))
        
        self.addSubview(arrowUp)
        self.addSubview(arrowDown)
        self.addSubview(infoLabelLeft)
        self.addSubview(infoLabelMain)
        self.addSubview(infoLabelRight)
    }
    
    
    func setText(left:String?,main:String,right:String?)
    {
        infoLabelLeft.text = left ?? ""
        arrowUp.alpha = left == nil ? 0 : 1
        infoLabelMain.text = main
        infoLabelRight.text = right ?? ""
        arrowDown.alpha = right == nil ? 0 : 1
    }
}
