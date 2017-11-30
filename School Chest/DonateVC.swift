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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
