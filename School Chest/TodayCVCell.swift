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
        descrip.text = eventInfo["location"].stringValue + " @ " + eventInfo["time"].stringValue
        image.sd_setImage(with: imageRef)
    }
}
