//
//  SubColorSelector.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/29.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UIKit

class SubColorSelector: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubjectColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let color_view = UIView()
        let color = UITableViewCell()
        color.backgroundColor = .white
        color_view.backgroundColor = SubjectColor[indexPath.row]
        color_view.alpha = 0.6
        color.addSubview(color_view)
        color_view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return color
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let view2 = self.navigationController?.viewControllers[1] as!  SubEditTimeTable
        view2.updateColor(color: indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    let footerView = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.title = "背景色"
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
