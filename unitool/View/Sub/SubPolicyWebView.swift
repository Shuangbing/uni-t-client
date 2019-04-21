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

class SubPolicyWebView: UIViewController, UIWebViewDelegate{
    
    
    var url_string = "https://app.uni-t.cc/v1/web/policy"
    let webView = WKWebView()
    
    private lazy var AgreeReturn : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = Color_Sub
        button.setTitle("同意する", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(AgreePolicy), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var disAgreeReturn : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("同意しない", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(disAgreePolicy), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func disAgreePolicy(){
        isAgreePolicy = false
        self.dismiss(animated: true)
    }
    
    @objc func AgreePolicy(){
        isAgreePolicy = true
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.title = "プライバシーポリシー"
        let url = URL(string: self.url_string)!
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
        self.view.addSubview(AgreeReturn)
        self.view.addSubview(disAgreeReturn)
        AgreeReturn.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(2)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        disAgreeReturn.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(2)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        webView.snp.makeConstraints { (make) in
            make.top.left.width.right.equalToSuperview()
            make.bottom.equalTo(AgreeReturn.snp.top)
        }
    }
    
    
}
