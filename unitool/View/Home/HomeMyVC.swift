//
//  HomeMyVC.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/22.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit



class HomeMyVC: UIViewController{
    let menuList = ["時間割の同期・通知","学内アカウント設定"]
    let tableView = UITableView()
    let versionLabel = UILabel()
    
   func setSchoolACButtonEvent() {
            self.present(getNavVC(view: SubSchoolAccountVC()), animated: true)
    }
    
    @objc func ScoreButtonEvent() {
        showAlert(type: 3, msg: "読み取り中")
        tableView.isUserInteractionEnabled = false
        SchoolAPI.getScore(completion: { (success, msg, data) in
            switch success{
            case true:
                scoreData = data
                self.present(getNavVC(view: SubScoreVC()), animated: true)
            case false:
                attendData = []
                showAlert(type: 2, msg: msg ?? "エラー")
            }
            self.tableView.isUserInteractionEnabled = true
        })
        
    }
    
    func LogoutButtonEvent() {
        /* Only Universal Version Use
         
        let alert: UIAlertController = UIAlertController(title: "ログアウト", message: "ログアウトしてよろしいでしょうか?\n次回ご利用の際に学内アカウントの情報の再入力が必要です。", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ログアウト", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            logoutUser()
            self.dismiss(animated: true)
            var window: UIWindow?
            window = (UIApplication.shared.delegate?.window)!
            window?.rootViewController = WelcomeViewController()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
         
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        getVersionInfo()
    }
    
    func getVersionInfo() {
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"]
        let minorVersion = infoDictionary["CFBundleVersion"] as! String
        let appVersion = majorVersion as! String
        versionLabel.text = "ユニツ(TCU) \(appVersion)-(\(minorVersion))"
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.systemFont(ofSize: 13)
        versionLabel.textColor = Color_Main.lighter()
    }
    
    @objc func userAccountImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        /* Only Universal Version Use
        self.navigationController?.pushViewController(SubAccountSetting(), animated: true)
        */
    }
    
    func setupVC(){
        let userAccountLogo = UIImageView()
        let userAccountEmail = UILabel()
        userAccountLogo.image = UIImage(named: "icon_user")
        userAccountEmail.text = nil
        userAccountEmail.textAlignment = .center
        userAccountEmail.textColor = Color_Main.lighter()
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userAccountImageTapped(tapGestureRecognizer:)))
        //userAccountLogo.isUserInteractionEnabled = true
        //userAccountLogo.addGestureRecognizer(tapGestureRecognizer)
        self.title = "設定"
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.view.addSubview(userAccountLogo)
        self.view.addSubview(userAccountEmail)
        self.view.addSubview(versionLabel)
        userAccountLogo.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        userAccountEmail.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(userAccountLogo.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.top.equalTo(userAccountEmail.snp.bottom).offset(15)
            //make.bottom.equalToSuperview().offset(-20)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}

extension HomeMyVC:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 2:
            LogoutButtonEvent()
        case 0:
            self.navigationController?.pushViewController(SubSettingTimeTable(), animated: true)
        case 1:
            setSchoolACButtonEvent()
        default:
            print("no Switch")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let icon = UIImageView()
        let text = UILabel()
        icon.image = UIImage(named: "menu_icon_\(indexPath.row)")
        text.textColor = Color_Main.lighter()
        text.text = menuList[indexPath.row]
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 14)
        cell.addSubview(icon)
        cell.addSubview(text)
        icon.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        text.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return cell
    }
    
    
}
