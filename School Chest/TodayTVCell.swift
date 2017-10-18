//
//  TodayTVCell.swift
//  School Chest
//
//  Created by Josh Oettinger on 6/30/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SwiftyJSON

class TodayTVCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var eventsCollection: UICollectionView!
    
    var ref: FIRDatabaseReference!
    var events: JSON = JSON()
    var row = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventsCollection.delegate = self
        eventsCollection.dataSource = self
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(events.dictionary != nil){
            return events["day\(row + 1)"]["events"].count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventsCollection.dequeueReusableCell(withReuseIdentifier: "TodayCVCell", for: indexPath) as! TodayCVCell
        cell.backgroundColor = GradientColor(.diagonal, frame: self.frame, colors: [UIColor.randomFlat, UIColor.randomFlat])
        cell.title.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.descrip.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.eventInfo = events["day\(row + 1)"]["events"]["event\(indexPath.item + 1)"]
        cell.setLabels()
        return cell
    }
}
