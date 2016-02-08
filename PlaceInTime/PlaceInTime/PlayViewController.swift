//
//  PlayViewController.swift
//  PlaceInTime
//
//  Created by knut on 12/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//
import AVFoundation
import UIKit
import iAd

class PlayViewController:UIViewController,  DropZoneProtocol, ClockProtocol, ADBannerViewDelegate
{
    var gameStats:GameStats!
    var cardsStack:[Card] = []
    var backOfCard:UIImageView!
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    var dropZones:[Int:DropZone] = [:]
    
    var infoHelperView:InfoHelperView!
    var clock:ClockView!
    var orgClockCenter:CGPoint!
    var originalDropZoneYCenter:CGFloat!
    var numberOfDropZones:Int = 3
    var rightButton:UIButton!
    
    var cardToDrag:Card? = nil
    var newRevealedCard:Card? = nil
    let marginFromGamestats:CGFloat = 10
    var gametype:GameType!
    let backButton = UIButton()
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[[String]] = []
    var myIdAndName:(String,String)!
    
    var challenge:Challenge!
    
    var audioPlayer = AVAudioPlayer()
    var cardInnSoundAudioPlayerPool:[AVAudioPlayer] = []
    var cardOutSoundAudioPlayerPool:[AVAudioPlayer] = []
    var wrongSoundAudioPlayerPool:[AVAudioPlayer] = []
    var correctSoundAudioPlayerPool:[AVAudioPlayer] = []
    var timeIsUpSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("timeUp", ofType: "mp3")!)
    var dealCardSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dealingCard", ofType: "wav")!)
    var wrongSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sigh", ofType: "wav")!)
    var correctSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yeah", ofType: "wav")!)
    var correctSequenceSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yeah-short", ofType: "mp3")!)
    
    var numberOfRoundsDone = 0
    var questionsLeftFrame:CGRect?
    var bannerView:ADBannerView?
    var useHintButton:UseHintButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if !adFree
        {
            self.canDisplayBannerAds = true
            bannerView = ADBannerView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
            bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
            self.view.addSubview(bannerView!)
            self.bannerView?.delegate = self
            self.bannerView?.hidden = false
        }
        gameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.4, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: 0,goodScore: 0,loveScore: 0)
        self.view.addSubview(gameStats)
        
        clock = ClockView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width * 0.75, 10, gameStats.frame.height * 1.5, gameStats.frame.height * 1.5))

        orgClockCenter = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.75 ,self.marginFromGamestats + (self.clock.frame.height / 2))
        clock.delegate = self

        let rightButtonWidth = UIScreen.mainScreen().bounds.size.height * 0.25
        rightButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width / 2 - (rightButtonWidth / 2), gameStats.frame.maxY + marginFromGamestats, rightButtonWidth, rightButtonWidth))
        rightButton.setTitle("OK 👍", forState: UIControlState.Normal)
        rightButton.backgroundColor = UIColor.blueColor()
        rightButton.addTarget(self, action: "okAction", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.layer.cornerRadius = rightButtonWidth / 2
        rightButton.layer.masksToBounds = true
        rightButton.alpha = 0
        view.addSubview(rightButton)
        
        infoHelperView = InfoHelperView(frame: CGRectMake(10, gameStats.frame.maxY + marginFromGamestats, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 0.4))
        infoHelperView.alpha = 0
        view.addSubview(infoHelperView)
        if self.gametype == GameType.training
        {
            let backButtonMargin:CGFloat = 15
            backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - GlobalConstants.smallButtonSide - backButtonMargin, backButtonMargin, GlobalConstants.smallButtonSide, GlobalConstants.smallButtonSide)
            backButton.backgroundColor = UIColor.whiteColor()
            backButton.layer.borderColor = UIColor.grayColor().CGColor
            backButton.layer.borderWidth = 2
            backButton.layer.cornerRadius = backButton.frame.width / 2
            backButton.layer.masksToBounds = true
            backButton.setTitle("🔚", forState: UIControlState.Normal)
            backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(backButton)
        }
        else
        {
            let backButtonMargin:CGFloat = 15
            let userHintButtonSide = GlobalConstants.smallButtonSide * 1.2
            useHintButton = UseHintButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - userHintButtonSide  - backButtonMargin, backButtonMargin, userHintButtonSide, userHintButtonSide))
            useHintButton!.addTarget(self, action: "useHintAction", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(useHintButton!)
            questionsLeftFrame = CGRectMake(clock.frame.maxX,useHintButton!.frame.maxY + 4,UIScreen.mainScreen().bounds.width - clock.frame.maxX - 4,clock.frame.height)
        }
        self.view.addSubview(clock)
        
        self.setupAudioPlayers()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let banner = bannerView
        {
            banner.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
            banner.center = CGPoint(x: banner.center.x, y: self.view.bounds.size.height - banner.frame.size.height / 2)
        }
        
        setCardStack()
    }
    
    func setupAudioPlayers()
    {
        var rate:Float = 1.0
        for var i:Int = 0 ; i < 6 ; i++
        {
            var wrongSoundAudioPlayer: AVAudioPlayer!
            do {
                wrongSoundAudioPlayer = try AVAudioPlayer(contentsOfURL: self.wrongSound)
            } catch let error1 as NSError {
                print(error1)
                wrongSoundAudioPlayer = nil
            }
            wrongSoundAudioPlayer.enableRate = true
            wrongSoundAudioPlayer.numberOfLoops = 0
            wrongSoundAudioPlayer.rate = rate
            wrongSoundAudioPlayer.prepareToPlay()
            self.wrongSoundAudioPlayerPool.append(wrongSoundAudioPlayer)
            
            var correctSoundAudioPlayer: AVAudioPlayer!
            do {
                correctSoundAudioPlayer = try AVAudioPlayer(contentsOfURL: self.correctSound)
            } catch let error1 as NSError {
                print(error1)
                correctSoundAudioPlayer = nil
            }
            correctSoundAudioPlayer.enableRate = true
            correctSoundAudioPlayer.numberOfLoops = 0
            correctSoundAudioPlayer.rate = rate
            correctSoundAudioPlayer.prepareToPlay()
            self.correctSoundAudioPlayerPool.append(correctSoundAudioPlayer)
            
            rate = rate + 1.0
            
            var cardInnSoundAudioPlayer: AVAudioPlayer!
            do {
                cardInnSoundAudioPlayer = try AVAudioPlayer(contentsOfURL: self.dealCardSound)
            } catch let error1 as NSError {
                print(error1)
                cardInnSoundAudioPlayer = nil
            }
            cardInnSoundAudioPlayer.enableRate = true
            cardInnSoundAudioPlayer.numberOfLoops = 0
            cardInnSoundAudioPlayer.rate = 2
            cardInnSoundAudioPlayer.prepareToPlay()
            cardInnSoundAudioPlayerPool.append(cardInnSoundAudioPlayer)
            
            var cardOutSoundAudioPlayer: AVAudioPlayer!
            do {
                cardOutSoundAudioPlayer = try AVAudioPlayer(contentsOfURL: self.dealCardSound)
            } catch let error1 as NSError {
                print(error1)
                cardOutSoundAudioPlayer = nil
            }
            cardOutSoundAudioPlayer.enableRate = true
            cardOutSoundAudioPlayer.numberOfLoops = 0
            cardOutSoundAudioPlayer.rate = 3
            cardOutSoundAudioPlayer.prepareToPlay()
            self.cardOutSoundAudioPlayerPool.append(cardOutSoundAudioPlayer)
        }



    }
    
    var touchOverride:Bool = false
    func timeup()
    {
        disableUserInteraction()
        //ensure touch is enabled
        touchOverride = true
        
        var allCardsPlaced = true
        for item in dropZones
        {
            if item.1.getHookedUpCard() == nil
            {
                allCardsPlaced = false
                break
            }
        }
        if allCardsPlaced
        {
            okAction()
        }
        else
        {
            
            animateTimeout()
        }
    }
    
    func animateTimeout()
    {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.timeIsUpSound)
        } catch let error1 as NSError {
            print(error1)
        }
        self.audioPlayer.enableRate = true
        self.audioPlayer.volume = 0.6
        self.audioPlayer.numberOfLoops = 0
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
        
        view.bringSubviewToFront(clock)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.clock.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
            
            }, completion: { (value: Bool) in
                
                self.rightButton.userInteractionEnabled = false
                
                let label = UILabel(frame: CGRectMake(0, 0, 100, 40))
                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont.boldSystemFontOfSize(20)
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = UIColor.clearColor()
                label.numberOfLines = 2
                label.text = "Time is up\n😳"
                label.alpha = 1
                label.center = self.clock.center
                label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1)
                self.view.addSubview(label)
                
                UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    self.clock.transform = CGAffineTransformScale(self.clock.transform, 6, 6)
                    
                    label.transform = CGAffineTransformIdentity
                    
                    }, completion: { (value: Bool) in
                        
                        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            
                            self.clock.alpha = 0
                            label.alpha = 0
                            
                            }, completion: { (value: Bool) in
                                label.removeFromSuperview()
                                
                                self.fails = self.numberOfDropZones
                                self.corrects = 0
                                self.animateCleanupAndStartNewRound()
                        })
                })
        })
        
    }

    func setCardStack()
    {
        for item in cardsStack
        {
            item.removeFromSuperview()
        }

        if gametype == GameType.training
        {
            //DONT shuffle, if will mess up the used sorting
            randomHistoricEvents = datactrl.getRandomHistoricEventsWithPrecision(GlobalConstants.yearPrecisionForPractice, numEvents:numberOfDropZones)
        }
        else
        {
            randomHistoricEvents = datactrl.fetchHistoricEventOnIds(challenge.getNextQuestionBlock())!
            numberOfDropZones = randomHistoricEvents.count
        }
        
        for historicEvent in randomHistoricEvents
        {
            historicEvent.used++
        }
        datactrl.save()
        
        numberOfRoundsDone++
        
        animateNewCardInCardStack(0)
        addDropZone()
        animateQuestionsLeft()
    }
    
    var randomHistoricEvents:[HistoricEvent] = []

    
    func animateNewCardInCardStack(var i:Int)
    {
        self.cardInnSoundAudioPlayerPool[i].play()
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidth:CGFloat = orgCardWidth / 2.5
        let cardHeight:CGFloat = orgCardHeight / 2.5
        let card = Card(frame:CGRectMake(-100, gameStats.frame.maxY + marginFromGamestats, cardWidth, cardHeight),event:randomHistoricEvents[i])
        
        cardsStack.append(card)
        self.view.addSubview(card)
        

        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            card.center = CGPointMake((UIScreen.mainScreen().bounds.size.width / 2) , self.gameStats.frame.maxY + self.marginFromGamestats + (cardHeight / 2))
            
            card.randomOffsetAndRotation()
            }, completion: { (value: Bool) in
                i++
                if i < self.numberOfDropZones
                {
                    self.animateNewCardInCardStack(i)
                }
                else
                {
                    self.revealNextCard()
                    self.view.bringSubviewToFront(self.infoHelperView)
                    self.view.bringSubviewToFront(self.clock)
                    
                    if let hintButton = self.useHintButton
                    {
                        hintButton.showButton()
                    }
                }
        })
    }
    
    func disableUserInteraction()
    {
        touchOverride = true
        rightButton.userInteractionEnabled = false
        self.newRevealedCard?.userInteractionEnabled = false
        self.cardToDrag?.userInteractionEnabled = false
        for var i = 0 ; i <  self.dropZones.count ; i++
        {
            self.dropZones[i]!.getHookedUpCard()?.userInteractionEnabled = false
        }
    }
    
    var tempViews:[UIView] = []
    var tempYearLabel:[UILabel] = []
    var fails:Int = 0
    var corrects:Int = 0
    func okAction()
    {
        disableUserInteraction()
        clock.stop()
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.rightButton.alpha = 0
            self.rightButton.transform = CGAffineTransformScale(self.rightButton.transform, 0.1, 0.1)
            self.clock.transform = CGAffineTransformScale(self.clock.transform, 0.1, 0.1)
            self.clock.alpha = 0
            }, completion: { (value: Bool) in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    
                    for var i = 0 ; i <  self.dropZones.count ; i++
                    {
                        self.dropZones[i]!.center = CGPointMake(self.dropZones[i]!.center.x, UIScreen.mainScreen().bounds.size.height / 2)
                        self.dropZones[i]!.getHookedUpCard()?.center = self.dropZones[i]!.center
                    }
                    
                    }, completion: { (value: Bool) in
                        self.animateYears(0, completion: {() -> Void in
                            self.fails = 0
                            self.corrects = 0
                            
                            self.animateResult(0)
                        })
                })
        })
    }
    
    func useHintAction()
    {
        if let card = self.newRevealedCard
        {
            useHintAnimation(card)
        }
        else if let card = self.cardToDrag
        {
            useHintAnimation(card)
        }
        else if let card = self.lastCardMoved
        {
            useHintAnimation(card)
        }
        else
        {
            let dz = self.dropZones[self.numberOfDropZones - 1]
            if let card = dz!.getHookedUpCard()
            {
                useHintAnimation(card)
            }
            
        }
    }
    
    func useHintAnimation(card:Card)
    {
        if let button = useHintButton
        {
            button.deductHints()
            button.hideButton()

            card.setHint()
        }
    }
    
    func animateYears(var i:Int,completion: (() -> (Void)))
    {
        let label = UILabel(frame: dropZones[i]!.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(20)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.text = dropZones[i]?.getHookedUpCard()?.event.formattedTime
        label.alpha = 0
        view.addSubview(label)
        tempYearLabel.append(label)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            label.frame.offsetInPlace(dx: 0, dy: label.frame.size.height * -1)
            label.transform = CGAffineTransformScale(label.transform, 1.3, 1.3)
            label.alpha = 1
            }, completion: { (value: Bool) in
                i++
                if i < self.dropZones.count
                {
                    self.animateYears(i,completion: completion)
                }
                else
                {
                    completion()
                }
        })
        
    }
    
    func animateResult(index:Int, lastYear:Int32? = nil, var dragOverlabel:UILabel? = nil)
    {

        let dropZone = dropZones[index]
        let label = tempYearLabel[index]
        
        if dragOverlabel == nil && index > 0
        {
            dragOverlabel = UILabel(frame: tempYearLabel[0].frame)
            dragOverlabel!.textAlignment = NSTextAlignment.Center
            dragOverlabel!.font = UIFont.boldSystemFontOfSize(20)
            dragOverlabel!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            view.addSubview(dragOverlabel!)
            tempViews.append(dragOverlabel!)
        }
        dragOverlabel?.text = dropZone?.getHookedUpCard()?.event.formattedTime
        dragOverlabel?.alpha = 1
        
        
        var thisYear = dropZone?.getHookedUpCard()?.event.fromYear
        var wrongAnswer = false
        if thisYear != nil && index > 0
        {
            if thisYear < lastYear
            {
                fails++
                wrongAnswer = true
                thisYear = lastYear
            }
            else
            {
                corrects++
            }
        }

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                    dragOverlabel?.center = label.center
                    dragOverlabel?.alpha = 0.5
                
                }, completion: { (value: Bool) in
                    dragOverlabel?.alpha = 0
                    if index > 0
                    {
                        if wrongAnswer == false
                        {
                            self.correctSoundAudioPlayerPool[index].play()
                            
                            label.textColor = UIColor.greenColor()
                            if let text = label.text
                            {
                                label.text = "\(text)\(self.getCorrectsEmoji(self.corrects))"
                            }
                            self.animatePoints(label.center)
                        }
                        else
                        {
                            self.wrongSoundAudioPlayerPool[index].play()
                            
                            UIView.animateWithDuration(0.25, animations: { () -> Void in

                                    self.dropZones[index]?.frame.offsetInPlace(dx: 0, dy: self.dropZones[index]!.frame.height / 2)
                                    self.dropZones[index]!.getHookedUpCard()!.center = self.dropZones[index]!.center
                                
                                    label.textColor = UIColor.redColor()
                                    label.frame.offsetInPlace(dx: 0, dy: (label.frame.size.height / 2) )
                                    label.transform = CGAffineTransformScale(label.transform, 0.75, 0.75)
                                    label.text = "\(label.text!)\(self.getFailsEmoji(self.fails))"

                                }, completion: { (value: Bool) in
                            })
                            
                        }
                    }
                    
                    
                    if index < (self.dropZones.count - 1)
                    {
                        self.animateResult(index + 1, lastYear: thisYear,dragOverlabel: dragOverlabel)
                    }
                    else
                    {
                        self.animateCleanupAndStartNewRound()
                    }
                })

    }
    
    func getFailsEmoji(fails:Int) -> String
    {
        if fails < 2
        {
            return "😕"
        }
        else if fails < 3
        {
            return "😞"
        }
        else if fails < 4
        {
            return "😦"
        }
        else if fails < 5
        {
            return "😫"
        }
        else if fails < 6
        {
            return "😭"
        }
        else
        {
            return "😲"
        }
    }
    
    func getCorrectsEmoji(corrects:Int) -> String
    {
        if corrects < 2
        {
            return "😉"
        }
        else if corrects < 3
        {
            return "😊"
        }
        else if corrects < 4
        {
            return "😃"
        }
        else if corrects < 5
        {
            return "😗"
        }
        else if corrects < 6
        {
            return "😎"
        }
        else
        {
            return "😏"
        }
    }
    
    func animateCleanupAndStartNewRound()
    {
        let tapViewForNextRound = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        tapViewForNextRound.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.01)
        tapViewForNextRound.alpha = 0
        tempViews.append(tapViewForNextRound)
        view.addSubview(tapViewForNextRound)
        
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in

            tapViewForNextRound.alpha = 1
            
            }, completion: { (value: Bool) in
                
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapForNextRound")
                tapGesture.numberOfTapsRequired = 1
                
                let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "tapForNextRound")
                swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
                swipeUpGestureRecognizer.enabled = true
                swipeUpGestureRecognizer.cancelsTouchesInView = false
                
                tapViewForNextRound.addGestureRecognizer(tapGesture)
                tapViewForNextRound.addGestureRecognizer(swipeUpGestureRecognizer)

                self.tapOverride = true
        })
    }
    
    var tapOverride = false
    func tapForNextRound()
    {
        touchOverride = false
        self.cleanUpTempLabelsForAnimation()


        if fails == 0
        {
            if gametype == GameType.training
            {
                numberOfDropZones = numberOfDropZones >= GlobalConstants.maxNumDropZones ? numberOfDropZones : numberOfDropZones + 1
            }
            self.animateCorrectSequence()
        }
        else
        {
            if gametype == GameType.training
            {
                numberOfDropZones = numberOfDropZones >= GlobalConstants.minNumDropZones ? numberOfDropZones : numberOfDropZones - 1
            }
            self.nextRound()
        }
    }
    
    func animateCorrectSequence()
    {
        let points = 1
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.correctSequenceSound)
        } catch let error1 as NSError {
            print(error1)
        }
        self.audioPlayer.enableRate = true
        self.audioPlayer.numberOfLoops = 0
        self.audioPlayer.rate = 1
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
        let label = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(24)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        label.text = "Totally correct \(points)😅"
        label.alpha = 0
        view.addSubview(label)
        
        for dropzone in self.dropZones
        {
            dropzone.1.getHookedUpCard()?.layer.borderColor = UIColor.greenColor().CGColor
            if let card = dropzone.1.getHookedUpCard()
            {
                card.layer.borderWidth = 2
                card.layer.borderColor = UIColor.greenColor().CGColor
                
                let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = 3
                pulseAnimation.delegate = self
                card.layer.addAnimation(pulseAnimation, forKey: "key\(index)")
            }
            
            
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            label.transform = CGAffineTransformScale(label.transform, 2, 2)
            label.alpha = 1

            }, completion: { (value: Bool) in
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    label.center = self.gameStats.lovePointsView.center
                    label.transform = CGAffineTransformIdentity
                    label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1)
                    label.alpha = 0
                    }, completion: { (value: Bool) in

                        self.gameStats.addLovePoints(points)
                        label.removeFromSuperview()
                        self.nextRound()
                })
        })
    }
    
    func cleanUpTempLabelsForAnimation()
    {
        for item in self.tempViews
        {
            item.removeFromSuperview()
        }
        self.tempViews = []
        for item in self.tempYearLabel
        {
            item.removeFromSuperview()
        }
        self.tempYearLabel = []
    }
    
    func nextRound()
    {
        //move stuff away
        animateRemoveElementsAtRoundEnd({() -> Void in
            for var i = 0 ;  i < self.dropZones.count ; i++
            {
                self.dropZones[i]?.removeFromSuperview()
            }
        
            var roundQuestionIds:[String] = []
            for item in self.randomHistoricEvents
            {
                roundQuestionIds.append("\(item.idForUpdate)")
            }
            self.completedQuestionsIds.append(roundQuestionIds)
            
            if (self.gametype == GameType.badgeChallenge) && (self.fails > 0)
            {
                (self.challenge as! BadgeChallenge).won = false
                self.performSegueWithIdentifier("segueFromPlayToFinished", sender: nil)
            }
            else //trainingmode. Goes on forever
            {
                self.dropZones = [:]
                self.setCardStack()
                self.rightButton.userInteractionEnabled = true
                self.tapOverride = false
            }
        })
    }
    
    func animateRemoveElementsAtRoundEnd(completion: (() -> (Void)))
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.infoHelperView.alpha = 0
            self.rightButton.alpha = 0
            }, completion: { (value: Bool) in
                self.animateRemoveOneDropzoneWithCard(0,completion: {() -> Void in

                    self.animateRemoveOneCardFromCardStack({() -> Void in
                        completion()
                    })
                })
        })
    }
    
    var poolIndex:Int = 0
    func animateRemoveOneCardFromCardStack(comp: (() -> (Void))? = nil)
    {
        if let card = self.cardToDrag
        {
            cardOutSoundAudioPlayerPool[poolIndex].play()
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                card.center = CGPointMake(0 - card.frame.width, card.center.y)
                
                }, completion: { (value: Bool) in
                    self.cardToDrag = nil
                    card.removeFromSuperview()
                    self.animateRemoveOneCardFromCardStack(comp)
            })
        }
        else if let card = self.newRevealedCard
        {
            cardOutSoundAudioPlayerPool[poolIndex].play()
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                card.frame.offsetInPlace(dx: -500, dy: 0)
                
                }, completion: { (value: Bool) in
                    self.newRevealedCard = nil
                    card.removeFromSuperview()
                    self.animateRemoveOneCardFromCardStack(comp)
            })
        }
        else if cardsStack.count > 0
        {
            cardOutSoundAudioPlayerPool[poolIndex].play()
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                let card = self.cardsStack.last
                card?.frame.offsetInPlace(dx: -500, dy: 0)
                
                }, completion: { (value: Bool) in
                    self.cardsStack.removeLast()
                    if let card = self.newRevealedCard
                    {
                        card.removeFromSuperview()
                    }
                    self.animateRemoveOneCardFromCardStack(comp)
            })
        }
        else
        {
            comp!()
        }
        poolIndex = (poolIndex + 1) % cardOutSoundAudioPlayerPool.count
    }
    
    func animateRemoveOneDropzoneWithCard(var i:Int, completion: (() -> (Void))? = nil)
    {
        cardOutSoundAudioPlayerPool[poolIndex].play()
        poolIndex = (poolIndex + 1) % cardOutSoundAudioPlayerPool.count
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.dropZones[i]?.center = CGPointMake(0 - self.dropZones[i]!.frame.width, self.dropZones[i]!.center.y )
                self.dropZones[i]?.getHookedUpCard()?.center = CGPointMake(0 - self.dropZones[i]!.frame.width, self.dropZones[i]!.getHookedUpCard()!.center.y )
                
                
                }, completion: { (value: Bool) in
                    self.dropZones[i]?.getHookedUpCard()?.removeFromSuperview()
                    if i < self.dropZones.count
                    {
                        i++
                        self.animateRemoveOneDropzoneWithCard(i,completion: completion)
                    }
                    else
                    {
                        completion!()
                    }
            })
    }
    

    
    func animatePoints(centerPoint:CGPoint)
    {
        let points = 10 * (numberOfDropZones - (GlobalConstants.minNumDropZones - 1))
        let label = UILabel(frame: dropZones[0]!.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(20)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.center = centerPoint
        label.text = "\(points)😌"
        label.alpha = 0
        view.addSubview(label)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            label.center = self.gameStats.okPointsView.center
            label.transform = CGAffineTransformScale(label.transform, 1.2, 1.2)
            label.alpha = 1
            }, completion: { (value: Bool) in

                label.alpha = 0
                self.gameStats.addOkPoints(points)
                label.removeFromSuperview()
        })
    }
    
    func revealNextCard()
    {
        if let card = cardsStack.last
        {
            view.bringSubviewToFront(card)
            card.tap()
            cardsStack.removeLast()
            newRevealedCard = card
        }
    }

    
    func addDropZone()
    {
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidthToHeightRatio:CGFloat =   orgCardHeight / orgCardWidth
        let margin:CGFloat = 2
        let devidingFactor:CGFloat = numberOfDropZones < 4 ? 4 : CGFloat(numberOfDropZones)
        
        let dropZoneWidth = (UIScreen.mainScreen().bounds.size.width - (margin * (devidingFactor + 1))) / devidingFactor
        let dropZoneHeight = dropZoneWidth * cardWidthToHeightRatio
        let xOffset = margin
        let key = dropZones.count
        originalDropZoneYCenter = UIScreen.mainScreen().bounds.size.height - (dropZoneHeight / 2)
        
        let dropZone = DropZone(frame: CGRectMake(xOffset,UIScreen.mainScreen().bounds.size.height - dropZoneHeight - margin , dropZoneWidth, dropZoneHeight),key:key)
        dropZone.delegate = self
        view.addSubview(dropZone)
        dropZones.updateValue(dropZone, forKey: key)
        //adjust placement of dropzones
        var xCenter = (UIScreen.mainScreen().bounds.size.width / 2) - ((CGFloat(dropZones.count - 1) * (dropZone.frame.width + margin)) / 2)
        
        
        for var i = 0 ;  i < dropZones.count ; i++
        {
            dropZones[i]!.center = CGPointMake(xCenter, UIScreen.mainScreen().bounds.size.height - dropZones[i]!.frame.height)
            if let card = dropZones[i]!.getHookedUpCard()
            {
                card.center = dropZones[i]!.center
            }
            xCenter += (margin + dropZoneWidth)
        }

    }
    
    
    func gettingFocus(sender:DropZone)
    {
        
        let fullFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 2)
        let halfFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 1.5)
        let orgY = sender.center.y
        
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in

            for item in self.dropZones
            {
                if let card = item.1.getHookedUpCard()
                {
                    card.transform = CGAffineTransformIdentity
                    if item.1 == sender
                    {
                        card.center = CGPointMake(card.center.x, fullFocusY)
                    }
                    else if item.0 == (sender.key - 1) //left
                    {
                        
                        card.center = CGPointMake(card.center.x, halfFocusY)
                        card.transform = CGAffineTransformRotate(card.transform, -0.2)
                    }
                    else if item.0 == (sender.key + 1) // right
                    {
                        
                        card.center = CGPointMake(card.center.x, halfFocusY)
                        card.transform = CGAffineTransformRotate(item.1.transform, 0.2)
                    }
                    else
                    {
                        card.center = CGPointMake(card.center.x, orgY)
                    }
                }
            }
            }, completion: { (value: Bool) in
                
        })
    }
    
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0

    var lastCardMoved:Card?
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if tapOverride || touchOverride
        {
            return
        }
        //self.rightButton.alpha = 0
        let touch = touches.first
        let touchLocation = touch!.locationInView(self.view)
        
        if let card = cardToDrag
        {
            
            //!! Seems like this code never is runned as new cards are autoreveald
            //reset focus
            for item in dropZones
            {
                item.1.removeFocus()
            }


            let isInnView = CGRectContainsPoint(card.frame,touchLocation)
            if(isInnView)
            {

                if card.dragging == false
                {
                    self.rightButton.alpha = 0
                    card.dragging = true
                    card.center = touchLocation
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        //card.transform = CGAffineTransformScale(card.transform, 0.75,  0.75)
                        
                        
                        }, completion: { (value: Bool) in
                            //card.transform = CGAffineTransformScale(card.transform, 0.75,  0.75)
                            
                    })
                }
                
                let point = touches.first!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
                xOffset = point.x - card.center.x
                yOffset = point.y - card.center.y
                //pointLabel.transform = CGAffineTransformMakeRotation(10.0 * CGFloat(Float(M_PI)) / 180.0)
            }
        }
        else if newRevealedCard != nil && CGRectContainsPoint(newRevealedCard!.frame,touchLocation)
        {
            //reset focus
            for item in dropZones
            {
                item.1.removeFocus()
            }
            cardToDrag = newRevealedCard
            self.rightButton.alpha = 0
            self.newRevealedCard = nil
        }
        else
        {
            for var i = 0 ; i < dropZones.count ; i++
            {
                if let card = dropZones[i]?.getHookedUpCard()
                {
                    if CGRectContainsPoint(card.frame,touchLocation)
                    {
                        cardToDrag = card
                        lastCardMoved = card
                        self.rightButton.alpha = 0
                        dropZones[i]?.setHookedUpCard(nil)
                        view.bringSubviewToFront(cardToDrag!)
                        CGRectContainsPoint(cardToDrag!.frame,touchLocation)
                        break
                    }
                }
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchOverride
        {
            return
        }
        
        if let card = cardToDrag
        {
            
            let touch = touches.first //touches.anyObject()
            let touchLocation = touch!.locationInView(self.view)
            let isInnView = CGRectContainsPoint(card.frame,touchLocation)
            
            if(isInnView)
            {
                let dropZone = focusToDropZone(touchLocation)

                if dropZone?.getHookedUpCard() != nil
                {

                    let isInnView = CGRectContainsPoint(self.cardToDrag!.frame,touchLocation)
                    if(isInnView)
                    {
                         UIView.animateWithDuration(0.15, animations: { () -> Void in
                                self.makeRoomForCard( dropZone!, touchLocation: touchLocation)
                            
                            }, completion: { (value: Bool) in
                                //self.makeRoomForCard( dropZone!, touchLocation: touchLocation)
                        })
                    }
                }
                
                let point = touches.first!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
                card.center = CGPointMake(point.x - xOffset, point.y - yOffset)
            }
        }
    }
    
    func focusToDropZone(touchLocation:CGPoint) -> DropZone?
    {
        var dropZoneToGiveFocus:DropZone?
        for item in dropZones
        {
            if CGRectContainsPoint(item.1.frame,touchLocation)
            {
                dropZoneToGiveFocus =  item.1
            }
            else
            {
               item.1.removeFocus()
            }
        }
        if let dropzone = dropZoneToGiveFocus
        {
            dropzone.giveFocus()
        }
        return dropZoneToGiveFocus
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
        if touchOverride
        {
            return
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in

           self.infoHelperView.alpha = 0
            if let card = self.cardToDrag
            {
                let touch = touches.first//touches.anyObject()
                let touchLocation = touch!.locationInView(self.view)
                if let dropzone = self.getFocusDropZone()
                {
                    let isInnView = CGRectContainsPoint(card.frame,touchLocation)
                    if(isInnView)
                    {
                        self.dropCardInZone(card, dropzone: dropzone, touchLocation: touchLocation)
                        if self.dropZones.count < self.numberOfDropZones
                        {
                            //first card placed
                            if self.cardsStack.count  == (self.numberOfDropZones - 1)
                            {
                                self.clock.start()
                                self.clock.center = self.orgClockCenter
                                self.clock.transform = CGAffineTransformIdentity
                                self.clock.alpha = 1
                            }
                            
                            if self.newRevealedCard == nil
                            {
                                self.addDropZone()
                                self.revealNextCard()
                            }
                        }
                        else
                        {
                            self.rightButton.alpha = 1
                            self.rightButton.transform = CGAffineTransformIdentity
                        }
                    }
                }
            }
            
            }, completion: { (value: Bool) in
        })
    }
    
    func animateQuestionsLeft()
    {
        if gametype != GameType.training
        {
            let questionsLeftLabel = UILabel(frame: questionsLeftFrame!)
            questionsLeftLabel.numberOfLines = 2
            questionsLeftLabel.textAlignment = NSTextAlignment.Center
            questionsLeftLabel.adjustsFontSizeToFitWidth = true
            questionsLeftLabel.textColor = UIColor.blueColor()
            questionsLeftLabel.font = UIFont.boldSystemFontOfSize(24)
            let questionsLeft = challenge.questionsLeft() + 1
            questionsLeftLabel.text = questionsLeft == 1 ? "Last\nquestion" : "Questions left\n       \(questionsLeft)"
            questionsLeftLabel.alpha = 1
            self.view.addSubview(questionsLeftLabel)
            UIView.animateWithDuration(4.0, animations: { () -> Void in
                questionsLeftLabel.alpha = 0
                })
        }
    }

    
    func dropCardInZone(card:Card, dropzone:DropZone,touchLocation:CGPoint)
    {
        let dropzoneWidth:CGFloat = dropzone.frame.width
        let draggingCardWidth:CGFloat = cardToDrag!.frame.width
        let scale = dropzoneWidth / draggingCardWidth
        card.transform = CGAffineTransformScale(card.transform, scale, scale)

        if dropzone.getHookedUpCard() == nil
        {
            self.cardToDrag = nil
            dropzone.setHookedUpCard(card)
        }

         self.cardToDrag = nil
    }
    
    func makeRoomForCard(dropzone:DropZone,touchLocation:CGPoint)
    {

        if self.mostFreeSlotAtBack(dropzone)
        {
            self.pushBackwardAndMakeSpace(self.dropZones[dropzone.key]!)
            
            let textLeft:String? = dropZones[dropzone.key - 1]?.getHookedUpCard()?.event.title
            let textMid = cardToDrag!.event.title
            let textRight:String? = dropZones[dropzone.key + 1]?.getHookedUpCard()?.event.title
            infoHelperView.setText(textLeft, main:textMid , right: textRight)
            
            
        }
        else
        {
            self.pushForwardAndMakeSpace(self.dropZones[dropzone.key]!)
            
            let textLeft:String? = dropZones[dropzone.key - 1]?.getHookedUpCard()?.event.title
            let textMid = cardToDrag!.event.title
            let textRight:String? = dropZones[dropzone.key + 1]?.getHookedUpCard()?.event.title
            infoHelperView.setText(textLeft, main:textMid , right: textRight)
            
        }
        infoHelperView.alpha = 1
    }
    
    func pushForwardAndMakeSpace(dropzone:DropZone)
    {
        if let cardToPass = dropzone.getHookedUpCard()
        {
            passCardForwardAndHookupNew(dropZones[dropzone.key! + 1], newCardToHookup: cardToPass)
        }
        dropzone.setHookedUpCard(nil)
    }
    
    func pushBackwardAndMakeSpace(dropzone:DropZone)
    {
        if let cardToPass = dropzone.getHookedUpCard()
        {
            passCardBackwardAndHookupNew(dropZones[dropzone.key! - 1], newCardToHookup: cardToPass)
        }
        dropzone.setHookedUpCard(nil)
    }
    
    func passCardBackwardAndHookupNew(dropZone:DropZone?, newCardToHookup:Card)
    {
        if let drop = dropZone
        {
            let hookedUpCardToPass = drop.getHookedUpCard()
            drop.setHookedUpCard(newCardToHookup)
            if let cardToPass = hookedUpCardToPass
            {
                passCardBackwardAndHookupNew(dropZones[drop.key! - 1]!,newCardToHookup: cardToPass)
            }
        }
    }
    
    func passCardForwardAndHookupNew(dropZone:DropZone?, newCardToHookup:Card)
    {
        if let drop = dropZone
        {
            let hookedUpCardToPass = drop.getHookedUpCard()
            drop.setHookedUpCard(newCardToHookup)
            if let cardToPass = hookedUpCardToPass
            {
                passCardForwardAndHookupNew(dropZones[drop.key! + 1]!,newCardToHookup: cardToPass)
            }
        }
    }


    
    
    func mostFreeSlotAtBack(dropzone:DropZone) -> Bool
    {
        var countBack = 0
        var countFront = 0
        for var indexKey = dropzone.key! ; indexKey >= 0 ; indexKey--
        {
            if dropZones[indexKey]?.getHookedUpCard() == nil
            {
                countBack++
            }
        }
        for var indexKey = dropzone.key! ; indexKey < dropZones.count ; indexKey++
        {
            if dropZones[indexKey]?.getHookedUpCard() == nil
            {
                countFront++
            }
        }
        return countBack > countFront
    }

    
    func getFocusDropZone() -> DropZone?
    {
        for item in dropZones
        {
            if item.1.focus
            {
                return item.1
            }
        }
        return nil
    }
    
    func backAction()
    {
        self.performSegueWithIdentifier("segueFromPlayToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromPlayToMainMenu") {
            let svc = segue!.destinationViewController as! MainMenuViewController
            if gameStats.newValues()
            {
                svc.updateGlobalGameStats = true
                svc.newGameStatsValues = (gameStats.okPoints!,gameStats.goodPoints!,gameStats.lovePoints)
            }
        }
        if (segue.identifier == "segueFromPlayToFinished") {
            let svc = segue!.destinationViewController as! FinishedViewController
            svc.completedQuestionsIds = completedQuestionsIds
            svc.usersIdsToChallenge = usersIdsToChallenge
            svc.correctAnswers = gameStats.lovePoints
            svc.points = gameStats.okPoints
            svc.gametype = gametype
            svc.challenge = challenge
        }
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }
}