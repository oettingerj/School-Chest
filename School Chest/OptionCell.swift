//
//  OptionCell.swift
//  School Chest
//
//  Created by Josh Oettinger on 11/2/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import SwiftyJSON
import ChameleonFramework
import FirebaseStorage

class OptionCell: UICollectionViewCell, EKEventEditViewDelegate {
    @IBOutlet var button: UIButton!
    
    var buttonType: ButtonType = .calendarExport
    var viewController = UIViewController()
    let eventStore = EKEventStore()
    var eventInfo = JSON()
    var date = Date()
    var couponRef = StorageReference()
    var isPDF = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup() {
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = NSTextAlignment.center
        switch buttonType {
        case .calendarExport:
            button.setTitle("Export to Calendar", for: .normal)
            self.backgroundColor = FlatMint()
            button.setTitleColor(ContrastColorOf(self.backgroundColor ?? FlatBlack(), returnFlat: true), for: .normal)
        case .fileView:
            button.setTitle("View Coupon", for: .normal)
            self.backgroundColor = FlatBlue()
            button.setTitleColor(ContrastColorOf(self.backgroundColor ?? FlatBlack(), returnFlat: true), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func buttonPress(_ sender: UIButton) {
        switch buttonType {
        case .calendarExport:
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = self.eventInfo["title"].stringValue
                    event.startDate = self.date
                    event.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: self.date)
                    event.location = self.eventInfo["location"].stringValue
                    
                    let controller = EKEventEditViewController()
                    controller.event = event
                    controller.eventStore = self.eventStore
                    controller.editViewDelegate = self
                    self.viewController.present(controller, animated: true)
                }
            })
        case .fileView:
            if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "couponView") as? CouponVC {
                vc.couponRef = couponRef
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    enum ButtonType {
        case calendarExport
        case fileView
    }
}
