//
//  SubEditTimeTable.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/27.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit



class SubEditTimeTable: UIViewController{

    var weekEdit:Int = -1
    var comaEdit:Int = -1
    let mainView = UIView()
    let scrollView = UIScrollView()
    let InputSubject = InputView()
    let InputClassRoom = InputView()
    let InputTeacher = InputView()
    let ButtonColor = InputButton()
    let ButtonEdit = InputButton()
    let ButtonDel = InputButton()
    let ButtonAdd = InputButton()
    
    var subject_find:TimeTable? = TimeTable()
    
    func updateColor(color: Int){
        ButtonColor.tag = color
        ButtonColor.setBackgroundImage(UIImage(color: SubjectColor[ButtonColor.tag]), for: .normal)
        ButtonColor.setBackgroundImage(UIImage(color: SubjectColor[ButtonColor.tag].darkened()), for: .highlighted)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonDel.Color = UIColor.red.lighter()
        setupVC()
        setup_input()
        readTimeTable()
        setup_ColorSelector()
    }
    
    func readTimeTable() {
        subject_find = timetableData.filter("week == \(weekEdit) and coma == \(comaEdit)", "").first ?? nil
        ButtonColor.tag = subject_find?.bgColor ?? 0
        ButtonColor.setBackgroundImage(UIImage(color: SubjectColor[ButtonColor.tag]), for: .normal)
        ButtonColor.setBackgroundImage(UIImage(color: SubjectColor[ButtonColor.tag].darkened()), for: .highlighted)
        ButtonColor.setTitle("背景色", for: .normal)
        ButtonColor.alpha = 0.6
        ButtonColor.addTarget(self, action: #selector(self.selectColorEvent), for: .touchUpInside)
        mainView.addSubview(ButtonColor)
        ButtonColor.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainView)
            make.top.equalTo(InputTeacher.snp.bottom).offset(25)
            make.width.equalTo(InputTeacher)
            make.height.equalTo(InputTeacher)
        }
        if  subject_find != nil{
            InputSubject.Input.text = subject_find?.subject ?? ""
            InputClassRoom.Input.text = subject_find?.classroom ?? ""
            InputTeacher.Input.text = subject_find?.teacher ?? ""
            mainView.addSubview(ButtonEdit)
            mainView.addSubview(ButtonDel)
            
            ButtonEdit.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.top.equalTo(ButtonColor.snp.bottom).offset(25)
                make.width.equalTo(InputSubject).multipliedBy(0.9)
                make.height.equalTo(50)
            }
            
            ButtonDel.snp.makeConstraints { (make) in
                make.centerX.equalTo(ButtonEdit)
                make.top.equalTo(ButtonEdit.snp.bottom).offset(10)
                make.width.height.equalTo(ButtonEdit)
                make.bottom.equalToSuperview()
            }
        }else{
            mainView.addSubview(ButtonAdd)
            ButtonAdd.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.top.equalTo(ButtonColor.snp.bottom).offset(25)
                make.width.equalTo(InputSubject).multipliedBy(0.9)
                make.height.equalTo(50)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    @objc func editThis() {
        let subject = InputSubject.Input.text ?? ""
        let classroom = InputClassRoom.Input.text ?? ""
        let teacher = InputTeacher.Input.text ?? ""
        let sub_data = TimeTable()
        if subject != ""{
            sub_data.week = weekEdit
            sub_data.coma = comaEdit
            sub_data.subject = subject
            sub_data.classroom = classroom
            sub_data.teacher = teacher
            sub_data.bgColor = ButtonColor.tag
            editOneSubject(week: weekEdit, coma: comaEdit, subject: sub_data)
            updateTimeTable()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            showAlert(type: 2, msg: "授業名を入力してください")
        }
    }
    
    @objc func delThis() {
        delectOneSubject(week: weekEdit, coma: comaEdit)
        updateTimeTable()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addThis() {
        let subject = InputSubject.Input.text ?? ""
        let classroom = InputClassRoom.Input.text ?? ""
        let teacher = InputTeacher.Input.text ?? ""
        let sub_data = TimeTable()
        if subject != ""{
            sub_data.week = weekEdit
            sub_data.coma = comaEdit
            sub_data.subject = subject
            sub_data.classroom = classroom
            sub_data.teacher = teacher
            sub_data.bgColor = ButtonColor.tag
            addOneSubject(subject: sub_data)
            updateTimeTable()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            showAlert(type: 2, msg: "授業名を入力してください")
        }
    }
    
    @objc func selectColorEvent(){
        self.navigationController?.pushViewController(SubColorSelector(), animated: true)
    }
    
    func setup_ColorSelector(){
        
        
    }
    
    func setup_input() {
        InputSubject.Lable.text = "授業名"
        InputClassRoom.Lable.text = "教室"
        InputTeacher.Lable.text = "教員"
        
        ButtonAdd.setTitle("追加", for: .normal)
        ButtonEdit.setTitle("編集", for: .normal)
        ButtonDel.setTitle("削除", for: .normal)
        
        
        ButtonEdit.addTarget(self, action: #selector(self.editThis), for: .touchUpInside)
        ButtonDel.addTarget(self, action: #selector(self.delThis), for: .touchUpInside)
        ButtonAdd.addTarget(self, action: #selector(self.addThis), for: .touchUpInside)
        
        ButtonDel.setBackgroundImage(UIImage(color: UIColor.red.lighter()), for: .normal)
        ButtonDel.setBackgroundImage(UIImage(color: UIColor.red.lighter().darkened()), for: .highlighted)
        
        self.mainView.addSubview(InputSubject)
        self.mainView.addSubview(InputClassRoom)
        self.mainView.addSubview(InputTeacher)
        
        
        InputSubject.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainView)
            make.top.equalTo(mainView).offset(30)
            make.width.equalTo(mainView).multipliedBy(0.7)
            make.height.equalTo(50)
        }
        InputClassRoom.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainView)
            make.top.equalTo(InputSubject.snp.bottom).offset(20)
            make.width.height.equalTo(InputSubject)
        }
        InputTeacher.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainView)
            make.top.equalTo(InputClassRoom.snp.bottom).offset(20)
            make.width.height.equalTo(InputSubject)
        }
    }
    
    func setupVC(){
        self.view.backgroundColor = .white
        self.title = "\(weekday[weekEdit]) \(comaEdit)時限"
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        mainView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        mainView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
        }
        
    }
}


