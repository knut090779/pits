//
//  BuyHintsButton.swift
//  PlaceInTime
//
//  Created by knut on 12/12/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class ResultButton:UIButton {
    
    var label:UILabel!
    var innerView:UILabel!
    var numberBadge:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        innerView = UILabel(frame: CGRectMake(self.bounds.width * 0.1 ,self.bounds.width * 0.1, self.bounds.width * 0.8,self.bounds.width * 0.8))
        innerView.text = "📋"
        innerView.layer.borderColor = UIColor.blueColor().CGColor
        innerView.textAlignment = NSTextAlignment.Center
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.bounds.size.width / 2
        innerView.layer.masksToBounds = true
        self.addSubview(innerView)
        
        
        numberBadge = UILabel(frame: CGRectMake(self.bounds.width * 0.6 ,self.bounds.width * 0.6, self.bounds.width * 0.4,self.bounds.width * 0.4))
        numberBadge.text = ""
        numberBadge.alpha = 0

        numberBadge.backgroundColor = UIColor.blueColor()
        numberBadge.adjustsFontSizeToFitWidth = true
        numberBadge.textColor = UIColor.whiteColor()
        numberBadge.layer.borderColor = UIColor.blueColor().CGColor
        numberBadge.textAlignment = NSTextAlignment.Center
        numberBadge.layer.borderWidth = 2
        numberBadge.layer.cornerRadius = numberBadge.bounds.size.width / 2
        numberBadge.layer.masksToBounds = true
        self.addSubview(numberBadge)
    }
    
    func setbadge(currentbadge:Int)
    {
        numberBadge.alpha = currentbadge > 0 ?  1 : 0
        numberBadge.text = "\(currentbadge)"
    }
}
