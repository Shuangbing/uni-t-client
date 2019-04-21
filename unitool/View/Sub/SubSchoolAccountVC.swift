//
//  HomeSchoolAccount.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/25.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit

class SubSchoolAccountVC: UIViewController{
    let InputACUser = InputView()
    let InputACPsw = InputView()
    let InputACSave = InputButton()
    let InputACDelect = InputButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.schoolAccount.count < 10{
            setupVC_Add()
            self.present(getNavVC(view: SubPolicyWebView()), animated: true)
        }else{
            setupVC_Del()
        }
        
    }
    
    @objc func setSchoolAccount(){
        if isAgreePolicy == true{
            SchoolAPI.check(completion: { (success, msg, data) in
                switch success{
                case true:
                    showAlert(type: 1, msg: msg ?? "完了")
                    self.dismiss(animated: true)
                case false:
                    showAlert(type: 2, msg: msg ?? "エラー")
                }
            }, user: InputACUser.Input.text ?? "", psw: InputACPsw.Input.text ?? "")
        }else{
            self.present(getNavVC(view: SubPolicyWebView()), animated: true)
        }
    }
    
    @objc func delSchoolAccount(){
        logoutUser()
        showAlert(type: 1, msg: "削除しました")
        self.dismiss(animated: true)
    }
    
    func setupVC_Del(){
        self.title = "学内アカウント"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backMyEvent(_:)))
        InputACUser.Lable.text = "アカウント"
        InputACPsw.Lable.text = "パスワード"
        InputACUser.Input.text = "********"
        InputACPsw.Input.text = "********"
        InputACUser.Input.isUserInteractionEnabled = false
        InputACPsw.Input.isUserInteractionEnabled = false
        InputACUser.Input.isSecureTextEntry = true
        InputACPsw.Input.isSecureTextEntry = true
        InputACDelect.setBackgroundImage(UIImage(color: UIColor.red.lighter()), for: .normal)
        InputACDelect.setBackgroundImage(UIImage(color: UIColor.red.lighter().darkened()), for: .highlighted)
        InputACDelect.setTitle("削除", for: .normal)
        InputACDelect.addTarget(self, action: #selector(SubSchoolAccountVC.delSchoolAccount), for: .touchUpInside)
        self.view.addSubview(InputACUser)
        self.view.addSubview(InputACPsw)
        self.view.addSubview(InputACDelect)
        InputACUser.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(70)
            make.top.equalTo(self.view).offset(25)
            make.centerX.equalTo(self.view)
        }
        InputACPsw.snp.makeConstraints { (make) in
            make.width.height.equalTo(InputACUser)
            make.top.equalTo(InputACUser.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
        }
        InputACDelect.snp.makeConstraints { (make) in
            make.top.equalTo(InputACPsw.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(245)
            make.height.equalTo(50)
        }
    }
    
    func setupVC_Add(){
        self.title = "学内アカウント"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backMyEvent(_:)))
        InputACUser.Lable.text = "アカウント"
        InputACPsw.Lable.text = "パスワード"
        InputACPsw.Input.isSecureTextEntry = true
        InputACSave.setTitle("保存", for: .normal)
        InputACSave.addTarget(self, action: #selector(SubSchoolAccountVC.setSchoolAccount), for: .touchUpInside)
        self.view.addSubview(InputACUser)
        self.view.addSubview(InputACPsw)
        self.view.addSubview(InputACSave)
        InputACUser.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(70)
            make.top.equalTo(self.view).offset(25)
            make.centerX.equalTo(self.view)
        }
        InputACPsw.snp.makeConstraints { (make) in
            make.width.height.equalTo(InputACUser)
            make.top.equalTo(InputACUser.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
        }
        InputACSave.snp.makeConstraints { (make) in
            make.top.equalTo(InputACPsw.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(245)
            make.height.equalTo(50)
        }
    }
    
    @objc func backMyEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
