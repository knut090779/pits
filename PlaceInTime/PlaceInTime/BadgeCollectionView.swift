//
//  BadgeView.swift
//  UsaFeud
//
//  Created by knut on 10/01/16.
//  Copyright © 2016 knut. All rights reserved.
//


import Foundation
import UIKit

protocol BadgeCollectionProtocol
{
    func playBadgeChallengeAction()
}

class BadgeCollectionView: UIView, BadgeChallengeProtocol {

    var scienceBadge1:BadgeView?
    var scienceBadge2:BadgeView?
    
    var delegate:BadgeCollectionProtocol?
    
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    
    var currentBadgeChallenge:BadgeChallenge?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func loadBadges()
    {
        let marginTopBottom:CGFloat = 6
        let marginRightLeft:CGFloat = 6
        
        let orgHeigth:CGFloat = 429
        let orgWidth:CGFloat = 370
        
        let badgeHeight = self.bounds.height - (marginTopBottom * 2)
        let heightToWidthRatio = orgHeigth / badgeHeight
        let badgeWidth = orgWidth / heightToWidthRatio
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapAction:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        let onTopMargin:CGFloat = badgeWidth * 0.6

        var lastXPos = marginRightLeft
        
        scienceBadge1 = BadgeView(frame: CGRectMake(lastXPos, marginTopBottom, badgeWidth, badgeHeight),title: "Science first class", image: "scienceBadge1.png")
        if !scienceBadge1!.complete
        {
            scienceBadge1!.delegate = self
            let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 3,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
            scienceBadge1!.setQuestions(blocksIds)
        }
        self.addSubview(scienceBadge1!)
        lastXPos = scienceBadge1!.frame.maxX
        
        if let badge = scienceBadge1 where badge.complete
        {
            scienceBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science second class", image: "scienceBadge2.png",hints:3)
            if !scienceBadge2!.complete
            {
                scienceBadge2!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 4,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
                scienceBadge2!.setQuestions(blocksIds)
            }
            self.addSubview(scienceBadge2!)
            lastXPos = scienceBadge2!.frame.maxX
        }
        
    }

    
    func setBadgeChallenge(badgeChallenge:BadgeChallenge)
    {
        currentBadgeChallenge = badgeChallenge
        delegate?.playBadgeChallengeAction()
        
    }
    
}