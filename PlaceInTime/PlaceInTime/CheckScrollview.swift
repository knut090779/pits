//
//  TagCheckScrollview.swift
//  TimeIt
//
//  Created by knut on 06/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

protocol CheckViewProtocol
{
    func closeCheckView(sender:CheckScrollView)
    func reloadMarks(tags:[String])
}

class CheckScrollView: UIView , UIScrollViewDelegate, CheckItemProtocol{
    
    var checkItems:[CheckItemView]!
    var tags:[String:String]!
    var scrollView:UIScrollView!
    var closeButton:UIButton!
    var delegate:CheckViewProtocol!
    var selectedInfoLabel:UILabel!
    var itemName:String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, initialValues:[String:String] = [:], itemsName:String = "item", itemsChecked:Bool = true) {
        super.init(frame: frame)
        tags = initialValues
        checkItems = []
        
        self.itemName = itemsName
        
        closeButton = UIButton(frame: CGRectMake(frame.width - 40, 0, 40, 40))
        closeButton.setTitle("❌", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "closeAction", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.backgroundColor = UIColor.blueColor()
        
        scrollView = UIScrollView(frame: CGRectMake(0, closeButton.frame.height, frame.width, frame.height - closeButton.frame.height))
        
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5.0
        let itemheight:CGFloat = 40
        
        selectedInfoLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width - closeButton.frame.width, itemheight))
        selectedInfoLabel.textAlignment = NSTextAlignment.Center
        selectedInfoLabel.backgroundColor = UIColor.blueColor()
        selectedInfoLabel.textColor = UIColor.whiteColor()
        
        var contentHeight:CGFloat = 0
        var i:CGFloat = 0
        for tagItem in tags
        {
            let newTagCheckItem = CheckItemView(frame: CGRectMake(0, itemheight * i, self.frame.width, itemheight), title: tagItem.0, value:tagItem.1 ,checked:itemsChecked)
            newTagCheckItem.delegate = self
            checkItems.append(newTagCheckItem)
            scrollView.addSubview(newTagCheckItem)
            contentHeight = newTagCheckItem.frame.maxY
            i++
        }
        let numberOfItemSelected = itemsChecked ? tags.count : 0
        selectedInfoLabel.text = "\(numberOfItemSelected) \(itemName)s selected"
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        self.addSubview(selectedInfoLabel)
        self.addSubview(closeButton)
        
    }
    
    func unselectAllItem()
    {
        for item in checkItems
        {
            item.checked = false
            item.checkBoxView.setTitle("◽️", forState: UIControlState.Normal)
        }
        delegate.reloadMarks(getItemsAsArray())
    }
    
    func checkChanged()
    {
        let selectedTags = getItemsAsArray()
        delegate.reloadMarks(selectedTags)
        
        selectedInfoLabel.text = "\(selectedTags.count) \(itemName)s selected"
    }
    
    func getItemsAsArray() -> [String]
    {
        var returnValue:[String] = []
        for item in checkItems
        {
            if item.checked
            {
                returnValue.append(item.value)
            }
        }
        return returnValue
    }
    
    
    func closeAction()
    {
        let selectedTags = getItemsAsArray()
        delegate.reloadMarks(selectedTags)
        
        selectedInfoLabel.text = "\(selectedTags.count) \(itemName)s selected"
        delegate!.closeCheckView(self)
        
    }
}
