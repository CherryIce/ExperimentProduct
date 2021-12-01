//
//  RPVerificationCodeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/1.
//

import UIKit

class RPVerificationCodeViewController: RPBaseViewController {

    private lazy var codeView: TDWVerifyCodeView = {
        let codeView = TDWVerifyCodeView.init(inputTextNum: 6)
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
            log.debug("inputing code \(String(describing: self?.classForCoder)) ...")
        }
        
        // 监听验证码输入完成
        codeView.inputFinish = { [weak self] (str) in
            log.debug("finished input code \(String(describing: self?.classForCoder)) ...")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
