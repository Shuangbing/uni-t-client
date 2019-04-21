//
//  ComaTable.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/27.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit

class ComaTable: UIView{
    
    var weekInt:Int = 1
    var comaInt:Int
    let subject = PaddingLabel(withInsets: 5, 5, 5, 5)
    let classroom = UILabel()
    
    var Subject:String
    var ClassRoom:String
    var bg:Int
    
    required init(subject: String, classroom: String, week: Int, coma: Int, bgColor: Int) {
        self.weekInt = week
        self.comaInt = coma
        self.Subject = "\(subject)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        self.ClassRoom = classroom
        self.bg = bgColor
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        classroom.backgroundColor = .white
        classroom.textColor = Color_Main
        classroom.textAlignment = .center
        classroom.layer.cornerRadius = 3;
        classroom.clipsToBounds = true
        classroom.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize-1)
        classroom.text = ClassRoom
        subject.textColor = .white
        subject.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize)
        subject.numberOfLines = 0
        subject.alpha = 0.6
        subject.lineBreakMode = .byCharWrapping
        subject.layer.cornerRadius = 6;
        subject.clipsToBounds = true
        subject.text = Subject
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if comaNum > 5{
                let smallFont = Int(comaNum-5)
                classroom.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize-CGFloat(smallFont)-1)
                subject.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize-CGFloat(smallFont)-1)
            }
            
            if weekDayNum > 5{
                classroom.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize-3)
                subject.font = UIFont.boldSystemFont(ofSize: UIFont.screenFontSize-2)
            }
        }
        
        if bg == -1{
            subject.backgroundColor = .clear
        }else{
            subject.backgroundColor = SubjectColor[bg]
            if classroom.text == ""{classroom.text = "未設定"}
        }
        
        self.tag = comaInt*100+weekInt
        self.addSubview(subject)
        self.addSubview(classroom)
        subject.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
        
        classroom.snp.makeConstraints { (make) in
            make.height.equalTo(subject).dividedBy(6)
            make.width.equalTo(subject).offset(-10)
            make.centerX.equalTo(subject)
            make.bottom.equalTo(subject).offset(-5)
        }
        
        let shadowPath = UIBezierPath(rect: bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
}

class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
