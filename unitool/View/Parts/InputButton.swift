//
//  InputButton.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/25.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit

class InputButton: UIButton{
    
    var Color:UIColor = Color_Sub
    
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
        titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        setBackgroundImage(UIImage(color: Color), for: .normal)
        setBackgroundImage(UIImage(color: Color.darkened()), for: .highlighted)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)

    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
