//
//  DropZoneView.swift
//  PlaceInTime
//
//  Created by knut on 17/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

protocol DropZoneProtocol
{
    func gettingFocus(sender:DropZone)
    
}

class DropZone: UIView {
    
    var focus:Bool = false
    //var focusDisplayView:UIView!
    var key:Int!
    var frontFocus:Bool = false
    var lastHookedUpCard:Card?
    private var hookedUpCard:Card?
    var delegate:DropZoneProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect, key:Int){
        super.init(frame: frame)
        
        self.key = key

        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        //self.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        
    }
    
    
    func setHookedUpCard(card:Card?)
    {
        lastHookedUpCard = hookedUpCard
        hookedUpCard = card
        if let card = hookedUpCard
        {
            card.center = self.center
        }
    }
    
    func resetHookedUpCard()
    {
        hookedUpCard = lastHookedUpCard
        lastHookedUpCard = nil
        if let card = hookedUpCard
        {
            card.center = self.center
        }
    }
    
    func getHookedUpCard() -> Card?
    {
        return hookedUpCard
    }
    
    
    func giveFocus()
    {
        if focus == false
        {
            self.alpha = 0.0
            focus = true
        }
    }
    
    func removeFocus()
    {
        if focus
        {
            self.alpha = 1.0
            focus = false
        }
    }
    
    
}