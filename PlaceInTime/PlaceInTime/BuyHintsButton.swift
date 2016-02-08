//
//  BuyHintsButton.swift
//  PlaceInTime
//
//  Created by knut on 12/12/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class BuyHintsButton:UIButton {
    
    var label:UILabel!
    var innerView:UILabel!
    var plusSignView:UILabel!
    var numberOfHints:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        innerView = UILabel(frame: CGRectMake(self.bounds.width * 0.1 ,self.bounds.width * 0.1, self.bounds.width * 0.8,self.bounds.width * 0.8))
        innerView.text = "❕"
        innerView.layer.borderColor = UIColor.blueColor().CGColor
        innerView.textAlignment = NSTextAlignment.Center
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.bounds.size.width / 2
        innerView.layer.masksToBounds = true
        self.addSubview(innerView)
        
        plusSignView = UILabel(frame: CGRectMake(0 ,self.bounds.width * 0.1, self.bounds.width * 0.3,self.bounds.width * 0.3))
        plusSignView.font = UIFont.boldSystemFontOfSize(15)
        plusSignView.backgroundColor = UIColor.blueColor()
        plusSignView.adjustsFontSizeToFitWidth = true
        plusSignView.textColor = UIColor.whiteColor()
        plusSignView.layer.borderColor = UIColor.blueColor().CGColor
        plusSignView.textAlignment = NSTextAlignment.Center
        plusSignView.layer.borderWidth = 1
        plusSignView.layer.cornerRadius = plusSignView.bounds.size.width / 2
        plusSignView.layer.masksToBounds = true
        plusSignView.text = "+"
        self.addSubview(plusSignView)
        
        
        let hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        numberOfHints = UILabel(frame: CGRectMake(self.bounds.width * 0.6 ,self.bounds.width * 0.6, self.bounds.width * 0.4,self.bounds.width * 0.4))
        if hintsLeftOnAccount == 0
        {
            numberOfHints.text = "+"
        }
        else
        {
            numberOfHints.text = "\(hintsLeftOnAccount)"
        }
        numberOfHints.backgroundColor = UIColor.blueColor()
        numberOfHints.adjustsFontSizeToFitWidth = true
        numberOfHints.textColor = UIColor.whiteColor()
        numberOfHints.layer.borderColor = UIColor.blueColor().CGColor
        numberOfHints.textAlignment = NSTextAlignment.Center
        numberOfHints.layer.borderWidth = 2
        numberOfHints.layer.cornerRadius = numberOfHints.bounds.size.width / 2
        numberOfHints.layer.masksToBounds = true
        self.addSubview(numberOfHints)
    }
    
    func addHints()
    {
        var hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        hintsLeftOnAccount = hintsLeftOnAccount + GlobalConstants.numberOfHintsPrBuy
        NSUserDefaults.standardUserDefaults().setInteger(hintsLeftOnAccount, forKey: "hintsLeftOnAccount")
        numberOfHints.text = "\(hintsLeftOnAccount)"
    }
}
