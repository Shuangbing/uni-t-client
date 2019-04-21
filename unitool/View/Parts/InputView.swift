//
//  Parts.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/19.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit
import SnapKit
import ViewAnimator

class InputView: UIView, UITextFieldDelegate{
    
    let Lable = UILabel()
    let Input = UITextField()
    let Line = UIProgressView()
    var Edit = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    //common func to init our view
    private func setupView() {
        backgroundColor = .white
        self.addSubview(Lable)
        self.addSubview(Input)
        self.addSubview(Line)
        Lable.textColor = Color_Main
        Lable.font = UIFont.systemFont(ofSize: 13)
        Lable.textAlignment = .left
        Input.delegate = self
        Input.textColor = Color_Sub
        Input.font = UIFont.systemFont(ofSize: 17)
        Input.autocapitalizationType = .none
        Line.progress = 0
        Line.trackTintColor = Color_Back
        Line.progressTintColor = Color_Sub
        Lable.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(14)
        })
        Input.snp.makeConstraints { (make) in
            make.top.equalTo(Lable.snp.bottom).offset(6.5)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(20)
        }
        Line.snp.makeConstraints { (make) in
            make.top.equalTo(Input.snp.bottom).offset(6.5)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(1.3)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        Line.progress = 1
        return Edit
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        Line.progress = 0
        return true
    }
    
}
