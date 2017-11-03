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
import Presentr

class TodayTVCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var eventsCollection: UICollectionView!
    
    var ref: DatabaseReference!
    var events: JSON = JSON()
    var row = 0
    var date = Date()
    weak var viewController = UIViewController()
    var presenter = Presentr(presentationType: .popup)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventsCollection.delegate = self
        eventsCollection.dataSource = self
        
        presenter.dismissOnSwipe = true
        presenter.blurBackground = true
        presenter.blurStyle = .regular
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        tap.numberOfTapsRequired = 1
        eventsCollection.addGestureRecognizer(tap)
        
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
    
    func combineDateAndTime(eventTime: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.date(from: eventTime)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time ?? Date())
        
        var mergedComponments = DateComponents()
        mergedComponments.year = Calendar.current.component(.year, from: Date())
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        date = calendar.date(from: mergedComponments) ?? date
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer){
        let pointInCollectionView = gesture.location(in: self.eventsCollection)
        let selectedIndexPath = self.eventsCollection.indexPathForItem(at: pointInCollectionView)
        let tvCell = self.eventsCollection.cellForItem(at: selectedIndexPath!) as! TodayCVCell
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "popup") as! PopupViewController
        vc.eventInfo = tvCell.eventInfo
        combineDateAndTime(eventTime: vc.eventInfo["time"].stringValue)
        vc.date = date
        viewController!.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
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
