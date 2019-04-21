//
//  HomeScoreVC.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/25.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit
import SwiftyJSON

var scoreData:[JSON] = []

class SubScoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getScoreCell(subject: scoreData[indexPath.row]["subject"].stringValue, score: scoreData[indexPath.row]["score"].stringValue, res: scoreData[indexPath.row]["result"].stringValue)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    let footerView = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func getToTalScore() -> Int {
        var total_score = 0
        
        for score in scoreData{
            if score["result"] != "不可" && score["result"] != "欠席"{
                total_score = total_score + score["score"].intValue
            }
        }
        return total_score
    }
    
    func setupVC(){
        //self.title = "成績照会"
        self.title = "成績照会 (\(getToTalScore()))"
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backMyEvent(_:)))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view)
            make.top.left.equalTo(self.view)
        }
    }
    
    @objc func backMyEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func getScoreCell(subject: String, score: String, res: String) -> UITableViewCell {
        let ResLabel = UILabel()
        let SubjcetLabel = UILabel()
        let ScoreLabel = UILabel()
        ResLabel.text = res
        ResLabel.textAlignment = .center
        ResLabel.layer.cornerRadius = 10
        ResLabel.clipsToBounds = true
        ResLabel.font = UIFont.boldSystemFont(ofSize: 20)
        ResLabel.textColor = .white
        SubjcetLabel.text = subject
        SubjcetLabel.font = UIFont.systemFont(ofSize: 16)
        SubjcetLabel.textColor = Color_Main
        ScoreLabel.text = "単位数 \(score)"
        ScoreLabel.font = UIFont.systemFont(ofSize: 15)
        ScoreLabel.textColor = Color_Main
        if subject.count > 15 {SubjcetLabel.font = UIFont.systemFont(ofSize: 10)}
        switch res {
        case "不可":
            ResLabel.text = "不"
            ResLabel.backgroundColor = .red
        case "欠席":
            ResLabel.text = "欠"
            ResLabel.backgroundColor = .red
        case "":
            ResLabel.text = "-"
            ScoreLabel.text = "単位数 -"
            ResLabel.backgroundColor = Color_Main.lighter()
        default:
            ResLabel.backgroundColor = Color_Sub
        }
        let SubjectICON = UIImageView()
        SubjectICON.image = UIImage(named: "cell_subject")
        let ScoreICON = UIImageView()
        ScoreICON.image = UIImage(named: "cell_score")
        let AttendCell = UITableViewCell()
        AttendCell.backgroundColor = .white
        AttendCell.addSubview(SubjcetLabel)
        AttendCell.addSubview(ScoreLabel)
        AttendCell.addSubview(SubjectICON)
        AttendCell.addSubview(ScoreICON)
        AttendCell.addSubview(ResLabel)
        AttendCell.selectionStyle = .none
        ResLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.centerY.equalTo(AttendCell)
            make.right.equalTo(AttendCell).offset(-25)
        }
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
        ScoreICON.snp.makeConstraints { (make) in
            make.top.equalTo(SubjectICON).offset(25)
            make.left.equalTo(AttendCell).offset(10)
            make.width.height.equalTo(16)
        }
        ScoreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ScoreICON).offset(-1)
            make.left.equalTo(ScoreICON).offset(20)
            make.width.equalTo(AttendCell).offset(-10)
            make.height.equalTo(20)
        }
        return AttendCell
    }
}
