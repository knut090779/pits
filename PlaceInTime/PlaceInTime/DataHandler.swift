//
//  PopulateData.swift
//  TimeIt
//
//  Created by knut on 18/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataHandler
{
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var historicEventItems:[HistoricEvent]!
    var todaysYear:Double!
    init()
    {
        loadGameData()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Year, fromDate: date)
        todaysYear = Double(components.year)
        historicEventItems = []
    }
    
    func populateData(completePopulating: (() -> (Void))?)
    {
        var id = 1
        newEvent(id++,title:"Isaac Newtown is born", year:1642, text: "",level:2,tags:"#science")
        newEvent(id++,title:"Galileo Galilei is born in Piza", year:1564, text: "",level:2,tags:"#science")
        newEvent(id++,title:"Nicolaus Copernicus is born in Polen", year:1473,text: "",tags:"#science")
        newEvent(id++,title:"René Descartes is born in France", year:1596, text: "",tags:"#science")
        newEvent(id++,title:"James Maxwell, electromagnetisms father is born", year:1831, text: "",tags:"#science")
        
        newEvent(id++,title:"Aristotle writes Meteorologica", year:-990,text: "The first book on weather.",tags:"#science")
        newEvent(id++,title:"Musa al-Kwarizmi born in Baghdad", year:780, text:"He introduced Hindu-Arabic numerals in his book Kitab al-jabr wa al-mugabalah.",tags:"#science")
        newEvent(id++,title:"Shen Kua of China writes about the magnetic compass", year:1086,level:2,tags:"#science")
        newEvent(id++,title:"First modern university", year:1088, text: "First modern university established in Bologna, Italy",tags:"#science")
        newEvent(id++,title:"Map of western China printed", year:1162, text:"Oldest known printed map",tags:"#science")
        newEvent(id++,title:"University of Oxford founded", year:1249,level:1,tags:"#science")
        newEvent(id++,title:"University of Cambridge founded", year:1284,level:2,tags:"#science")
        newEvent(id++,title:"Fire destroys four-fifths of London", year:1666,level:1, tags:"#science")
        newEvent(id++,title:"Leonardo da Vinci born", year:1452,level:1,tags:"#science")
        newEvent(id++,title:"Copernicus born in Poland", year:1473,level:1,tags:"#science")
        newEvent(id++,title:"Kepler publishes Mysterium cosmographicum", year:1596,level:2,tags:"#science")
        newEvent(id++,title:"Inquisition forces Galileo to recant his belief", year:1633, text:"Inquisition forces Galileo to recant his belief in Copernican theory.",level:2,tags:"#science")
        newEvent(id++,title:"Mathematical Principles of Natural Philosophy published", year:1000, text:"Isaac Newton describes the theory of gravity. The era of modern physics is inaugurated by the publication of his Mathematical Principles of Natural Philosophy, commonly called the Principia’. It was published in Latin and did not appear in English until 1729.",level:1,tags:"#science")
        newEvent(id++,title:"Louis Bleriot flies across the English Channel", year:1909,level:1,tags:"#science")
        newEvent(id++,title:"World’s first nuclear reactor", year:1946, text:"Opened in the USSR",level:2,tags:"#science")
        newEvent(id++,title:"US sends 4 monkeys into the stratosphere", year:1951,tags:"#science")
        newEvent(id++,title:"USSR launches the Sputnik satellite", year:1957,level:1,tags:"#science")
        newEvent(id++,title:"NASA founded", year:1958,level:2,tags:"#science")
        newEvent(id++,title:"Sikorsky becomes first woman in space", year:1963,level:2,tags:"#science")
        newEvent(id++,title:"IBM launches their PC", year:1981,level:2,tags:"#science")
        newEvent(id++,title:"Shuttle Columbia launched", year:1981,level:1,tags:"#science")
        newEvent(id++,title:"The Space Shuttle Challenger disaster", year:1986,level:1,tags:"#science")
        newEvent(id++,title:"Soviet Union launches Mir space station", year:1986,level:2,tags:"#science")
        newEvent(id++,title:"Hubble space telescope launched", year:1990,level:2,tags:"#science")
        newEvent(id++,title:"Space Shuttle Columbia disintegrates over Texas", year:2003,tags:"#science")

        newEvent(id++,title:"Pythagoras describes his theorem", year:-532,text:"Pythagoras of Crotona describes the relations between sides of right-angled triangle, and tone vibrations.",level:2,tags:"#discovery#science")
        newEvent(id++,title:"Archimedes explains principles of a lever", year:-212, text:"Area of circle, principles of lever, the screw, and buoyancy.",tags:"#discovery#science")
        newEvent(id++,title:"Eratosthenes determines the size of Earth", year:-194,tags:"#discovery#science")
        newEvent(id++,title:"Iceland discovered", year:861,tags:"#discovery")
        newEvent(id++,title:"Vikings discover Greenland", year:900,tags:"#discovery")
        newEvent(id++,title:"Leif Ericson lands in North America", year:1000, text: "The viking Leif Ericson lands in North America, calling it Vinland",level:2,tags:"#discovery")
        newEvent(id++,title:"Marco Polo leaves Venice for China", year:1272,text:"Marco Polo leaves Venice for China, where he would live and prosper for 17 years, returning to Venice where he died in 1323",level:2,tags:"#discovery")
        newEvent(id++,title:"Columbus discovers the New World", year:1492,level:1,tags:"#discovery")
        newEvent(id++,title:"Vasco da Gama discover sea route to India", year:1497,level:1,tags:"#discovery")
        newEvent(id++,title:"Balboa encounter the Pacific ocean", year:1513,level:2,tags:"#discovery")
        newEvent(id++,title:"Copernicus suggests that the earth moves around the sun", year:1514,level:2,tags:"#discovery")
        newEvent(id++,title:"Coffee from Arabia appears in Europe", year:1515,level:2,tags:"#discovery")
        newEvent(id++,title:"Magellan starts his sail journey", year:1519,level:2,tags:"#discovery")
        newEvent(id++,title:"Potato brought to Europe from South America", year:1540,tags:"#discovery")
        newEvent(id++,title:"Galileo Galilei discovers Jupiter’s 4 largest moons", year:1610,tags:"#discovery")
        newEvent(id++,title:"Boyle develops Boyle’s Law", year:1662, text:"Boyle develops Boyle’s Law: the volume of a gas varies with its pressure",level:2,tags:"#discovery")
        newEvent(id++,title:"Isaac Newton experiments with gravity", year:1664,tags:"#discovery#science")
        newEvent(id++,title:"Franz Mesmer uses hypnotism", year:1778, text:"It’s from his name we get the word mesmerized",tags:"#discovery")
        newEvent(id++,title:"Hennig Brand discovers phosphorus", year:1000, text:"German alchemist Hennig Brand discovers phosphorus, the first new element found since ancient times",tags:"#discovery")
        newEvent(id++,title:"Halley discovers Halley’s comet", year:1682,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Anthony van Leeuwenhoek discovers bacteria", year:1684,text:"he significance of which was not understood until the 19th century",tags:"#discovery#science")
        newEvent(id++,title:"First coffee planted in Brazil", year:1718,tags:"#discovery#science")
        newEvent(id++,title:"James Cook discovers Australia", year:1770,level:1,tags:"#discovery")
        newEvent(id++,title:"Michael Faraday discovers benzene", year:1825,tags:"#discovery")
        newEvent(id++,title:"Michael Faraday discovers electromagnetic induction", year:1831,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Gold discovered in California", year:1848,level:1,tags:"#discovery")
        newEvent(id++,title:"Rontgen discovers x-rays", year:1894,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Darwin publishes Origin of Species", year:1859,level:1,tags:"#discovery#science")
        newEvent(id++,title:"JJ Thompson discovers the electron", year:1896,tags:"#discovery#science")
        newEvent(id++,title:"Planck describing quantum mechanics", year:1900,tags:"#discovery#science")
        newEvent(id++,title:"Roald Amundsen discovers the magnetic north pole", year:1905,level:2,tags:"#discovery")
        newEvent(id++,title:"First blood transfusion", year:1907,level:2,tags:"#discovery")
        newEvent(id++,title:"Leo Baekeland discovers plastic", year:1907,tags:"#discovery")
        newEvent(id++,title:"Einstein proposes quantum theory", year:1908,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Roald Amundsen reaches the South Pole", year:1910,level:1,tags:"#discovery")
        newEvent(id++,title:"Alexander Fleming discovers penicillin", year:1928,level:1,tags:"#discovery")
        newEvent(id++,title:"James Chadwick discovers the neutron", year:1932,tags:"#discovery")
        newEvent(id++,title:"First artificial element, technetium, created", year:1937,tags:"#discovery")
        newEvent(id++,title:"Man reach summit of Mount Everes", year:1953,level:1,tags:"#discovery")
        newEvent(id++,title:"Dr Watson discovers the structure of DNA.", year:1953,tags:"#discovery#science")
        newEvent(id++,title:"Yuri Gagarin the first man in space", year:1961,level:1,tags:"#discovery#science")
        newEvent(id++,title:"Neil Armstrong is the first man on the moon", year:1969,level:1,tags:"#discovery#science")
        newEvent(id++,title:"Viking I lands on Mars", year:1976,level:2,tags:"#discovery#science")
        newEvent(id++,title:"HIV virus identified", year:1983,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Farman discovers the hole in the ozone", year:1985,tags:"#discovery")
        newEvent(id++,title:"Roslin Institute in Scotland clones a sheep", year:1997,level:2,tags:"#discovery#science")

        newEvent(id++,title:"Roman calendar introduced", year:-535, text: "It had 10 months, with 304 days in a year that began in March.",level:2,tags:"#invention")
        newEvent(id++,title:"First seismoscope developed in China", year:132,level:1,tags:"#invention")
        newEvent(id++,title:"First printed newspaper appears in Peking", year:748,tags:"#invention")
        newEvent(id++,title:"First record of an automatic instrument", year:890, text:"First record of an automatic instrument, an organ-building treatise called Banu Musa.",tags:"#invention")
        newEvent(id++,title:"Toilet paper thought be used first in China", year:850,tags:"#invention")
        newEvent(id++,title:"Chinese money printed in 3 colors to stop counterfeit", year:1107,tags:"#invention")
        newEvent(id++,title:"Magnetic compass invented", year:1182,text:"The type of ore that attracted iron was known as magnesian stone because it was discovered in Magnesia in Asia Minor. The discovery of the magnet’s use in determining direction was made independently in China and Europe, the latter by English theologian and natural philosopher Alexander Neckam.",level:1,tags:"#invention")
        newEvent(id++,title:"Earliest recorded mention of playing cards, found in China.", year:969,level:2,tags:"#invention")
        newEvent(id++,title:"Musical notation systematised.", year:990,tags:"#invention")
        newEvent(id++,title:"Paper money printed in China.", year:1023,tags:"#invention")
        newEvent(id++,title:"Buttons invented to decorate clothing", year:1200,tags:"#invention")
        newEvent(id++,title:"Gun invented in China", year:1250,tags:"#invention")
        newEvent(id++,title:"The flioria gold coins created in Florence", year:1252,text:"It would become the first international currency",level:2,tags:"#invention")
        newEvent(id++,title:"The first mention of reading glasses", year:1286,level:2,tags:"#invention")
        newEvent(id++,title:"Drinking chocolate made by Aztecs", year:1350,level:2,tags:"#invention")
        newEvent(id++,title:"Johannes Gutenberg prints the Bible", year:1450,tags:"#invention")
        newEvent(id++,title:"First toothbrush made from hog bristles", year:1498,tags:"#invention")
        newEvent(id++,title:"Coiled springs invented", year:1502,level:1,tags:"#invention")
        newEvent(id++,title:"First handkerchief used in Europe", year:1503,tags:"#invention")
        newEvent(id++,title:"The pencil invented in England", year:1565,level:1,tags:"#invention")
        newEvent(id++,title:"Bottled beer invented in London.", year:1568,level:2,tags:"#invention")
        newEvent(id++,title:"The first mechanical calculator", year:1623, text:"German inventor Wilhelm Schickard invents the first mechanical calculator. Records detailing the machine’s workings were lost during the Thirty Years’ War.",level:2,tags:"#invention")
        newEvent(id++,title:"The barometer is invented", year:1644, text:"Italian Evangelista Torricelli invents the barometer",level:1,tags:"#invention")
        newEvent(id++,title:"A Paris cafe begins serving ice cream", year:1670,tags:"#invention")
        newEvent(id++,title:"Gabriel Daniel Fahrenheit invents the thermometer", year:1686,level:2,tags:"#invention")
        newEvent(id++,title:"Invention of steam pump", year:1698,level:1,tags:"#invention")
        newEvent(id++,title:"Jethro Tull invents the seed drill", year:1701,tags:"#invention")
        newEvent(id++,title:"Bartolomeo Cristofori invents the piano", year:1709,tags:"#invention")
        newEvent(id++,title:"Ketterer invents the cuckoo clock", year:1718,tags:"#invention")
        newEvent(id++,title:"The first eraser put on the end of a pencil", year:1752,tags:"#invention")
        newEvent(id++,title:"First street lights in New York", year:1761,level:2,tags:"#invention")
        newEvent(id++,title:"James Hargreaves invents the Spinning Jenny", year:1764,level:2,tags:"#invention")
        newEvent(id++,title:"James Watt invents rotary steam engine", year:1765,level:1,tags:"#invention")
        newEvent(id++,title:"Nicolas Cugnot builds the motorized carriage", year:1769,level:1,tags:"#invention")
        newEvent(id++,title:"Georges Louis Lesage patents the electric telegraph", year:1774,level:1,tags:"#invention")
        newEvent(id++,title:"Alexander Cummings invents the flush toilet", year:1775,level:2,tags:"#invention")
        newEvent(id++,title:"William Murdoch invents gas lighting", year:1792,tags:"#invention")
        newEvent(id++,title:"The first ambulance used in France", year:1792,tags:"#invention")
        newEvent(id++,title:"The first soft drink invented", year:1798,tags:"#invention")
        newEvent(id++,title:"Alessandro Volta invents the battery", year:1799,level:2,tags:"#invention")
        newEvent(id++,title:"Richard Trevithick builds the steam locomotive.", year:1804,level:2,tags:"#invention")
        newEvent(id++,title:"William Sturgeon invents the electromagnet", year:1825,level:2,tags:"#invention")
        newEvent(id++,title:"Samuel Mory patents the internal combustion engine", year:1826,level:1,tags:"#invention")
        newEvent(id++,title:"John Walker invents the modern matches", year:1827,level:1,tags:"#invention")
        newEvent(id++,title:"Louis Braille invents the stereoscope", year:1832,level:2,tags:"#invention")
        newEvent(id++,title:"Franklin Beale invents the coin press", year:1836,level:2,tags:"#invention")
        newEvent(id++,title:"John Deere patents a steel plow", year:1837,level:2,tags:"#invention")
        newEvent(id++,title:"Samuel Morse introduces the Morse code", year:1837,level:1,tags:"#invention")
        newEvent(id++,title:"Patent of the rubber band", year:1845,tags:"#invention")
        newEvent(id++,title:"Baking powder invented", year:1849,tags:"#invention")
        newEvent(id++,title:"Beer first sold in glass bottles", year:1850,tags:"#invention")
        newEvent(id++,title:"John Gorrie invents a refrigerating machine", year:1851,level:2,tags:"#invention")
        newEvent(id++,title:"Levi Strauss begins making trousers", year:1853,tags:"#invention")
        newEvent(id++,title:"Richard J Gatling invents the machine gun", year:1861,tags:"#invention")
        newEvent(id++,title:"Alessandro Volta demonstrated the electric pile or battery", year:1862,tags:"#invention")
        newEvent(id++,title:"First Atlantic cable laid", year:1866,level:1,tags:"#invention")
        newEvent(id++,title:"World’s first traffic light", year:1868,level:2,tags:"#invention")
        newEvent(id++,title:"Suez Canal opens", year:1869,level:1,tags:"#invention")
        newEvent(id++,title:"The first New York City subway line opens", year:1870,tags:"#invention")
        newEvent(id++,title:"Joseph Glidden invents barbed wire fencing", year:1874,tags:"#invention")
        newEvent(id++,title:"Electric dental drill patented by George Green", year:1875,tags:"#invention")
        newEvent(id++,title:"Graham Bell patents the telephone", year:1876,level:1,tags:"#invention")
        newEvent(id++,title:"Thomas Edison invents the phonograph", year:1877,level:2,tags:"#invention")
        newEvent(id++,title:"Otto Lilienthal builds a working glider", year:1877,tags:"#invention")
        newEvent(id++,title:"William Crookes invents cathode ray tube.", year:1879,tags:"#invention")
        newEvent(id++,title:"World’s first skyscraper", year:1885, text:"10-storey Home Insurance office, built in Chicago",level:2,tags:"#invention")
        newEvent(id++,title:"Karl Benz build gasoline-powered car", year:1885,level:2,tags:"#invention")
        newEvent(id++,title:"First set of contact lenses", year:1887,tags:"#invention")
        newEvent(id++,title:"Herz produces the first man-made radio waves", year:1887,tags:"#invention")
        newEvent(id++,title:"John Loud invents ballpoint pen", year:1888,tags:"#invention")
        newEvent(id++,title:"Patent of the roll film camera, the Kodak", year:1888,tags:"#invention")
        newEvent(id++,title:"Rudolph Diesel invents diesel engine", year:1892,tags:"#invention")
        newEvent(id++,title:"Orville Wright makes powered flight", year:1903,level:1,tags:"#invention")
        newEvent(id++,title:"Teabags invented by Thomas Suillivan", year:1904,tags:"#invention")
        newEvent(id++,title:"William Kellogg invents cornflakes", year:1906,tags:"#invention")
        newEvent(id++,title:"First Ford Model T rolls out", year:1908,level:1,tags:"#invention")
        newEvent(id++,title:"First commercially made color film", year:1909,tags:"#invention")
        newEvent(id++,title:"Artificial silk stockings made in Germany", year:1910,tags:"#invention")
        newEvent(id++,title:"First crossword puzzle published in New York Journal", year:1912,tags:"#invention")
        newEvent(id++,title:"Panama canal opens", year:1914,level:2,tags:"#invention")
        newEvent(id++,title:"Poison gas is used as a weapon", year:1915, text:"Poison gas is used as a weapon in Ypres, Belgium by German forces.",level:2,tags:"#invention")
        newEvent(id++,title:"Wireless telephone is invented", year:1919,tags:"#invention")
        newEvent(id++,title:"Tommy-gun is patented by John T Thompson", year:1920,tags:"#invention")
        newEvent(id++,title:"Jacob Schick patents the electric shaver", year:1923,tags:"#invention")
        newEvent(id++,title:"First Bubble Gum goes on sale in the US", year:1928,tags:"#invention")
        newEvent(id++,title:"Volkswagen Beetle is launched", year:1936,tags:"#invention")
        newEvent(id++,title:"Heinrich Focke creates the first successful helicopter", year:1936,level:2,tags:"#invention")
        newEvent(id++,title:"Supermarket trolleys introduced in Oklahoma", year:1938,tags:"#invention")
        newEvent(id++,title:"Maiden flight of pressurized airliner", year:1938, text:"Boeing Stratoliner",level:2,tags:"#invention")
        newEvent(id++,title:"Nylon stocking introduced", year:1940,tags:"#invention")
        newEvent(id++,title:"First solid-body electric guitar is built by Les Paul", year:1947,tags:"#invention")
        newEvent(id++,title:"Kalashnikov invents the AK-47", year:1947,tags:"#invention")
        newEvent(id++,title:"Velcro is patented", year:1951,level:2,tags:"#invention")
        newEvent(id++,title:"Chrysler introduces power steering", year:1951,tags:"#invention")
        newEvent(id++,title:"Sony invents pocket-sized transistor radio", year:1952,level:2,tags:"#invention")
        newEvent(id++,title:"Danish toymakers launches Lego", year:1958,level:1,tags:"#invention")
        newEvent(id++,title:"Skateboard invented", year:1958,tags:"#invention")
        newEvent(id++,title:"Dow Corp invent silicone breast implants", year:1962,tags:"#invention")
        newEvent(id++,title:"Bill Gates and Paul Allen use their first computer", year:1968,tags:"#invention")
        newEvent(id++,title:"Seiko launches the quartz wristwatch", year:1967,tags:"#invention")
        newEvent(id++,title:"IBM introduces the floppy disk ", year:1970,tags:"#invention")
        newEvent(id++,title:"Texas Instruments launches the pocket calculator", year:1972,level:1,tags:"#invention")
        newEvent(id++,title:"Nike running shoes launched", year:1972,level:1,tags:"#invention")
        newEvent(id++,title:"Gillette introduces the disposable razor", year:1974,level:1,tags:"#invention")
        newEvent(id++,title:"GM introduces the catalytic converter", year:1974,tags:"#invention")
        newEvent(id++,title:"IBM launches the laser printer", year:1975,tags:"#invention")
        newEvent(id++,title:"Apple II the first mass-produced home computer", year:1977,tags:"#invention")
        newEvent(id++,title:"First arcade video game, Space Invaders", year:1978,tags:"#invention")
        newEvent(id++,title:"Philips invents the CD", year:1980,level:1,tags:"#invention")
        newEvent(id++,title:"First commercial cell phone call", year:1983,level:2,tags:"#invention")
        newEvent(id++,title:"Sinclair introduces the battery-operated car", year:1985,tags:"#invention")
        newEvent(id++,title:"US introduces the F-117 stealth fighter", year:1988,tags:"#invention")
        newEvent(id++,title:"Tim Berners-Lee develops the World Wide Web", year:1989,tags:"#invention")
        newEvent(id++,title:"Wikipedia started", year:2001,level:2,tags:"#invention")
        newEvent(id++,title:"Facebook founded", year:2004,tags:"#invention")
        newEvent(id++,title:"YouTube launched", year:2005,tags:"#invention")
        newEvent(id++,title:"Apple launches the iPhone", year:2007,level:1,tags:"#invention")
        newEvent(id++,title:"Apple launches the iPad", year:2010,tags:"#invention")
                print("populated new data")
        save()
        dataPopulatedValue = 1
        saveGameData()
        NSUserDefaults.standardUserDefaults().setInteger(GlobalConstants.numberOfHintsAtStart, forKey: "hintsLeftOnAccount")
        completePopulating?()
    }
    
    func newEvent(idForUpdate:Int,title:String, from: Int32, to:Int32, text:String = "", level:Int = 3, tags:String = "")
    {
        HistoricEvent.createInManagedObjectContext(self.managedObjectContext!,idForUpdate:idForUpdate,  title:title, from: from, to:to, text:text, level:level,tags:tags)
    }
    
    func newEvent(idForUpdate:Int,title:String, year: Int32, text:String = "", level:Int = 3, tags:String = "")
    {
        HistoricEvent.createInManagedObjectContext(self.managedObjectContext!,idForUpdate:idForUpdate,  title:title, year:year, text:text,level:level, tags:tags)
    }
    
    func updateOkScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        historicEvent.okScore = historicEvent.okScore + Int32(deltaScore)
        if historicEvent.okScore < 0
        {
            historicEvent.okScore = 0
        }
        save()
    }
    
    func updateGoodScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        historicEvent.goodScore = historicEvent.goodScore + Int16(deltaScore)
        if historicEvent.goodScore < 0
        {
            historicEvent.goodScore = 0
        }
        save()
    }
    
    func updateLoveScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        historicEvent.loveScore = historicEvent.loveScore + Int16(deltaScore)
        if historicEvent.loveScore < 0
        {
            historicEvent.loveScore = 0
        }
        save()
    }
    
    func updateGameData(deltaOkPoints:Int,deltaGoodPoints:Int,deltaLovePoints:Int)
    {
        okScoreValue = Int(okScoreValue as! NSNumber) + deltaOkPoints
        goodScoreValue = Int(goodScoreValue as! NSNumber) + deltaGoodPoints
        loveScoreValue = Int(loveScoreValue as! NSNumber) + deltaLovePoints
    }
    
    func addRecordToGameResults(value:String)
    {
        self.gameResultsValues.append(value)
    }

    
    func getRandomHistoricEventsWithPrecision(var precisionYears:Int, numEvents:Int) -> [HistoricEvent]
    {
        //this value is used to ensure events used less than others have a better chance of being used
        var getValuesFromIndexCount = UInt32(Double(historicEventItems.count) * 0.5)
        let failSafePercision:Int = 10
        var failSafeIndexCount:UInt32 = UInt32(historicEventItems.count)
        
        var historicEventsWithPrecision:[HistoricEvent] = []

        let roundsBeforeFailSafe = 10
        var roundsBeforeFailSafeCountdown = roundsBeforeFailSafe
        var notAcceptableValues = false
        
        repeat{
            historicEventsWithPrecision = []
            for var i = 0 ; i < numEvents ; i++
            {
                //at first, try using the values at top. Those with the lowest usage count
                let randomNum = Int(arc4random_uniform(UInt32(getValuesFromIndexCount)))
                let event = historicEventItems![randomNum] as HistoricEvent
                historicEventsWithPrecision.append(event)
            }
            
            notAcceptableValues = checkIfEventsInsideExeptablePrecision(historicEventsWithPrecision,precisionYears: precisionYears)
            
            if roundsBeforeFailSafeCountdown <= 0
            {
                getValuesFromIndexCount = failSafeIndexCount
                precisionYears = failSafePercision
                failSafeIndexCount = failSafeIndexCount <= 5 ? failSafeIndexCount : failSafeIndexCount - 1
            }
            else
            {
                roundsBeforeFailSafeCountdown--
            }
        
        }while(notAcceptableValues)
        return historicEventsWithPrecision
    }
    
    func checkIfEventsInsideExeptablePrecision(listToCheck:[HistoricEvent],precisionYears:Int) -> Bool
    {
        var notAcceptableValues = false
        for var i = 0 ; i < listToCheck.count ; i++
        {
            var foundMySelfOnce = false
            let value = listToCheck[i].fromYear
            for item in listToCheck
            {
                if item == listToCheck[i]
                {
                    if foundMySelfOnce
                    {
                        notAcceptableValues = true
                        break
                    }
                    else
                    {
                        foundMySelfOnce = true
                        continue
                    }
                }
                if (item.fromYear - precisionYears) > value || item.fromYear + precisionYears < value
                {
                    continue
                }
                else
                {
                    notAcceptableValues = true
                    break
                }
                
            }
        }
        return notAcceptableValues

    }
    
    func shuffleEvents()
    {
        historicEventItems = shuffle(historicEventItems)
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

    
    func save() {
        do{
            try managedObjectContext!.save()
        } catch {
            print(error)
        }
    }
    
    func getXNumberOfQuestionIds(numQuestions:Int) -> [String]
    {
        var questionIds:[String] = []
        for var i = 0 ; i < numQuestions ; i++
        {
            questionIds.append(String(historicEventItems[i].idForUpdate))
        }
        return questionIds
    }
    
    func fetchData(tags:[String] = [],fromLevel:Int,toLevel:Int) {
        let fetchEvents = NSFetchRequest(entityName: "HistoricEvent")
        var predicateTags:String = ""
        if tags.count > 0
        {
            for item in tags
            {
                if item != ""
                {
                    predicateTags = "\(predicateTags)|\(item)"
                }
            }
            predicateTags.removeAtIndex(predicateTags.startIndex)
        }
        //let predicate = NSPredicate(format: "titlenumber contains %@", "Worst")
        // Set the predicate on the fetch request
        //let predicate = NSPredicate(format: "periods.@count > 0 AND level >= \(fromLevel) AND level <= \(toLevel)")
        //let predicate = NSPredicate(format: "tags  MATCHES '.*(#war|#curiosa).*'")
        
        let predicate = NSPredicate(format: "level >= \(fromLevel) AND level <= \(toLevel) AND tags  MATCHES '.*(\(predicateTags)).*'")
        fetchEvents.predicate = predicate
        
        fetchEvents.sortDescriptors = [NSSortDescriptor(key: "used", ascending: true)]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchEvents)) as? [HistoricEvent] {
            historicEventItems = fetchResults
        }
    }
    
    
    func fetchHistoricEventOnIds(ids:[String]) -> [HistoricEvent]?
    {
        let fetchEvents = NSFetchRequest(entityName: "HistoricEvent")
        var predicateIds:String = "{"

        for item in ids
        {
            predicateIds = "\(predicateIds)\(item),"
        }
        
        predicateIds = String(predicateIds.characters.dropLast())
        predicateIds = "\(predicateIds)}"

        let predicate = NSPredicate(format: "idForUpdate IN \(predicateIds)")
        fetchEvents.predicate = predicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchEvents)) as? [HistoricEvent] {
            return fetchResults
        }
        else
        {
            return nil
        }
    }
    
    func fetchQuestionsForChallenge() -> [[String]]
    {
        var blocks:[[String]] = []
        var roundQuestionIds:[String] = []
        for var block = GlobalConstants.numOfQuestionsForRound; block >= 1 ; block--
        {
            var numberOfCardsInBlock = GlobalConstants.minNumDropZones
            if block > 2
            {
                numberOfCardsInBlock++
            }
            if block > 4
            {
                numberOfCardsInBlock++
            }
            if block > 5
            {
                numberOfCardsInBlock = GlobalConstants.maxNumDropZones
            }
            
            let randomHistoricEvents = getRandomHistoricEventsWithPrecision(GlobalConstants.yearPrecisionForChallenge, numEvents:numberOfCardsInBlock)
            for item in randomHistoricEvents
            {
                roundQuestionIds.append("\(item.idForUpdate)")
            }
            blocks.append(roundQuestionIds)
            roundQuestionIds = []
        }

        return blocks
    }
    
    func fetchQuestionsForBadgeChallenge(numblocks:Int, numCardsInBlock:Int, filter:[String], fromLevel:Int,toLevel:Int) -> [[String]]
    {
        self.fetchData(filter,fromLevel:fromLevel,toLevel:toLevel)
        var blocks:[[String]] = []
        var roundQuestionIds:[String] = []
        for var block = numblocks; block >= 1 ; block--
        {
            let randomHistoricEvents = getRandomHistoricEventsWithPrecision(GlobalConstants.yearPrecisionForChallenge, numEvents:numCardsInBlock)
            for item in randomHistoricEvents
            {
                roundQuestionIds.append("\(item.idForUpdate)")
            }
            blocks.append(roundQuestionIds)
            roundQuestionIds = []
        }
        
        return blocks
    }
    
    let DataPopulatedKey = "DataPopulated"
    let OkScoreKey = "OkScore"
    let GoodScoreKey = "GoodScore"
    let LoveScoreKey = "LoveScore"
    let TagsKey = "Tags"
    let LevelKey = "Level"
    let EventsUpdateKey = "EventsUpdate"
    let GameResultsKey = "GameResults"
    let AdFreeKey = "AdFree"
    
    var dataPopulatedValue:AnyObject = 0
    var okScoreValue:AnyObject = 0
    var goodScoreValue:AnyObject = 0
    var loveScoreValue:AnyObject = 0
    var tagsValue:AnyObject = 0
    var levelValue:AnyObject = 0
    var eventsUpdateValue:AnyObject = 0
    var adFreeValue:AnyObject = 0
    
    var gameResultsValues:[AnyObject] = []
    
    func loadGameData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = (documentsDirectory as NSString).stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            } else {
                print("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("GameData.plist already exits at path. \(path)")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            dataPopulatedValue = dict.objectForKey(DataPopulatedKey)!
            okScoreValue = dict.objectForKey(OkScoreKey)!
            goodScoreValue = dict.objectForKey(GoodScoreKey)!
            loveScoreValue = dict.objectForKey(LoveScoreKey)!
            tagsValue = dict.objectForKey(TagsKey)!
            levelValue = dict.objectForKey(LevelKey)!
            eventsUpdateValue = dict.objectForKey(EventsUpdateKey)!
            adFreeValue = dict.objectForKey(AdFreeKey)!
            NSUserDefaults.standardUserDefaults().setBool(adFreeValue as! NSNumber == 1 ? true : false, forKey: "adFree")
            NSUserDefaults.standardUserDefaults().synchronize()
            gameResultsValues = dict.objectForKey(GameResultsKey)! as! [AnyObject]
        } else {
            print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
        }
    }
    
    func saveGameData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        dict.setObject(dataPopulatedValue, forKey: DataPopulatedKey)
        dict.setObject(okScoreValue, forKey: OkScoreKey)
        dict.setObject(goodScoreValue, forKey: GoodScoreKey)
        dict.setObject(loveScoreValue, forKey: LoveScoreKey)
        dict.setObject(tagsValue, forKey: TagsKey)
        dict.setObject(levelValue, forKey: LevelKey)
        dict.setObject(eventsUpdateValue, forKey: EventsUpdateKey)
        dict.setObject(adFreeValue, forKey: AdFreeKey)
        dict.setObject(gameResultsValues, forKey: GameResultsKey)
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved GameData.plist file is --> \(resultDictionary?.description)")
    }
    
    func getMaxTimeLimit(year: Double) -> Double
    {
        return year > todaysYear ? todaysYear : year
    }
}


