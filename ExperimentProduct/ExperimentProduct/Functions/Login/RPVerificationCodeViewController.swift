//
//  RPVerificationCodeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/1.
//

import UIKit

class RPVerificationCodeViewController: RPBaseViewController {

    private lazy var codeView: TDWVerifyCodeView = {
        let codeView = TDWVerifyCodeView.init(inputTextNum: 6,padding: 32)
        self.view.addSubview(codeView)
        return codeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        simpleUI()
    }
    
    func simpleUI()  {
        let titleLabel = UILabel.init()
        titleLabel.text = "验证码登录"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.init(hexString: "#2E3135")
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(RPTools.NAV_HEIGHT)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp_bottom).offset(48)
            make.height.equalTo(35)
        }
        codeView.textFiled.becomeFirstResponder()
        
        // 监听验证码输入的过程
        codeView.textValueChange = {[weak self] (str) in
            // 要做的事情
            log.debug("inputing code \(String(describing: self?.classForCoder))"+str)
        }
        
        // 监听验证码输入完成
        codeView.inputFinish = { [weak self] (str) in
            log.debug("inputing code \(String(describing: self?.classForCoder)) ...")
            let value1 = str.md5
            let value2 = str + value1
            let value3 = value2.md5
            UserDefaults.standard.setValue(value3, forKey: kTokenExpDateTime)
            UserDefaults.standard.synchronize()
            var window = UIApplication.shared.keyWindow
            if #available(iOS 13.0, *) {
                window = UIApplication.shared.windows.first
            }
            window?.rootViewController = RPMainTabBarViewController.init()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
