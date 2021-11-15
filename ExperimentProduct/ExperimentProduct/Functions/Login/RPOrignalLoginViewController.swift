//
//  RPOrignalLoginViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/14.
//

import UIKit
import RxSwift

class RPOrignalLoginViewController: RPBaseViewController {
    
    var loginButton = UIButton()
    var phoneTextFiled = RPTextFiled()
    var pwTextFiled = RPTextFiled()
    var phoneStr = String()
    var pwStr = String()
    var forgetButton = UIButton()

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
        
        phoneTextFiled = RPTextFiled.init()
        self.view.addSubview(phoneTextFiled)
        
        phoneTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(48)
            make.height.equalTo(45)
        }
        
        phoneTextFiled.placeholder("请输入手机号码")
        phoneTextFiled.type = .loginPhone
        
        pwTextFiled = RPTextFiled.init()
        self.view.addSubview(pwTextFiled)
        
        pwTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(phoneTextFiled.snp.bottom).offset(23)
            make.height.equalTo(45)
        }
        
        pwTextFiled.placeholder("请输入6-12位密码")
        pwTextFiled.type = .loginPw
        
        forgetButton = UIButton.init(type: .custom)
        forgetButton.setTitle("忘记密码", for: .normal)
        forgetButton.setTitleColor(UIColor.init(hexString: "#666666"), for: .normal)
        forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(forgetButton)
        
        forgetButton.addTarget(self, action: #selector(forgetButtonClick), for: .touchUpInside)
        
        forgetButton.snp.makeConstraints { (make) in
            make.right.equalTo(pwTextFiled.snp_right)
            make.top.greaterThanOrEqualTo(pwTextFiled.snp_bottom).offset(10)
            make.height.equalTo(30)
        }
        
        loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = UIColor.init(hexString: "#E5E5E5")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.layercornerRadius(cornerRadius: 8)
        self.view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.greaterThanOrEqualTo(forgetButton.snp_bottom).offset(20)
            make.height.equalTo(47)
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        
        phoneTextFiled.callBackFunction {[weak self] (textFiled) in
            self?.phoneStr = textFiled.text ?? ""
            self?.buttonEnableJungle()
        }
        pwTextFiled.callBackFunction {[weak self] (textFiled) in
            self?.pwStr = textFiled.text ?? ""
            self?.buttonEnableJungle()
        }
    }

    func buttonEnableJungle() {
        if (self.phoneStr.count == 11 && (self.pwStr.count <= 12 && self.pwStr.count >= 6)) {
            loginButton.backgroundColor = RPColor.MainColor
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = UIColor.init(hexString: "#E5E5E5")
            loginButton.isEnabled = false
        }
    }
    
    @objc func loginButtonClick() {
        self.view.endEditing(true)
        //瞎搞
        let value1 = pwStr.md5
        let value2 = phoneStr + value1
        let value3 = value2.md5
        UserDefaults.standard.setValue(value3, forKey: kTokenExpDateTime)
        UserDefaults.standard.synchronize()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = RPMainTabBarViewController.init()
    }
    
    @objc func forgetButtonClick() {
        let ctl = RPPasswordViewController.init()
        ctl.type = .change
        self.navigationController?.pushViewController(ctl, animated: true)
    }
}
