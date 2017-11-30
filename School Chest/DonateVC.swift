//
//  DonateViewController.swift
//  School Chest
//
//  Created by Josh Oettinger on 10/25/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import ChameleonFramework

class DonateVC: UIViewController {
    @IBOutlet var button: UIButton!
    let url = URL(string: "https://www.razoo.com/team/V8018g")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = FlatPurple()
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = true
        
        self.view.backgroundColor = GradientColor(.topToBottom,
                                                  frame: self.view.frame,
                                                  colors: [HexColor("B6FBFF")!, HexColor("83A4D4")!])
    }
    
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
