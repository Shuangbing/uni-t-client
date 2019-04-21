//
//  AppDelegate.swift
//  unitool
//
//  Created by そうへい on 2018/11/19.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit

var UserData = User()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // update timetable data from version1.0.X
        update_from_v1()
        // ---------------------------------------
        UserData = readUser()
        print(UserData)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let tabBarVC = window?.rootViewController as? HomeTabBarController else { return }
        UserData = readUser()
        switch shortcutItem.type {
        case "attend":
            tabBarVC.selectedIndex = 1
        case "time":
            tabBarVC.selectedIndex = 0
        case "tool":
            tabBarVC.selectedIndex = 2
        default:
            tabBarVC.selectedIndex = 0
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

