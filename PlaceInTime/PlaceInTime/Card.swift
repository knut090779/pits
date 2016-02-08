//
//  Card.swift
//  PlaceInTime
//
//  Created by knut on 14/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit


class Card: UIView
{
    var textTitle: UILabel!
    var back:UIImageView!
    var dragging:Bool = false
    var event:HistoricEvent!
    var hint:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect, event:HistoricEvent){
        super.init(frame: frame)
        self.event = event
        self.backgroundColor = UIColor.grayColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        
        self.contentMode = UIViewContentMode.ScaleToFill
        self.clipsToBounds = false
        
        let hintHeight = self.frame.height * 0.17
        let hintWidth = self.frame.width * 0.35
        hint = UILabel(frame: CGRectMake(self.frame.width / 2, self.frame.height,hintWidth,hintHeight))
        hint.clipsToBounds = false
        hint.textAlignment = NSTextAlignment.Center
        hint.layer.cornerRadius = 3
        hint.backgroundColor = UIColor.blackColor()
        hint.layer.borderColor = UIColor.blackColor().CGColor
        hint.layer.borderWidth = 1
        hint.textColor = UIColor.whiteColor()
        hint.text = "\(event.toYear)"
        hint.alpha = 0
        hint.transform = CGAffineTransformScale(hint.transform, 0.1, 0.1)
        self.addSubview(hint)
        
        textTitle = UILabel(frame: CGRectMake(frame.width * 0.1, frame.height * 0.1, frame.width * 0.8, frame.height * 0.8))
        textTitle.textAlignment = NSTextAlignment.Left
        textTitle.numberOfLines = 6
        textTitle.adjustsFontSizeToFitWidth = true
        textTitle.text = event.title

        let backImage = UIImage(named: "back.png")
        
        back = UIImageView(image: imageResize(backImage!,sizeChange: CGSizeMake(frame.width,frame.height)))
        back.layer.cornerRadius = 5
        back.layer.masksToBounds = true
        back.userInteractionEnabled = true
        self.addSubview(back)

    }
    
    func setHint()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in

            self.hint.transform = CGAffineTransformIdentity
            self.hint.alpha = 1
            }, completion: { (value: Bool) in
        })
    }
    
    func tap()
    {
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.back.hidden = true
            self.addSubview(self.textTitle)
            }, completion: { (value: Bool) in
        })
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage
    {
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func randomOffsetAndRotation()
    {
        let yOffset:CGFloat = getRandomOffset()
        let xOffset:CGFloat = getRandomOffset()
        self.frame.offsetInPlace(dx: xOffset, dy: yOffset)
        self.transform = CGAffineTransformRotate(self.transform, self.getRandomRotation())
    }
    
    func getRandomRotation() -> CGFloat
    {
        let randomNum = Int(arc4random_uniform(UInt32(5)))
        if randomNum == 0
        {
            return -0.05
        }
        else if randomNum == 1
        {
            return -0.025
        }
        else if randomNum == 2
        {
            return 0
        }
        else if randomNum == 3
        {
            return 0.025
        }
        else
        {
            return 0.05
        }
    }
    
    func getRandomOffset() -> CGFloat
    {
        let randomNum = Int(arc4random_uniform(UInt32(3)))
        if randomNum == 0
        {
            return 1.5
        }
        else if randomNum == 1
        {
            return 1.8
        }
        else
        {
            return 2.1
        }
    }
}