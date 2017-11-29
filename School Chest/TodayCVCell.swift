//
//  TodayCVCell.swift
//  School Chest
//
//  Created by Josh Oettinger on 7/28/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

class TodayCVCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!
    
    var eventInfo: JSON = JSON()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLabels() {
        title.adjustsFontSizeToFitWidth = true
        time.adjustsFontSizeToFitWidth = true
        location.adjustsFontSizeToFitWidth = true
        title.text = eventInfo["title"].stringValue
        let eventTime = eventInfo["time"].stringValue
        let eventLoc = eventInfo["location"].stringValue
        if eventTime == "00:00" {
            time.text = "All Day"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let time12 = formatter.date(from: eventTime) ?? Date()
            formatter.dateFormat = "hh:mm a"
            time.text = formatter.string(from: time12)
        }
        location.text = eventLoc
    }
    
    func initCategoryItems() {
        let category = eventInfo["category"].stringValue
        switch category {
        case "portion":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatMint()))
            image.image = #imageLiteral(resourceName: "portion")
        case "fitness":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatRed()))
            image.image = #imageLiteral(resourceName: "fitness")
        case "announcement":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatSkyBlue()))
            image.image = #imageLiteral(resourceName: "announcement")
        case "test":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatSand()))
            image.image = #imageLiteral(resourceName: "test")
        case "bee":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatYellow()))
            image.image = #imageLiteral(resourceName: "bee")
        case "benefit":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatPurple()))
            image.image = #imageLiteral(resourceName: "benefit")
        case "run":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatNavyBlue()))
            image.image = #imageLiteral(resourceName: "run")
            image.image = image.image?.withRenderingMode(.alwaysTemplate)
            image.tintColor = ContrastColorOf(self.backgroundColor!, returnFlat: true)
        case "idol":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatBlue()))
            image.image = #imageLiteral(resourceName: "idol")
        case "food":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatCoffee()))
            image.image = #imageLiteral(resourceName: "food")
        case "warrior":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatBlack()))
            image.image = #imageLiteral(resourceName: "warrior")
            image.image = image.image?.withRenderingMode(.alwaysTemplate)
            image.tintColor = ContrastColorOf(self.backgroundColor!, returnFlat: true)
        case "hoops":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatOrange()))
            image.image = #imageLiteral(resourceName: "basketball")
        case "game":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatWatermelon()))
            image.image = #imageLiteral(resourceName: "game")
        case "fashion":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatPink()))
            image.image = #imageLiteral(resourceName: "fashion")
        case "movie":
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: FlatWhiteDark()))
            image.image = #imageLiteral(resourceName: "movie")
        default:
            self.backgroundColor = GradientColor(.diagonal,
                                                 frame: self.frame,
                                                 colors: gradientFromColor(color: UIColor.randomFlat))
        }
        
        title.textColor = ContrastColorOf(self.backgroundColor!, returnFlat: true)
        time.textColor = ContrastColorOf(self.backgroundColor!, returnFlat: true)
        location.textColor = ContrastColorOf(self.backgroundColor!, returnFlat: true)
    }
    
    func gradientFromColor(color: UIColor) -> [UIColor] {
        return [color.darken(byPercentage: 0.1)!, color.lighten(byPercentage: 0.1)!]
    }
}
