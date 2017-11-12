//
//  TodayCVCell.swift
//  School Chest
//
//  Created by Josh Oettinger on 7/28/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseStorage
import FirebaseStorageUI

class TodayCVCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var descrip: UILabel!
    
    var eventInfo: JSON = JSON()
    var imageRef = Storage.storage().reference()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        imageRef = imageRef.child("Event Icons/placeholder.png")
    }
    
    func setLabels(){
        title.adjustsFontSizeToFitWidth = true
        descrip.adjustsFontSizeToFitWidth = true
        title.text = eventInfo["title"].stringValue
        let time = eventInfo["time"].stringValue
        let location = eventInfo["location"].stringValue
        if(time == "00:00"){
            descrip.text = "All Day @ " + location
        } else{
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let time12 = formatter.date(from: time) ?? Date()
            formatter.dateFormat = "hh:mm a"
            descrip.text = location + " @ " + formatter.string(from: time12)
        }
        image.sd_setImage(with: imageRef)
    }
}
