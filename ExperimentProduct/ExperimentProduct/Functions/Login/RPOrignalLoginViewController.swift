//
//  RPOrignalLoginViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/14.
//

import UIKit

class RPOrignalLoginViewController: RPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        creatUI()
    }
    
    func creatUI() {
        let titleLabel = UILabel.init()
        titleLabel.text = "密码登录"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.init(hexString: "#2E3135")
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(RPTools.NAV_HEIGHT)
        }
        
        let phoneTextFiled = RPTextFiled.init()
        self.view.addSubview(phoneTextFiled)
        
        phoneTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(48)
            make.height.equalTo(45)
        }
        
        phoneTextFiled.setPlaceholder("请输入手机号码")
        phoneTextFiled.setType(.loginPhone)
        
        let pwTextFiled = RPTextFiled.init()
        self.view.addSubview(pwTextFiled)
        
        pwTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(phoneTextFiled.snp.bottom).offset(23)
            make.height.equalTo(45)
        }
        
        pwTextFiled.setPlaceholder("请输入6-12位密码")
        pwTextFiled.setType(.loginPw)
        
    }

}
