//
//  ViewController.swift
//  PlaceInTime
//
//  Created by knut on 12/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore
import iAd
import StoreKit

class MainMenuViewController: UIViewController, CheckViewProtocol , ADBannerViewDelegate, HolderViewDelegate,  BadgeCollectionProtocol{

    var backgroundView:UIView!
    var practiceButton:MenuButton!
    var buyHintsButton:BuyHintsButton!
    var backButton:UIButton!
    var selectFilterTypeButton:UIButton!
    var practicePlayButtonExstraLabel:UILabel!
    var practicePlayButton:UIButton!
    var loadingDataView:UIView!
    var loadingDataLabel:UILabel!
    var tagsScrollViewEnableBackground:UIView!
    var tagsScrollView:CheckScrollView!
    var globalGameStats:GameStats!
    var updateGlobalGameStats:Bool = false
    var newGameStatsValues:(Int,Int,Int)!
    let levelSlider = RangeSlider(frame: CGRectZero)
    var gametype:GameType!
    
    var tags:[String] = []
    var holderView = HolderView(frame: CGRectZero)
    let queue = NSOperationQueue()
    
    let marginButtons:CGFloat = 10
    
    var badgeCollectionView:BadgeCollectionView!
    var orgBadgeCollectionViewCenter:CGPoint!
    var datactrl:DataHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        let buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.5
        var buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.2

        practiceButton = MenuButton(frame:CGRectMake(UIScreen.mainScreen().bounds.size.width * 0.5 - (buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.5 - (buttonHeight / 2), buttonWidth, buttonHeight),title:"Practice")
        practiceButton.addTarget(self, action: "practiceAction", forControlEvents: UIControlEvents.TouchUpInside)
        practiceButton.alpha = 0
        
        buyHintsButton = BuyHintsButton(frame:CGRectMake( marginButtons, practiceButton.frame.minY, GlobalConstants.smallButtonSide * 1.5 , GlobalConstants.smallButtonSide * 1.5))
        buyHintsButton.addTarget(self, action: "requestBuyHints", forControlEvents: UIControlEvents.TouchUpInside)
        
        let badgeViewHeight:CGFloat = practiceButton.frame.height * 1.5
        badgeCollectionView = BadgeCollectionView(frame: CGRectMake(0, practiceButton.frame.maxY + marginButtons, UIScreen.mainScreen().bounds.width, badgeViewHeight))
        badgeCollectionView.delegate = self
        self.view.addSubview(badgeCollectionView)
        orgBadgeCollectionViewCenter = badgeCollectionView.center

        
        buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.3

        practicePlayButton = UIButton(frame:CGRectZero)
        practicePlayButton.setTitle("Practice", forState: UIControlState.Normal)
        practicePlayButton.addTarget(self, action: "playPracticeAction", forControlEvents: UIControlEvents.TouchUpInside)
        practicePlayButton.backgroundColor = UIColor.blueColor()
        practicePlayButton.layer.cornerRadius = 5
        practicePlayButton.layer.masksToBounds = true

        practicePlayButtonExstraLabel = UILabel(frame:CGRectZero)
        practicePlayButtonExstraLabel.backgroundColor = practicePlayButton.backgroundColor?.colorWithAlphaComponent(0)
        practicePlayButtonExstraLabel.textColor = UIColor.whiteColor()
        practicePlayButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        practicePlayButtonExstraLabel.textAlignment = NSTextAlignment.Center
        practicePlayButton.addSubview(practicePlayButtonExstraLabel)

        levelSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        levelSlider.curvaceousness = 0.0
        levelSlider.maximumValue = Double(GlobalConstants.maxLevel) + 0.5
        levelSlider.minimumValue = Double(GlobalConstants.minLevel)
        levelSlider.typeValue = sliderType.bothLowerAndUpper

        selectFilterTypeButton = UIButton(frame: CGRectZero)
        selectFilterTypeButton.setTitle("📋", forState: UIControlState.Normal)
        selectFilterTypeButton.addTarget(self, action: "openFilterList", forControlEvents: UIControlEvents.TouchUpInside)
        selectFilterTypeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        
        practicePlayButton.alpha = 0
        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0

        self.view.addSubview(practiceButton)
        self.view.addSubview(buyHintsButton)
        self.view.addSubview(practicePlayButton)
        self.view.addSubview(levelSlider)
        self.view.addSubview(selectFilterTypeButton)
        
        globalGameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.4, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: Int(datactrl.okScoreValue as! NSNumber),goodScore: Int(datactrl.goodScoreValue as! NSNumber),loveScore: Int(datactrl.loveScoreValue as! NSNumber))
        self.view.addSubview(globalGameStats)
        
        setupCheckboxView()
        setupFirstLevelMenu()
        setupPlayButton()

        if firstLaunch
        {
            if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
            {
                loadingDataLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
                loadingDataLabel.text = "Loading data.."
                loadingDataLabel.textAlignment = NSTextAlignment.Center
                loadingDataView = UIView(frame: CGRectMake(50, 50, 200, 50))
                loadingDataView.backgroundColor = UIColor.redColor()
                loadingDataView.addSubview(loadingDataLabel)
                self.view.addSubview(loadingDataView)
                
                let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = 100
                pulseAnimation.delegate = self
                loadingDataView.layer.addAnimation(pulseAnimation, forKey: "asd")
            }
        }
        else
        {
            self.practiceButton.alpha = 1
            self.badgeCollectionView.alpha = 1
            self.badgeCollectionView.loadBadges()
        }
        
        updateBadges()
        
        let backButtonMargin:CGFloat = 10
        backButton = UIButton(frame: CGRectZero)
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - GlobalConstants.smallButtonSide - backButtonMargin, backButtonMargin, GlobalConstants.smallButtonSide, GlobalConstants.smallButtonSide)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.layer.borderColor = UIColor.grayColor().CGColor
        backButton.layer.borderWidth = 2
        backButton.layer.cornerRadius = backButton.frame.width / 2
        backButton.layer.masksToBounds = true
        backButton.setTitle("🔙", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)

        
    }
    
    //MARK: controller lifecycle events
    
    override func viewDidAppear(animated: Bool) {

        if NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        {
            holderView = HolderView(frame: view.bounds)
            holderView.delegate = self
            view.addSubview(holderView)
            holderView.startAnimation()
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstlaunch")
        }
        
        if updateGlobalGameStats
        {
            globalGameStats.addOkPoints(newGameStatsValues.0, completionOKPoints: { () in
                
                self.globalGameStats.addLovePoints(self.newGameStatsValues.2, completionLovePoints: { () in
                    self.updateGlobalGameStats = false
                    self.datactrl.updateGameData(self.newGameStatsValues.0,deltaGoodPoints: self.newGameStatsValues.1,deltaLovePoints: self.newGameStatsValues.2)
                    self.datactrl.saveGameData()
                })
                
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
    }
    
    func enterForground()
    {
        updateBadges()
    }

    func loadScreenFinished() {
        self.view.backgroundColor = UIColor.whiteColor()
        holderView.alpha = 0
        practiceButton.transform = CGAffineTransformScale(practiceButton.transform, 0.1, 0.1)
        badgeCollectionView.transform = CGAffineTransformScale(badgeCollectionView.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.practiceButton.alpha = 1
            self.badgeCollectionView.alpha = 1
            self.practiceButton.transform = CGAffineTransformIdentity
            self.badgeCollectionView.transform = CGAffineTransformIdentity
            })
        
        populateDataIfNeeded()
        
        self.badgeCollectionView.loadBadges()
    }
    
    func populateDataIfNeeded()
    {
        if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
        {
            
            datactrl.populateData({ () in
                
                self.loadingDataView.alpha = 0
                self.loadingDataView.layer.removeAllAnimations()
            })
            
            loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    func setupFirstLevelMenu()
    {
        practiceButton.orgCenter = practiceButton.center
    }
    
    func setupPlayButton()
    {
        let margin: CGFloat = 20.0
        let sliderAndFilterbuttonHeight:CGFloat = 31.0

        let playbuttonWidth = practiceButton.frame.width
        let playbuttonHeight = practiceButton.frame.height * 2

        
        practicePlayButton.frame = CGRectMake(self.practiceButton.frame.minX, self.practiceButton.frame.minY,playbuttonWidth, playbuttonHeight)
        let marginSlider: CGFloat = practicePlayButton.frame.minX

        
        practicePlayButtonExstraLabel.frame = CGRectMake(0, practicePlayButton.frame.height * 0.7   , practicePlayButton.frame.width, practicePlayButton.frame.height * 0.15)
        practicePlayButtonExstraLabel.text = "Level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
        
        levelSlider.frame = CGRect(x:  marginSlider, y: practicePlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (practicePlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
        
        selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, practicePlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)

        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: slider
    
    func sliderUpperLevelText() -> String
    {
        return Int(levelSlider.upperValue) > 2 ? "ridiculous" : "\(Int(levelSlider.upperValue))"
    }
    
    func rangeSliderValueChanged(slider: RangeSlider) {
        if Int(slider.lowerValue) == Int(slider.upperValue)
        {
            let text = "Level \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
        }
        else
        {
            let text = "Level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
        }
    }
    
    //MARK: button events
    
    func backAction()
    {
        backButton.alpha = 0
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.practiceButton.center = self.practiceButton.orgCenter
            self.practiceButton.alpha = 1
            self.practiceButton.transform = CGAffineTransformIdentity
            self.badgeCollectionView.center = self.orgBadgeCollectionViewCenter
            self.badgeCollectionView.alpha = 1
            self.badgeCollectionView.transform = CGAffineTransformIdentity
            self.practicePlayButton.alpha = 0
            self.levelSlider.alpha = 0
            self.selectFilterTypeButton.alpha = 0
            })
    }
    
    func newChallengeAction()
    {
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.backButton.alpha = 1
            }, completion: { (value: Bool) in
                self.levelSlider.alpha = 1

                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.levelSlider.transform = CGAffineTransformIdentity
 
                    }, completion: { (value: Bool) in
                        
                })
        })
    }
    
    func playBadgeChallengeAction()
    {
        gametype = GameType.badgeChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }
    
    func practiceAction()
    {
        self.practicePlayButton.alpha = 0
        self.practicePlayButton.transform = CGAffineTransformScale(self.practicePlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)

        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.badgeCollectionView.center = centerScreen
            self.badgeCollectionView.transform = CGAffineTransformScale(self.badgeCollectionView.transform, 0.1, 0.1)
            
            self.backButton.alpha = 1
            
            }, completion: { (value: Bool) in
                self.practiceButton.alpha = 0
                self.badgeCollectionView.alpha = 0
                self.practicePlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.practicePlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                })
        })
    }

    
    
    func playPracticeAction()
    {
        datactrl.fetchData(tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        
        gametype = GameType.training
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }
    
    func playNewChallengeAction()
    {
        datactrl.fetchData(tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        
        gametype = GameType.makingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func pendingChallengesAction()
    {
        gametype = GameType.takingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func resultAction()
    {
        self.performSegueWithIdentifier("segueFromResultsToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromMainMenuToPlay") {
            let svc = segue!.destinationViewController as! PlayViewController
            svc.gametype = gametype
            if gametype == GameType.badgeChallenge
            {
                svc.challenge = badgeCollectionView.currentBadgeChallenge
            }
        }
    }

    func addHints()
    {
        buyHintsButton.addHints()
    }
    
    func requestBuyHints()
    {
        self.addHints()
    }
    
    //MARK: TagCheckViewProtocol
    var listClosed = true
    func closeCheckView(sender:CheckScrollView)
    {
        if listClosed
        {
            return
        }
        let minAllowedSelectedTags:Int = 2
        if self.tags.count < minAllowedSelectedTags
        {
            let numberPrompt = UIAlertController(title: "Pick \(minAllowedSelectedTags)",
                message: "Select at least \(minAllowedSelectedTags) tags",
                preferredStyle: .Alert)

            
            numberPrompt.addAction(UIAlertAction(title: "Ok",
                style: .Default,
                handler: { (action) -> Void in
                    
            }))
            
            
            self.presentViewController(numberPrompt,
                animated: true,
                completion: nil)
        }
        else
        {
            
            let rightLocation = sender.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                sender.transform = CGAffineTransformScale(sender.transform, 0.1, 0.1)
                
                sender.center = self.selectFilterTypeButton.center
                }, completion: { (value: Bool) in
                    sender.transform = CGAffineTransformScale(sender.transform, 0.1, 0.1)
                    sender.alpha = 0
                    sender.center = rightLocation
                    self.listClosed = true
                    self.tagsScrollViewEnableBackground.alpha = 0
            })
        }
    }
    
    func reloadMarks(tags:[String])
    {
        self.tags = tags
    }
    
    func setupCheckboxView()
    {
        //let bannerViewHeight = bannerView != nil ? bannerView!.frame.height : 0
        let bannerViewHeight:CGFloat = 0
        tagsScrollViewEnableBackground = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - bannerViewHeight))
        tagsScrollViewEnableBackground.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        tagsScrollViewEnableBackground.alpha = 0
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width * 0.6
        let orientation = UIDevice.currentDevice().orientation
        if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        {
            scrollViewWidth = UIScreen.mainScreen().bounds.size.width / 2
        }
        let values:[String:String] = ["#science":"#science","#discovery":"#discovery","#invention":"#invention","#sport":"#sport"]
        tagsScrollView = CheckScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , UIScreen.mainScreen().bounds.size.height / 4, scrollViewWidth, UIScreen.mainScreen().bounds.size.height / 2), initialValues: values,itemsName: "tag",itemsChecked:true)

        tagsScrollView.delegate = self
        tagsScrollView.alpha = 0
        tagsScrollViewEnableBackground.addSubview(tagsScrollView!)
        view.addSubview(tagsScrollViewEnableBackground)
    }
    
    func openFilterList()
    {
        let rightLocation = tagsScrollView.center
        tagsScrollView.transform = CGAffineTransformScale(tagsScrollView.transform, 0.1, 0.1)
        self.tagsScrollView.alpha = 1
        tagsScrollView.center = selectFilterTypeButton.center
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.tagsScrollViewEnableBackground.alpha = 1
            self.tagsScrollView.transform = CGAffineTransformIdentity
            
            self.tagsScrollView.center = rightLocation
            }, completion: { (value: Bool) in
                self.tagsScrollView.transform = CGAffineTransformIdentity
                self.tagsScrollView.alpha = 1
                self.tagsScrollView.center = rightLocation
                self.listClosed = false
        })
    }
    
    //MARK: button badge
    
    func updateBadges()
    {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.recieveNumberOfResultsNotDownloaded()
        }
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.recieveNumberOfPendingChallenges()
        }
    }
    
    func recieveNumberOfResultsNotDownloaded()
    {
        let currentbadge = NSUserDefaults.standardUserDefaults().integerForKey("resultsBadge")
        if currentbadge == 0
        {
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken")
            {
                if token == ""
                {
                    return
                }
                let client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
                let jsonDictionaryHandle = ["token":token]
                client!.invokeAPI("idleresults", data: nil, HTTPMethod: "GET", parameters: jsonDictionaryHandle as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
                    
                    
                    if error != nil
                    {
                        print("\(error)")
                        let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                        reportError?.reportError("\(error)")

                    }
                    if result != nil
                    {
                        var resultsBadge = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                        resultsBadge = String(resultsBadge.characters.dropLast().dropFirst())
                        print(resultsBadge)
                        let resultsBadgeInt = Int(resultsBadge)

                        dispatch_async(dispatch_get_main_queue()) {
                            //self.resultsButton.setbadge(resultsBadgeInt!)
                        }
                        
                    }
                    if response != nil
                    {
                        print("\(response)")
                    }
                    
                    
                })
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue()) {
                //self.resultsButton.setbadge(currentbadge)
            }
        }
    }
    
    func recieveNumberOfPendingChallenges()
    {
        
        let currentbadge = NSUserDefaults.standardUserDefaults().integerForKey("challengesBadge")
        if currentbadge == 0
        {
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken")
            {
                if token == ""
                {
                    return
                }
                
                let client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
                let jsonDictionaryHandle = ["token":token]
                client!.invokeAPI("pendingchallenges", data: nil, HTTPMethod: "GET", parameters: jsonDictionaryHandle as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
                    
                    
                    if error != nil
                    {
                        print("\(error)")
                        
                        let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                        reportError?.reportError("\(error)")

                    }
                    if result != nil
                    {
                        var resultsBadge = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                        resultsBadge = String(resultsBadge.characters.dropLast().dropFirst())
                        
                        let resultsBadgeInt = Int(resultsBadge)
                        print(resultsBadgeInt)
                        dispatch_async(dispatch_get_main_queue()) {
                            //self.challengeUsersButton.setbadge(resultsBadgeInt!)
                            //self.pendingChallengesButton.setbadge(resultsBadgeInt!)
                        }
                    }
                    if response != nil
                    {
                        print("\(response)")
                    }
                    
                    
                })
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue()) {
                //self.challengeUsersButton.setbadge(currentbadge)
                //self.pendingChallengesButton.setbadge(currentbadge)
            }
        }
        
    }
    
    //MARK: orientation
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }

}

