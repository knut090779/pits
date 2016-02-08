//
//  UseHintButton.swift
//  PlaceInTime
//
//  Created by knut on 11/12/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class UseHintButton:UIButton {
    
    var innerView:UILabel!
    var label:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
        
        
        innerView = UILabel(frame: CGRectMake(0 ,0, self.bounds.width * 0.8,self.bounds.width * 0.8))
        innerView.backgroundColor = UIColor.clearColor()
        let hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        if hintsLeftOnAccount <= 0
        {
            innerView.text = "Buy\nHints"
            self.backgroundColor = UIColor.lightGrayColor()
            self.userInteractionEnabled = false
            self.layer.borderColor = UIColor.grayColor().CGColor
        }
        else
        {
            innerView.text = "Hint\n❕"
            self.backgroundColor = UIColor.blueColor()
            self.layer.borderColor = UIColor.blueColor().CGColor
            self.userInteractionEnabled = true
        }
        innerView.textColor = UIColor.whiteColor()
        innerView.adjustsFontSizeToFitWidth = true
        innerView.numberOfLines = 2
        innerView.textAlignment = NSTextAlignment.Center
        innerView.font = UIFont.boldSystemFontOfSize(24)
        innerView.center = CGPointMake(self.bounds.width / 2, self.bounds.height / 2)
        self.addSubview(innerView)

    }
    
    func showButton()
    {
        let hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        if hintsLeftOnAccount <= 0
        {
            innerView.text = "Buy\nHints"
            self.backgroundColor = UIColor.lightGrayColor()
            self.userInteractionEnabled = false
            self.layer.borderColor = UIColor.grayColor().CGColor
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1
                }, completion: { (value: Bool) in
                    UIView.animateWithDuration(1, delay: 2.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1)
                        self.alpha = 0
                        }, completion: { (value: Bool) in
                    })
            })
            
            
        }
        else
        {
            innerView.text = "Hint\n❕"
            self.backgroundColor = UIColor.blueColor()
            self.layer.borderColor = UIColor.blueColor().CGColor
            self.userInteractionEnabled = true
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1
            })
        }

    }
    
    func deductHints()
    {
        var hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        hintsLeftOnAccount--
        NSUserDefaults.standardUserDefaults().setInteger(hintsLeftOnAccount, forKey: "hintsLeftOnAccount")
    }
    
    func hideButton()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1)
            self.alpha = 0
        })
    }
}