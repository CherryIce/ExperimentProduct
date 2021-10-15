//
//  RPLoginViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/11.
//

import UIKit
import RxSwift
import ActiveLabel

class RPLoginViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        creatRightItem()
        setUI()
    }
    
    func creatRightItem() {
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("密码登录", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        rightBtn.rx.tap.subscribe(onNext:{ event in
            self.navigationController?.pushViewController(RPOrignalLoginViewController.init(), animated: true)
        })
        .disposed(by: disposeBag)
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func setUI() {
        let textField = RPTextFiled.init()
        self.view.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.centerY.equalToSuperview().offset(-40)
            make.height.equalTo(45)
        }
        
        textField.placeholder("请输入手机号码")
        textField.type = .loginPhone
        
        let logoView = UIImageView.init(image: RPImage.init(color: RPColor.init(hexString:"#FFF3E6"))?.roundedCornerImageWithCornerRadius(4))
        self.view.addSubview(logoView)
        
        logoView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(textField.snp_top).offset(-80)
        }
        
        let titleLabel = UILabel.init()
        titleLabel.text = "欢迎来到阴间论坛"
        titleLabel.textColor = UIColor.init(hexString: "#2E3135")
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(logoView.snp.bottom).offset(15)
        }
        
        let verifyButton = UIButton.init(type: .custom)
        verifyButton.setTitle("获取验证码", for: .normal)
        verifyButton.backgroundColor = RPColor.MainColor
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        verifyButton.layercornerRadius(cornerRadius: 8)
        self.view.addSubview(verifyButton)
        
        verifyButton.rx.tap.subscribe(onNext:{ event in
            print("获取验证码")
        })
        .disposed(by: disposeBag)
        
        verifyButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.greaterThanOrEqualTo(textField.snp_bottom).offset(30)
            make.height.equalTo(47)
        }
        
        let protocolLabel = ActiveLabel()
        let customType = ActiveType.custom(pattern: "\\《阴间论坛用户使用协议》")
        protocolLabel.enabledTypes = [customType]
        protocolLabel.numberOfLines = 2
        protocolLabel.text = "点击注册按钮，即表示您同意《阴间论坛用户使用协议》"
        protocolLabel.font = UIFont.systemFont(ofSize: 14)
        protocolLabel.customColor[customType] = RPColor.MainColor
        protocolLabel.textColor = UIColor.black
        protocolLabel.handleCustomTap(for: customType, handler: { (customType) in
            print("《阴间论坛用户使用协议》")
        })
        self.view.addSubview(protocolLabel)
        
        protocolLabel.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(self.view.snp_bottom).offset(-40)
        }
        
    }
}
