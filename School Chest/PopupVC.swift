//
//  PopupViewController.swift
//  School Chest
//
//  Created by Josh Oettinger on 11/1/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseStorage

class PopupVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var buttonCollection: UICollectionView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDesc: UITextView!
    
    var eventInfo: JSON = JSON()
    var date = Date()
    var pdfRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCollection.dataSource = self
        buttonCollection.delegate = self
        
        eventTitle.adjustsFontSizeToFitWidth = true
        eventTitle.text = eventInfo["title"].stringValue
        eventDesc.text = eventInfo["description"].stringValue
        let fileName = eventInfo["coupon"].stringValue
        if fileName != "none" {
            pdfRef = pdfRef.child("Event Coupons/" + fileName)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if eventInfo["coupon"].stringValue != "none" {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = buttonCollection.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as? OptionCell {
            cell.layer.cornerRadius = 5.0
            cell.viewController = self
            if indexPath.item > 0 {
                cell.buttonType = .fileView
                cell.couponRef = pdfRef
            } else {
                cell.buttonType = .calendarExport
                cell.eventInfo = eventInfo
                cell.date = date
            }
            cell.setup()
            return cell
        } else {
            return UICollectionViewCell()
        }
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
