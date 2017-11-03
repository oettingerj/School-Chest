//
//  DonateViewController.swift
//  School Chest
//
//  Created by Josh Oettinger on 10/25/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import WebKit

class DonateViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.razoo.com/team/V8018g")
        let req = URLRequest(url: url!)
        webView.load(req)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        webView = WKWebView(frame: .zero)
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        view = webView
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
