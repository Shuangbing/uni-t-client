//
//  HomeAttendVC.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/21.
//  Copyright © 2018 Shuangbing. All rights reserved.
//

import UIKit
import SwiftyJSON
import ViewAnimator

let SchoolAPI = UnitSchool()
var attendData = JSON.init()

class HomeAttendVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let footerView = UIView()
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let noAttendIMG = UIImageView()
    let noAttendText = UILabel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(attendData.count != 0){
            noAttendIMG.isHidden = true
            noAttendText.isHidden = true
        }else{
            noAttendIMG.isHidden = false
            noAttendText.isHidden = false
        }
        return attendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attend_data_tmp = attendData[indexPath.row][1].stringValue.components(separatedBy: "  ")
        return getAttendCell(subject: attend_data_tmp[0], users: attend_data_tmp[1])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let attendsend = AttendSendVC()
        attendsend.indexpath = indexPath.row
        self.navigationController?.pushViewController(attendsend, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        getAttendListEvent()
    }

    func setupVC(){
        var reflashBtn: UIBarButtonItem!
        noAttendIMG.image = UIImage(named: "noAttend")
        noAttendText.text = "出席情報がありません\n上からスワイプすると更新できます"
        noAttendText.font = UIFont.systemFont(ofSize: 13)
        noAttendText.textColor = Color_Main.lighter()
        noAttendText.textAlignment = .center
        noAttendText.numberOfLines = 0
        self.view.addSubview(noAttendIMG)
        self.view.addSubview(noAttendText)
        noAttendIMG.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
        noAttendText.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
            make.top.equalTo(noAttendIMG.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.separatorStyle = .none
        tableView.backgroundColor = self.view.backgroundColor
        self.view.backgroundColor = Color_Back
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        self.title = "出席登録"
        reflashBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(HomeAttendVC.getAttendListEvent))
        self.navigationItem.rightBarButtonItem = reflashBtn
        refreshControl.addTarget(self, action: #selector(HomeAttendVC.getAttendListEvent), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "読み取り中...")
        tableView.addSubview(refreshControl)
    }
    
    func refreshControlValueChanged(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            sender.endRefreshing()
        })
    }
    
    @objc func getAttendListEvent() {
        if isLogined() == true
        {
            SchoolAPI.getAttendList(completion: { (success, msg, data) in
                self.refreshControl.beginRefreshing()
                self.refreshControlValueChanged(sender: self.refreshControl)
                switch success{
                case true:
                    attendData = data
                    self.tableView.reloadData()
                    UIView.animate(views: self.tableView.visibleCells,animations: [fromAnimation, zoomAnimation], delay: 0.5)
                    if attendData.count == 1{
                        let attendsend = AttendSendVC()
                        attendsend.indexpath = 0
                        self.navigationController?.pushViewController(attendsend, animated: true)
                    }
                case false:
                    attendData = []
                    self.tableView.reloadData()
                    showAlert(type: 2, msg: msg ?? "エラー")
                }
            })
        }else{
            self.refreshControlValueChanged(sender: self.refreshControl)
            showAlert(type: 2, msg: "学内アカウントの設定が必要です")
        }}
}

class AttendSendVC: UIViewController{
    
    var indexpath = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.title = "送信"
        self.view.backgroundColor = Color_Back
        let attend_data_tmp = attendData[indexpath][1].stringValue.components(separatedBy: "  ")
        let cellView = getAttendCell(subject: attend_data_tmp[0], users: attend_data_tmp[1])
        self.view.addSubview(cellView)
        cellView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.height.equalTo(80)
            make.width.equalTo(self.view)
        }
        let attendNo = attendNOView()

        self.view.addSubview(attendNo)
        
        attendNo.snp.makeConstraints { (make) in
            make.top.equalTo(cellView.snp.bottom).offset(25)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(160)
        }
    }
    
    @objc func attendSend(_ sender: UIButton) {
        if isLogined() == true
        {
            print(attendData)
            let attendNO = sender.titleLabel?.text ?? "0"
            let alert: UIAlertController = UIAlertController(title: "出席登録", message: "\(attendData[indexpath][1].stringValue)\n指定番号:\(attendNO)\n送信してもよろしいでしょうか？", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "送信", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                SchoolAPI.sendAttend(completion: { (success, msg, data) in
                    switch success{
                    case true:
                        showAlert(type: 1, msg: msg ?? "完成")
                        self.navigationController?.popToRootViewController(animated: true)
                        self.dismiss(animated: true)
                    case false:
                        showAlert(type: 2, msg: msg ?? "エラー")
                    }
                }, attenddata: attendData[self.indexpath][0].stringValue, attendno: attendNO)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            showAlert(type: 2, msg: "学内アカウントの設定が必要です")
        }

    }
    
    func attendNOView()->UIView{
        let noView = UIView()
        var noBtn: [UIButton] = []
        
        for index in 0 ..< 9 {
            let button = InputButton()
            button.setBackgroundImage(UIImage(color: Color_Main), for: .normal)
            button.setBackgroundImage(UIImage(color: Color_Main.darkened()), for: .highlighted)
            button.setTitle("\(index+1)", for: .normal)
            button.addTarget(self, action: #selector(self.attendSend(_:)), for: .touchUpInside)
            noView.addSubview(button)
            noBtn.append(button)
        }
        
        for index in 0 ..< 9 {
            switch Int(index/3){
            case 0:
                noBtn[index].snp.makeConstraints { (make) in
                    make.width.height.equalTo(noView).dividedBy(3.1)
                    make.left.equalTo(noView).offset(index*55)
                    make.top.equalTo(noView)
                }
            case 1:
                noBtn[index].snp.makeConstraints { (make) in
                    make.width.height.equalTo(noBtn[index-3])
                    make.left.equalTo(noBtn[index-3])
                    make.top.equalTo(noBtn[index-3].snp.bottom).offset(10)
                }
            case 2:
                noBtn[index].snp.makeConstraints { (make) in
                    make.width.height.equalTo(noBtn[index-3])
                    make.left.equalTo(noBtn[index-3])
                    make.top.equalTo(noBtn[index-3].snp.bottom).offset(10)
                }
            default:
                print("end")
            }
        }
        return noView
    }
    
}


//public view create
func getAttendCell(subject: String, users: String) -> UITableViewCell {
    let SubjcetLabel = UILabel()
    let TeacherLabel = UILabel()
    SubjcetLabel.text = subject
    SubjcetLabel.textColor = Color_Main
    TeacherLabel.text = "\(users)"
    TeacherLabel.font = UIFont.systemFont(ofSize: 15)
    TeacherLabel.textColor = Color_Main
    let SubjectICON = UIImageView()
    SubjectICON.image = UIImage(named: "cell_subject")
    let TeacherICON = UIImageView()
    TeacherICON.image = UIImage(named: "cell_teacher")
    let AttendCell = UITableViewCell()
    AttendCell.backgroundColor = .white
    AttendCell.addSubview(SubjcetLabel)
    AttendCell.addSubview(TeacherLabel)
    AttendCell.addSubview(SubjectICON)
    AttendCell.addSubview(TeacherICON)
    SubjectICON.snp.makeConstraints { (make) in
        make.top.equalTo(AttendCell).offset(20)
        make.left.equalTo(AttendCell).offset(10)
        make.width.height.equalTo(16)
    }
    SubjcetLabel.snp.makeConstraints { (make) in
        make.top.equalTo(SubjectICON).offset(-1)
        make.left.equalTo(SubjectICON).offset(20)
        make.width.equalTo(AttendCell).offset(-10)
        make.height.equalTo(20)
    }
    TeacherICON.snp.makeConstraints { (make) in
        make.top.equalTo(SubjectICON).offset(25)
        make.left.equalTo(AttendCell).offset(10)
        make.width.height.equalTo(16)
    }
    TeacherLabel.snp.makeConstraints { (make) in
        make.top.equalTo(TeacherICON).offset(-1)
        make.left.equalTo(TeacherICON).offset(20)
        make.width.equalTo(AttendCell).offset(-10)
        make.height.equalTo(20)
    }
    return AttendCell
}
