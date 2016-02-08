//
//  FinishedViewController.swift
//  PlaceInTime
//
//  Created by knut on 08/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//
import AVFoundation
import Foundation
import UIKit

class FinishedViewController:UIViewController {
    
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[[String]] = []
    
    var userFbId:String!
    var correctAnswers:Int!
    var points:Int!
    var gametype:GameType!
    var challenge:Challenge!
    var client: MSClient?
    
    var activityLabel:UILabel!
    var backToMenuButton:UIButton!
    var resultLabel:UILabel!
    var resultHeader:UILabel!
    var audioPlayer = AVAudioPlayer()
    var resultBackground:UIView!
    
    let margin:CGFloat = 20
    let elementWidth:CGFloat = 200
    let elementHeight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        backToMenuButton = UIButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        backToMenuButton.addTarget(self, action: "backToMenuAction", forControlEvents: UIControlEvents.TouchUpInside)
        backToMenuButton.backgroundColor = UIColor.blueColor()
        backToMenuButton.layer.cornerRadius = 5
        backToMenuButton.layer.masksToBounds = true
        backToMenuButton.setTitle("Back to menu", forState: UIControlState.Normal)
        backToMenuButton.alpha = 0
        self.view.addSubview(self.backToMenuButton)
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.font = UIFont.boldSystemFontOfSize(24)
        activityLabel.numberOfLines = 2
        self.view.addSubview(activityLabel)
        
        if gametype == GameType.makingChallenge
        {
            activityLabel.text = "Sending challenge"
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundThread(background: {
                self.finishMakingChallenge()
                })
        }
        else if gametype == GameType.takingChallenge
        {
            if let takingChallenge = challenge as? TakingChallenge
            {
                activityLabel.text = "Sending result of\n\(takingChallenge.title!)"
                finishTakingChallenge(takingChallenge)
                
                setupResultHeader("Result of challenge \(takingChallenge.title!)")
                setupResultBackground()
                setupResultLabel()
                
                //sending result
                
                if correctAnswers > takingChallenge.correctAnswersToBeat
                {
                    youWonChallenge(takingChallenge)
                }
                else if correctAnswers == takingChallenge.correctAnswersToBeat && points > takingChallenge.pointsToBeat
                {
                    youWonChallenge(takingChallenge)
                }
                else if correctAnswers == takingChallenge.correctAnswersToBeat && points == takingChallenge.pointsToBeat
                {
                    youDrewChallenge(takingChallenge)
                }
                else
                {
                    youLostChallenge(takingChallenge)
                }
            }
            self.view.addSubview(self.backToMenuButton)
        }
        else if gametype == GameType.badgeChallenge
        {
            if let badgeChallenge = challenge as? BadgeChallenge
            {
                if badgeChallenge.won!
                {
                    badgeChallenge.setComplete()
                    setupResultHeader("New badge and \(badgeChallenge.hints) hints aquired 😀")
                }
                else
                {
                    setupResultHeader("You failed 😣")
                }
                setupResultBackground()
            }
            self.view.addSubview(self.backToMenuButton)
        }
        else
        {
            print("invalid GameType")
            self.view.addSubview(self.backToMenuButton)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if gametype == GameType.makingChallenge
        {
            self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
        }
        
        if gametype == GameType.badgeChallenge
        {
            if let badgeChallenge = challenge as? BadgeChallenge
            {
                if badgeChallenge.won!
                {
                    animateAquiredBadge()
                }
                else
                {
                    animateFailedBadge()
                }
            }
        }
    }
    
    func setupResultHeader(text:String)
    {
        let resultLabelMarigin = UIScreen.mainScreen().bounds.size.width * 0.1
        resultHeader = UILabel(frame: CGRectMake(resultLabelMarigin, 25, UIScreen.mainScreen().bounds.size.width - (resultLabelMarigin * 2) , 50))
        resultHeader.textAlignment = NSTextAlignment.Center
        resultHeader.font = UIFont.boldSystemFontOfSize(20)
        resultHeader.adjustsFontSizeToFitWidth = true
        resultHeader.text = text
        self.view.addSubview(resultHeader)
        
    }
    
    func setupResultBackground()
    {
        resultBackground = UIView(frame: CGRectMake(margin, resultHeader.frame.maxY , UIScreen.mainScreen().bounds.size.width - (margin * 2),  backToMenuButton.frame.minY - resultHeader.frame.maxY))
        resultBackground.backgroundColor = UIColor.whiteColor()
        resultBackground.layer.borderColor = UIColor.blueColor().CGColor
        resultBackground.layer.cornerRadius = 8
        resultBackground.layer.masksToBounds = true
        resultBackground.layer.borderWidth = 5.0
        self.view.addSubview(resultBackground)
    }
    
    func setupResultLabel()
    {
        let marginForLabel:CGFloat = 5
        resultLabel = UILabel(frame: CGRectMake(marginForLabel, marginForLabel, resultBackground.frame.width - (marginForLabel * 2),  resultBackground.frame.height - (marginForLabel * 2)))
        resultLabel.numberOfLines = 9
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.textColor = UIColor.blackColor()
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.backgroundColor = UIColor.whiteColor()
        resultBackground.addSubview(resultLabel)
    }
    
    func youLostChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lostChallenge", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You lost 😖\n\n" +
            "\(correctAnswers) correct answers" + "\n\(points) points" +
            "\nvs." +
            "\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    func youWonChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fanfare2", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You won 😆\n\n" +
        "\(correctAnswers) correct answers" + "\n\(points) points" +
        "\n\nagainst" +
        "\n\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    func youDrewChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fanfare2", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "Challenge ended as draw 😐\n\n" +
            "\(correctAnswers) correct answers" + "\n\(points) points" +
            "\n\nagainst" +
            "\n\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    func animateAquiredBadge()
    {
        if let badgeChallenge = challenge as? BadgeChallenge
        {
            let orgHeigth:CGFloat = 429
            let orgWidth:CGFloat = 370
            
            let badgeHeight = resultBackground.frame.height * 0.6
            let heightToWidthRatio = orgHeigth / badgeHeight
            let badgeWidth = orgWidth / heightToWidthRatio
            
            let badge = UIImageView(frame: CGRectMake((resultBackground.frame.width / 2) - (badgeWidth / 2), resultBackground.frame.height * 0.1 ,badgeWidth, badgeHeight))
            badge.image = badgeChallenge.image
            
            let badgeTitle = UILabel(frame: CGRectMake(10,badge.frame.maxY + 10,resultBackground.frame.width - 20,30 ))
            badgeTitle.adjustsFontSizeToFitWidth = true
            badgeTitle.font = UIFont.boldSystemFontOfSize(24)
            badgeTitle.text = badgeChallenge.title
            badge.transform = CGAffineTransformScale(badge.transform, 0.1, 0.1)
            badgeTitle.transform = CGAffineTransformScale(badgeTitle.transform, 0.1, 0.1)
            badgeTitle.textAlignment = NSTextAlignment.Center
            resultBackground.addSubview(badge)
            resultBackground.addSubview(badgeTitle)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                badge.alpha = 1
                badge.transform = CGAffineTransformIdentity
                badgeTitle.transform = CGAffineTransformIdentity
                //badge.center = self.resultBackground.center
                }, completion: { (value: Bool) in
                    self.backToMenuButton.alpha = 1
                    self.addHints()
            })
        }
    }
    
    func addHints()
    {
        if let badgeChallenge = challenge as? BadgeChallenge
        {
            var hintsLeftOnAccount = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
            hintsLeftOnAccount = hintsLeftOnAccount + badgeChallenge.hints
            NSUserDefaults.standardUserDefaults().setInteger(hintsLeftOnAccount, forKey: "hintsLeftOnAccount")
        }
    }
    
    func animateFailedBadge()
    {
        
        let badgeResultLabel = UILabel(frame: CGRectMake(0,0,resultBackground.frame.width, resultBackground.frame.height))
        badgeResultLabel.backgroundColor = UIColor.clearColor()
        badgeResultLabel.textColor = UIColor.blackColor()
        badgeResultLabel.numberOfLines = 3
        badgeResultLabel.textAlignment = NSTextAlignment.Center
        badgeResultLabel.alpha = 0
        badgeResultLabel.text = "Better luck next time\n\n😑"
        badgeResultLabel.transform = CGAffineTransformScale(badgeResultLabel.transform, 0.1, 0.1)
        resultBackground.addSubview(badgeResultLabel)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            badgeResultLabel.alpha = 1
            badgeResultLabel.transform = CGAffineTransformIdentity
            
            }, completion: { (value: Bool) in
                self.backToMenuButton.alpha = 1
        })
    }
    
    func finishMakingChallenge()
    {
        let makingChallenge = challenge as! MakingChallenge
        let challengeIds = makingChallenge.challengeIds
        
        let jsonDictionary = ["chidspar":challengeIds!,"fromId":userFbId,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishmakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.activityLabel.text = "Server error"
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alert = UIAlertView(title: "Server error", message: "Could not send challenge. Sorry for the annoyance.", delegate: nil, cancelButtonTitle: "OK")
                reportError?.reportError("\(error)",alert: alert)
            }
            if result != nil
            {
                
                print("\(result)")
                let temp = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                print("\(temp)")
                let numUsersChallenged = makingChallenge.usersToChallenge.count
                let alertText = numUsersChallenged > 1 ? "Challenge sendt to \(numUsersChallenged) users" : "Challenge sendt to \(numUsersChallenged) user"
                let alert = UIAlertView(title: "Sending challenge", message: alertText, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func finishTakingChallenge(takingChallenge:TakingChallenge)
    {
        let jsonDictionary = ["userfbid":userFbId,"challengeid":takingChallenge.id,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishtakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.backToMenuButton.alpha = 1
                let alert = UIAlertView(title: "Server error", message: "\(error)", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            if result != nil
            {
                print("\(result)")
                
                self.backToMenuButton.alpha = 1
                self.activityLabel.alpha = 0
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func usersToCommaseparatedString() -> String
    {
        var returnString:String = ""
        for item in usersIdsToChallenge
        {
            returnString += item + ","
            
        }
        return String(returnString.characters.dropLast())
    }
    
    func backToMenuAction()
    {
        self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromFinishedToMainMenu") {
            let svc = segue!.destinationViewController as! MainMenuViewController
            svc.updateGlobalGameStats = true
            svc.newGameStatsValues = (points,0,correctAnswers)
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }

}