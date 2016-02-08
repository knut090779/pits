//
//  BuyHintsButton.swift
//  PlaceInTime
//
//  Created by knut on 12/12/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class BuyAdFreeButton:UIButton {
    
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
        innerView.text = "☂"
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

    }
}
