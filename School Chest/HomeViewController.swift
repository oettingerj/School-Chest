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

class HomeViewController: UIViewController {
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
        if(defaults.object(forKey: "events") == nil){
            let ref = Database.database().reference()
            ref.child("calendar").observeSingleEvent(of: .value, with: { (snapshot) in
                self.events = JSON(snapshot.value!)
                defaults.set(self.events.rawString(), forKey: "events")
                
                let lunch = self.getLunch()
                self.lunchLabel.adjustsFontSizeToFitWidth = true
                if(lunch != ""){
                    self.lunchLabel.text = "Today's Lunch: " + lunch
                } else{
                    self.lunchLabel.text = "Next Lunch: " + self.getNextLunch()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else{
            events = JSON.init(parseJSON: defaults.object(forKey: "events") as! String)
            let lunch = getLunch()
            lunchLabel.adjustsFontSizeToFitWidth = true
            if(lunch != ""){
                lunchLabel.text = "Today's Lunch: " + lunch
            } else{
                lunchLabel.text = "Next Lunch: " + getNextLunch()
            }
        }
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM dd"
        dateLabel.text = formatter.string(from: todayDate)
        
        let ref = Database.database().reference()
        var annString = ""
        ref.child("announcements").observeSingleEvent(of: .value, with: { (snapshot) in
            self.announcementList = JSON(snapshot.value!)
            let bulletPoint: String = "\u{2022}"
            for (_, object) in self.announcementList{
                let str = "\(bulletPoint) \(object.stringValue)\n"
                annString.append(str)
            }
            
            self.announcementsView.text = annString
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        self.view.backgroundColor = GradientColor(.topToBottom, frame: self.view.frame, colors: [HexColor("B6FBFF")!, HexColor("83A4D4")!])
        announcementsContainer.backgroundColor = GradientColor(.diagonal, frame: announcementsContainer.frame, colors: gradientFromColor(color: FlatWhite()))
        announcementsContainer.layer.cornerRadius = 5.0
        announcementsView.textColor = ContrastColorOf(announcementsContainer.backgroundColor!, returnFlat: true)
        
        lunchView.backgroundColor = GradientColor(.diagonal, frame: lunchView.frame, colors: gradientFromColor(color: FlatGreen()))
        lunchView.layer.cornerRadius = 5.0
        lunchLabel.textColor = ContrastColorOf(lunchView.backgroundColor!, returnFlat: true)
    }
    
    func createParagraphAttribute() ->NSParagraphStyle{
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }
    
    func gradientFromColor(color: UIColor) -> [UIColor]{
        return [color.darken(byPercentage: 0.1)!, color.lighten(byPercentage: 0.1)!]
    }
    
    func getLunch() -> String{
        var iter = events.makeIterator()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let todaystr = formatter.string(from: today)
        
        while let day = iter.next(){
            let date = day.1["date"].stringValue
            if(date == todaystr){
                return day.1["lunch"].stringValue
            }
        }
        return ""
    }
    
    func getNextLunch() -> String{
        var iter = events.makeIterator()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        var dayCount = 1
        
        while let day = iter.next(){
            let items = day.1
            dayCount += 1
            let date = items["date"].stringValue
            var dateVal = formatter.date(from: date) ?? Date()
            let timeComponents = Calendar.current.dateComponents([.day, .month], from: dateVal)
            
            var mergedComponments = DateComponents()
            mergedComponments.year = Calendar.current.component(.year, from: Date())
            mergedComponments.month = timeComponents.month
            mergedComponments.day = timeComponents.day
            dateVal = Calendar.current.date(from: mergedComponments) ?? dateVal
            
            if(dateVal > today){
                let lunch = items["lunch"].stringValue
                if(lunch != ""){
                    return items["lunch"].stringValue + " on " + date
                }
            }
        }
        return ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
