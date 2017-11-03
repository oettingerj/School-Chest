//
//  TodayVC.swift
//  School Chest
//
//  Created by Josh Oettinger on 6/29/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import ChameleonFramework

class TodayVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var eventTable: UITableView!
    
    var ref: DatabaseReference!
    var events: JSON = JSON()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        
        ref.child("calendar").observeSingleEvent(of: .value, with: { (snapshot) in
            self.events = JSON(snapshot.value!)
            self.eventTable.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.tabBarController?.tabBar.tintColor = UIColor.flatWhite
        
        eventTable.delegate = self
        eventTable.dataSource = self
        
        eventTable.sectionHeaderHeight = 20
        eventTable.sectionFooterHeight = 20
        
        self.view.backgroundColor = GradientColor(.topToBottom, frame: self.view.frame, colors: [HexColor("B6FBFF")!, HexColor("83A4D4")!])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.dictionary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = events["day\(section + 1)"]["date"].stringValue
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let todaystr = formatter.string(from: today)
        let tomorrowstr = formatter.string(from: tomorrow!)
        if(date == todaystr){
            return "Today"
        } else if(date == tomorrowstr){
            return "Tomorrow"
        } else{
            return date
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTable.dequeueReusableCell(withIdentifier: "TodayTVCell")! as! TodayTVCell
        cell.viewController = self
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        cell.date = formatter.date(from: events["day\(indexPath.section + 1)"]["date"].stringValue) ?? Date()
        cell.events = events
        cell.row = indexPath.section
        cell.eventsCollection.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = FlatBlack()
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

