//
//  HomeViewController.swift
//  School Chest
//
//  Created by Josh Oettinger on 11/23/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import ChameleonFramework
import SwifterSwift

class HomeVC: UIViewController {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var lunchLabel: UILabel!
    @IBOutlet var announcementsView: UITextView!
    @IBOutlet var lunchView: UIView!
    @IBOutlet var announcementsContainer: UIView!
    
    var events = JSON()
    var announcementList = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "events") == nil {
            let ref = Database.database().reference()
            ref.child("calendar").observeSingleEvent(of: .value, with: { (snapshot) in
                self.events = JSON(snapshot.value!)
                defaults.set(self.events.rawString(), forKey: "events")
                
                let lunch = self.getLunch()
                self.lunchLabel.adjustsFontSizeToFitWidth = true
                if lunch != "" {
                    self.lunchLabel.text = "Today's Lunch: " + lunch
                } else {
                    self.lunchLabel.text = "Next Lunch: " + self.getNextLunch()
                }
            }) { (error) in
                NSLog(error.localizedDescription)
            }
        } else {
            events = JSON.init(parseJSON: defaults.object(forKey: "events") as? String ?? "")
            let lunch = getLunch()
            lunchLabel.adjustsFontSizeToFitWidth = true
            if lunch != "" {
                lunchLabel.text = "Today's Lunch: " + lunch
            } else {
                lunchLabel.text = "Next Lunch: " + getNextLunch()
            }
        }
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM dd"
        dateLabel.text = formatter.string(from: todayDate)
        
        buildAnnouncements()
        
        self.view.backgroundColor = GradientColor(.topToBottom,
                                                  frame: self.view.frame,
                                                  colors: [HexColor("B6FBFF") ?? FlatBlue(),
                                                           HexColor("83A4D4") ?? FlatSkyBlue()])
        announcementsContainer.layer.cornerRadius = 5.0
        announcementsContainer.backgroundColor = FlatWhite()
        announcementsView.textColor = ContrastColorOf(announcementsContainer.backgroundColor!, returnFlat: true)
        
        lunchView.layer.cornerRadius = 5.0
        lunchView.backgroundColor = FlatGreen()
        lunchLabel.textColor = ContrastColorOf(lunchView.backgroundColor!, returnFlat: true)
    }
    
    func buildAnnouncements() {
        let ref = Database.database().reference()
        var annString: [NSMutableAttributedString] = []
        ref.child("announcements").observeSingleEvent(of: .value, with: { (snapshot) in
            self.announcementList = JSON(snapshot.value!)
            for (_, object) in self.announcementList {
                annString.append(NSMutableAttributedString(string: object.stringValue))
            }
            
            ref.child("links").observeSingleEvent(of: .value, with: { (snapshot) in
                let links = JSON(snapshot.value!)
                for (_, object) in links {
                    let title = object["title"].stringValue
                    let url = URL(string: object["url"].stringValue) ?? URL(string: "http://www.schoolchest.org")
                    let link = NSMutableAttributedString(string: title)
                    link.addAttribute(NSAttributedStringKey.link, value: url as Any, range: NSRange(location: 0, length: link.length))
                    annString.append(link)
                }
                self.announcementsView.attributedText = self.bulletedList(strings: annString)
            }) { (error) in
                NSLog(error.localizedDescription)
            }
        }) { (error) in
            NSLog(error.localizedDescription)
        }
    }
    
    func gradientFromColor(color: UIColor) -> [UIColor] {
        return [color.darken(byPercentage: 0.1)!, color.lighten(byPercentage: 0.1)!]
    }
    
    func getLunch() -> String {
        var iter = events.makeIterator()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let todaystr = formatter.string(from: today)
        
        while let day = iter.next() {
            let date = day.1["date"].stringValue
            if date == todaystr {
                return day.1["lunch"].stringValue
            }
        }
        return ""
    }
    
    func getNextLunch() -> String {
        var iter = events.makeIterator()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        var dayCount = 1
        
        var closestDate = today
        var retStr = ""
        while let day = iter.next() {
            let items = day.1
            dayCount += 1
            let date = items["date"].stringValue
            var dateVal = formatter.date(from: date) ?? Date()
            
            dateVal.year = Date().year
            if dateVal > today && closestDate <= today {
                closestDate = dateVal
            }
            
            if dateVal > today && dateVal < closestDate {
                let lunch = items["lunch"].stringValue
                if lunch != "" {
                    retStr = items["lunch"].stringValue + " on " + date
                    closestDate = dateVal
                }
            }
        }
        return retStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bulletedList(strings: [NSMutableAttributedString]) -> NSAttributedString {
        let textAttributesDictionary = [NSAttributedStringKey.font: announcementsView.font!,
                                        NSAttributedStringKey.foregroundColor: UIColor.black] as [NSAttributedStringKey: Any]
        
        let fullAttributedString = NSMutableAttributedString()
        
        for string: NSMutableAttributedString in strings {
            let bulletPoint = NSMutableAttributedString(string: "\u{2022}")
            let attributedString = NSMutableAttributedString(attributedString: bulletPoint + " " + string + "\n")
            let paragraphStyle = createParagraphAttribute()
            
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle],
                                           range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttributes(textAttributesDictionary,
                                           range: NSRange(location: 0, length: attributedString.length))
            
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    func createParagraphAttribute() -> NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left,
                                             location: 15,
                                             options: NSDictionary() as? [NSTextTab.OptionKey: Any] ?? [:])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        paragraphStyle.lineSpacing = 2.0
        
        return paragraphStyle
    }
}
