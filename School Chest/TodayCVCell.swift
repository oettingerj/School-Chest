//
//  TodayCVCell.swift
//  School Chest
//
//  Created by Josh Oettinger on 7/28/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import SwiftyJSON

class TodayCVCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var descrip: UILabel!
    
    var eventInfo: JSON = JSON()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLabels(){
        title.text = eventInfo["title"].stringValue
        descrip.text = eventInfo["location"].stringValue + " @ " + eventInfo["time"].stringValue
    }
}
