//
//  RPLoginViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/11.
//

import UIKit
import RxSwift
import ActiveLabel
import Then

class RPLoginViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    private var verifyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        creatRightItem()
        setUI()
    }
    
    func creatRightItem() {
        let rightBtn = UIButton.init(type: .custom).then {
            $0.setTitle("密码登录", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        }
        rightBtn.rx.tap.subscribe(onNext:{ [weak self] (event) in
            self?.navigationController?.pushViewController(RPOrignalLoginViewController.init(), animated: true)
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
        
        textField.callBackFunction { [weak self] (tf) in
            if (tf.text?.count == 11) {
                self?.verifyButton.backgroundColor = RPColor.MainColor
                self?.verifyButton.isEnabled = true
            }else{
                self?.verifyButton.backgroundColor = UIColor.init(hexString: "#E5E5E5")
                self?.verifyButton.isEnabled = false
            }
        }
        
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
        
        verifyButton = UIButton.init(type: .custom).then {
            $0.setTitle("获取验证码", for: .normal)
            $0.backgroundColor = UIColor.init(hexString: "#E5E5E5")
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.layercornerRadius(cornerRadius: 8)
            $0.isEnabled = false
        }
        self.view.addSubview(verifyButton)
        
        verifyButton.rx.tap.subscribe(onNext:{ [weak self] (event) in
            self?.navigationController?.pushViewController(RPVerificationCodeViewController.init(), animated: true)
        })
        .disposed(by: disposeBag)
        
        verifyButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.greaterThanOrEqualTo(textField.snp_bottom).offset(30)
            make.height.equalTo(47)
        }
        
        let customType = ActiveType.custom(pattern: "\\《阴间论坛用户使用协议》")
        let protocolLabel = ActiveLabel().then {
            $0.enabledTypes = [customType]
            $0.numberOfLines = 2
            $0.text = "点击注册按钮，即表示您同意《阴间论坛用户使用协议》"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.customColor[customType] = RPColor.MainColor
            $0.textColor = UIColor.black
        }
        protocolLabel.handleCustomTap(for: customType, handler: { [weak self] (customType) in
            let ctl = RPWkwebViewController.init()
            ctl.urlString = "https://www.baidu.com"
            self?.navigationController?.pushViewController(ctl, animated: true)
        })
        self.view.addSubview(protocolLabel)
        
        protocolLabel.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(self.view.snp_bottom).offset(-40)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
