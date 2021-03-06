//
//  BadgeView.swift
//  UsaFeud
//
//  Created by knut on 11/01/16.
//  Copyright © 2016 knut. All rights reserved.
//
import Foundation
import UIKit

protocol BadgeChallengeProtocol
{
    func setBadgeChallenge(badgeChallenge:BadgeChallenge)
}

class BadgeView: UIView, UIAlertViewDelegate {
    
    
    //var hintsLeftText:UILabel!
    
    var imageView:UIImageView!
    var overlapImageView:UIImageView!
    var complete:Bool = false
    var badgeChallenge:BadgeChallenge!
    var delegate:BadgeChallengeProtocol?
    var title:String!
    var hints:Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,title:String, image:String, hints:Int = 2) {
        super.init(frame: frame)
        
        self.title = title
        self.hints = hints
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapBadge:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(named: image)
        
        
        complete = NSUserDefaults.standardUserDefaults().boolForKey(title)
        

        self.addSubview(imageView)
        
        if !complete
        {
            overlapImageView = UIImageView(frame: self.bounds)
            overlapImageView.image = UIImage(named: "overmapBadge.png")
            overlapImageView.alpha = 0.65
            self.addSubview(overlapImageView)
            
            let overlapImageViewBlueRim = UIImageView(frame: self.bounds)
            overlapImageViewBlueRim.image = UIImage(named: "overmapBadgeSelect2.png")
            self.addSubview(overlapImageViewBlueRim)
        }
        
        let firsttry = NSUserDefaults.standardUserDefaults().boolForKey("\(title)firsttry")
        if !firsttry
        {
            let newLabel = UILabel(frame: CGRectMake(0,self.bounds.height * 0.66, self.bounds.width,self.bounds.height * 0.33))
            newLabel.text = "🆕"
            newLabel.textAlignment = NSTextAlignment.Right
            self.addSubview(newLabel)
        }
        
        badgeChallenge = BadgeChallenge(title: title, image: image,hints:hints)
        
        self.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    func setQuestions(questions:[[String]])
    {
        badgeChallenge.questionBlocks = questions
    }
    
    func tapBadge(gesture:UITapGestureRecognizer)
    {
        if !complete
        {
            let alert = UIAlertView(title: badgeChallenge.title, message: "Take this challenge to earn a new badge and \(hints) hints", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
            
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "\(title)firsttry")
            delegate?.setBadgeChallenge(badgeChallenge)
        }
    }

    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let ecount = list.count
        for i in 0..<(ecount - 1) {
            let j = Int(arc4random_uniform(UInt32(ecount - i))) + i
            if j != i {
                swap(&list[i], &list[j])
            }
        }
        return list
    }
    
}