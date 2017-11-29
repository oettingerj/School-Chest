//
//  AppDelegate.swift
//  School Chest
//
//  Created by Josh Oettinger on 6/29/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted == true {
                NSLog("Granted")
                UIApplication.shared.registerForRemoteNotifications()
            }
            if let error = error {
                NSLog("Error: \(error.localizedDescription)")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
