//
//  HomeTimeTableVC.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/26.
//  Copyright © 2018 Shuangbing. All rights reserved.
//

import UIKit

let weekday = ["月","火","水","木","金","土","日"]
var comaNum = UserSetting["timetable"]["period"].intValue
var weekDayNum = UserSetting["timetable"]["weekday"].intValue + 5
var timetableData = readAllSubject()
let timeTable = UITableView()
let Nofity = PushNofity()




func updateTimeTable(){
    comaNum = UserSetting["timetable"]["period"].intValue
    weekDayNum = UserSetting["timetable"]["weekday"].intValue + 5
    timetableData = readAllSubject()
    timeTable.reloadData()
    if UserSetting["timetable"]["nofity"].boolValue == true{
        Nofity.onPush()
    }else{
        Nofity.offPush()
    }
     UIView.animate(views: timeTable.visibleCells,animations: Animation_Table)
}

class HomeTimeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comaNum+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 25
        }
        return timeTable.bounds.size.height/CGFloat(comaNum)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            return weekdayLineCell()
        }
        return comaCell(comaNo: indexPath.row)
    }
    
    func comaCell(comaNo: Int)->UITableViewCell{
        var comaSubject: [ComaTable] = []
        let coma =  UITableViewCell()
        let comaNumLabel = UILabel()
        coma.selectionStyle = .none
        coma.backgroundColor = .white
        comaNumLabel.textColor = Color_Back.darkened()
        comaNumLabel.textAlignment = .center
        comaNumLabel.backgroundColor = Color_Back
        comaNumLabel.text = "\(comaNo)"
        let comaView = UIView()
        comaView.backgroundColor = .clear
        coma.addSubview(comaView)
        
        for weekCount in 0...weekDayNum-1{
            let comaSub:ComaTable
            let subject_find = timetableData.filter("week == \(weekCount) and coma == \(comaNo)", "").first
            if  subject_find != nil{
                comaSub = ComaTable(subject: subject_find?.subject ?? "", classroom: subject_find?.classroom ?? "", week: weekCount, coma: comaNo, bgColor: subject_find?.bgColor ?? 0)
            }else{
                comaSub = ComaTable(subject: "", classroom: "", week: weekCount, coma: comaNo, bgColor: -1)
            }
            comaSubject.append(comaSub)
            comaView.addSubview(comaSubject[weekCount])
            let TapTimeEvent = UITapGestureRecognizer(target: self, action: #selector(self.tapTimeTable(_:)))
            comaSubject[weekCount].addGestureRecognizer(TapTimeEvent)
        }
        coma.backgroundColor = .clear
        coma.addSubview(comaNumLabel)
        
        comaNumLabel.snp.makeConstraints { (make) in
            make.left.top.height.equalTo(coma)
            make.width.equalTo(25)
        }
        
        comaView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(coma).inset(5)
            make.left.equalTo(comaNumLabel.snp.right).offset(5)
        }
        
        comaSubject[0].snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(comaView)
            make.width.equalToSuperview().offset(-weekDayNum*4/weekDayNum).dividedBy(weekDayNum)
        }
        for weekCount in 1...weekDayNum-1{
            comaSubject[weekCount].snp.makeConstraints { (make) in
                make.left.equalTo(comaSubject[weekCount-1].snp.right).offset(5)
                make.top.height.width.equalTo(comaSubject[weekCount-1])
            }
        }
        return coma
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    
    func weekdayLineCell()->UITableViewCell{
        let weekdayLineCellView = UITableViewCell()
        var weekDayLabel: [UILabel] = []
        weekdayLineCellView.backgroundColor = Color_Back
        weekdayLineCellView.isUserInteractionEnabled = false
        for week in 0...weekDayNum-1{
            let weekLabel = UILabel()
            weekLabel.textColor = Color_Back.darkened()
            weekLabel.font =  UIFont.boldSystemFont(ofSize: 15)
            weekLabel.backgroundColor =  Color_Back
            weekLabel.text = weekday[week]
            weekLabel.textAlignment = .center
            weekDayLabel.append(weekLabel)
        }
        
        weekdayLineCellView.addSubview(weekDayLabel[0])
        weekDayLabel[0].snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-25/weekDayNum).dividedBy(weekDayNum)
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        for week in 1...weekDayNum-1{
            weekdayLineCellView.addSubview(weekDayLabel[week])
            weekDayLabel[week].snp.makeConstraints { (make) in
                make.width.bottom.top.equalTo(weekDayLabel[0])
                make.left.equalTo(weekDayLabel[week-1].snp.right)
            }
        }
        return weekdayLineCellView
    }
    
    @objc func tapTimeTable(_ sender: UITapGestureRecognizer){
        self.view.layoutIfNeeded()
        let weekdayTap = sender.view?.tag ?? -1
        let comaTap = Int(weekdayTap / 100)
        let weekTap = Int(weekdayTap % 100)
        let EditTime = SubEditTimeTable()
        EditTime.comaEdit = comaTap
        EditTime.weekEdit = weekTap
        self.navigationController?.pushViewController(EditTime, animated: true)
    }
    @objc func delAllTimeTable(){
        let alert: UIAlertController = UIAlertController(title: "時間割削除", message: "すべての時間割を削除します", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            delAllSubject()
            updateTimeTable()
            showAlert(type: 1, msg: "")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func getTimeTable(){
        self.navigationController?.pushViewController(SubSettingTimeTable(), animated: true)
    }
    
    func setupVC(){
        self.title = "時間割"
        let table_top = UIView()
        table_top.backgroundColor = Color_Back
        let getFromCloud = UIBarButtonItem(title: nil, style: .plain, target: self, action:  #selector(self.getTimeTable))
        getFromCloud.image = UIImage(named: "nav_cloud")
        let delAllTimeTable = UIBarButtonItem(title: nil, style: .plain, target: self, action:  #selector(self.delAllTimeTable))
        delAllTimeTable.image = UIImage(named: "nav_del")
        self.navigationItem.rightBarButtonItems = [getFromCloud]
        timeTable.delegate = self
        timeTable.dataSource = self
        //timeTable.isScrollEnabled = false
        timeTable.tableHeaderView = table_top
        timeTable.tableFooterView = table_top
        timeTable.separatorInset = UIEdgeInsets.zero
        timeTable.rowHeight = UITableView.automaticDimension
        timeTable.separatorColor = Color_Back
        timeTable.separatorStyle = .singleLine
        timeTable.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        self.view.addSubview(timeTable)
        timeTable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
