//
//  HistoricEvent.swift
//  TimeIt
//
//  Created by knut on 12/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import CoreData

class HistoricEvent: NSManagedObject {
    
    @NSManaged var toYear: Int32
    @NSManaged var fromYear: Int32
    @NSManaged var type:Int16
    @NSManaged var text: String
    @NSManaged var title: String
    @NSManaged var okScore:Int32
    @NSManaged var goodScore:Int16
    @NSManaged var loveScore:Int16
    @NSManaged var level:Int16
    @NSManaged var tags:String
    @NSManaged var used:Int32
    @NSManaged var idForUpdate:Int16
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, idForUpdate:Int, title:String, from: Int32, to:Int32, text:String, level:Int, tags:String) -> HistoricEvent{
        let newitem = NSEntityDescription.insertNewObjectForEntityForName("HistoricEvent", inManagedObjectContext: moc) as! HistoricEvent
        newitem.fromYear = Int32(from)
        newitem.toYear = Int32(to)
        newitem.type = Int16(EventType.periode.rawValue)
        newitem.text = text
        newitem.title = title
        newitem.tags = tags
        newitem.level = Int16(level)
        newitem.idForUpdate = Int16(idForUpdate)
        newitem.okScore = 0
        newitem.goodScore = 0
        newitem.loveScore = 0
        newitem.used = 0
        return newitem
    }
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, idForUpdate:Int, title:String, year: Int32, text:String, level:Int, tags:String) -> HistoricEvent{
        let newitem = NSEntityDescription.insertNewObjectForEntityForName("HistoricEvent", inManagedObjectContext: moc) as! HistoricEvent
        newitem.fromYear = Int32(year)
        newitem.toYear = Int32(year)
        newitem.type = Int16(EventType.singleYear.rawValue)
        newitem.text = text
        newitem.title = title
        newitem.tags = tags
        newitem.level = Int16(level)
        newitem.idForUpdate = Int16(idForUpdate)
        newitem.okScore = 0
        newitem.goodScore = 0
        newitem.loveScore = 0
        newitem.used = 0
        return newitem
    }
    
    
    var formattedToYear:String
        {
        get{
            if self.toYear < -1000
            {
                let value = (self.toYear / GlobalConstants.aMillion) * -1
                return "\(value) m.y.a"
            }
                
            else
            {
                return self.toYear < 0 ? "\(self.toYear * -1)BC" : "\(self.toYear)"
            }
        }
    }
    
    var formattedFromYear:String
        {
        get{
            if self.fromYear < -1000
            {
                let value = (self.fromYear / GlobalConstants.aMillion) * -1
                return "\(value) m.y.a"
            }
            else
            {
                return self.fromYear < 0 ? "\(self.fromYear * -1)BC" : "\(self.fromYear)"
            }
        }
    }
    
    var formattedTime:String
        {
        get{
            let fyear = self.formattedFromYear
            let tyear = self.formattedToYear
            return type == Int16(EventType.singleYear.rawValue) ? "\(fyear)" : "\(fyear) - \(tyear)"
        }
    }
}

