//
//  SubWebUIView.swift
//  unitool
//
//  Created by Shuangbing on 2018/12/07.
//  Copyright © 2018 Shuangbing. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class SubWebUIView: UIViewController, UIWebViewDelegate{
    
    
    var url_string = ""
    let webView = WKWebView()
    
    private lazy var RegisterReturn : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("戻る", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(dissWebUIView), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func dissWebUIView(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        let url = URL(string: self.url_string)!
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
        self.view.addSubview(RegisterReturn)
        RegisterReturn.snp.makeConstraints { (make) in
            make.width.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        webView.snp.makeConstraints { (make) in
            make.top.left.width.right.equalToSuperview()
            make.bottom.equalTo(RegisterReturn.snp.top)
        }
    }
    
    
}
