//
//  TabViewController.swift
//  School Chest
//
//  Created by Josh Oettinger on 11/1/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import ChameleonFramework

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = FlatBlack()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
