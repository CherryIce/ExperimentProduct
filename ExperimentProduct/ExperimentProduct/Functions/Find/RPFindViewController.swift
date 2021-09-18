//
//  RPFindViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

class RPFindViewController: RPBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let num =  arc4random() % 20
        if num % 2 == 0 {
            self.tabBarItem.badgeValue = "\(num)"
        }else {
            self.tabBarItem.badgeValue = nil
        }
        
        //创建头部视图
        creatNav()
    }
    
    func creatNav(){
        var titleView = UIView()
        titleView = UIView.init()
        titleView.backgroundColor = .white
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(RPTools.NAV_HEIGHT)
        }
        
        var titleLab = UILabel()
        titleLab = UILabel.init()
        titleLab.text = "发现"
        titleLab.font = UIFont.boldSystemFont(ofSize: 24)
        titleView .addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    // 隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 显示导航栏
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
