//
//  HomeVC.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/20.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import SnapKit
import UIKit
import SwiftyJSON

let TimeTableView = getNavVC(view: HomeTimeTableVC())
let AttendTabView = getNavVC(view: HomeAttendVC())
var UserTabView = getNavVC(view: HomeMyVC())
let NavVC = UINavigationController()

var UserSetting:JSON!


class HomeTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        initShareMenu()
        //setupUser()
    }
    
    func initSetting(){
        let SettingData = UserDefaults.standard.string(forKey: "UserSetting")
        
        if SettingData != nil{
            UserSetting = JSON(SettingData!.data(using: .utf8)!)
        }else{
            let settingDataInit = base64Decoding(encodedString: "eyJ2ZXJzaW9uIjoxMDAsInRpbWV0YWJsZSI6eyJwZXJpb2QiOjUsIndlZWtkYXkiOjAsIm5vZml0eSI6dHJ1ZSwicGVyaW9kTGlzdCI6W1s1NDAsNjQwXSxbNjUwLDc1MF0sWzgwMCw5MDBdLFs5MTAsMTAxMF0sWzEwMjAsMTEyMF1dfX0=").data(using: .utf8)
            UserSetting = JSON(settingDataInit!)
            UserDefaults.standard.set(UserSetting.rawString(),forKey: "UserSetting")
            print("init setting")
        }
        
        for schoolData in SUPPORT_SCHOOL{
            if schoolData["id"].intValue == UserData.school{
                USER_SCHOOL = schoolData.arrayValue
            }
        }
    }
    
    
    func setupVC(){
        UserData = readUser()
        initSetting()
        self.view.backgroundColor = Color_Back
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = Color_Main
        self.tabBar.isTranslucent = false
        //Init TabBarItem
        TimeTableView.tabBarItem = UITabBarItem(title: "時間割", image: UIImage(named: "bar_timetable"), tag: 0)
        TimeTableView.view.backgroundColor = Color_Back
        AttendTabView.tabBarItem = UITabBarItem(title: "出席登録", image: UIImage(named: "bar_attend"), tag: 0)
        NavVC.tabBarItem = AttendTabView.tabBarItem
        UserTabView = getNavVC(view: HomeMyVC())
        UserTabView.tabBarItem = UITabBarItem(title: "設定", image: UIImage(named: "bar_user"), tag: 0)
        UserTabView.view.backgroundColor = .white
        self.setViewControllers([TimeTableView,AttendTabView,UserTabView], animated: true)
    }
    
    func initShareMenu(){
        let attendIcon = UIApplicationShortcutIcon(templateImageName: "bar_attend")
        let attendItem = UIApplicationShortcutItem(type: "attend", localizedTitle: "出席登録", localizedSubtitle: nil, icon: attendIcon, userInfo: nil)
        let timeIcon = UIApplicationShortcutIcon(templateImageName: "bar_timetable")
        let timeItem = UIApplicationShortcutItem(type: "time", localizedTitle: "時間割", localizedSubtitle: nil, icon: timeIcon, userInfo: nil)
        let toolIcon = UIApplicationShortcutIcon(templateImageName: "bar_user")
        let toolItem = UIApplicationShortcutItem(type: "tool", localizedTitle: "設定", localizedSubtitle: nil, icon: toolIcon, userInfo: nil)
        UIApplication.shared.shortcutItems = [toolItem,attendItem, timeItem]
    }
}

func getNavVC(view: UIViewController) -> UINavigationController{
    let navVC = UINavigationController()
    let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navVC.setViewControllers([view],animated: true)
    navVC.navigationBar.isTranslucent = false
    navVC.navigationBar.barTintColor = Color_Main
    navVC.navigationBar.tintColor = .white
    navVC.navigationBar.titleTextAttributes = textAttributes
    if #available(iOS 11.0, *) {
        navVC.navigationBar.largeTitleTextAttributes = textAttributes
        navVC.navigationBar.prefersLargeTitles = true
    }
    navVC.navigationBar.barStyle = .black
    navVC.tabBarItem = view.tabBarItem
    return navVC
}
