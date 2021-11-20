//
//  RPWithdrawalViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/17.
//

import UIKit

class RPWithdrawalViewController: RPBaseViewController {

    lazy var actLabel = UILabel()
    lazy var bankIconV = UIImageView()
    lazy var bankLabel = UILabel()
    lazy var rateLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "提现"
        //简单又不怎么改动的界面建议用xib画
        simpleUI()
    }

    func simpleUI()  {
        //账户可用余额
        let actV = UIView.init()
        actV.backgroundColor = .white
        view.addSubview(actV)
        actV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(50)
        }
        
        let actTitleLabel = UILabel.init()
        actTitleLabel.text = "账户余额"
        actTitleLabel.font = .systemFont(ofSize: 14)
        actTitleLabel.textColor = .init(hexString: "#2E3135")
        actV.addSubview(actTitleLabel)
        actTitleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        actLabel = UILabel.init()
        actLabel.text = "0.00"
        actLabel.font = .boldSystemFont(ofSize: 20)
        actLabel.textColor = .init(hexString: "#2E3135")
        actV.addSubview(actLabel)
        actLabel.snp.makeConstraints { make in
            make.left.equalTo(actTitleLabel.snp_right).offset(20)
            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-16)
        }
        
        //银行卡
        let bankV = UIView.init()
        bankV.backgroundColor = .white
        view.addSubview(bankV)
        bankV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(actV.snp_bottom).offset(10)
            make.height.equalTo(68)
        }
        
        bankIconV = UIImageView.init()
        bankIconV.backgroundColor = .brown
        bankV.addSubview(bankIconV)
        bankIconV.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        bankLabel = UILabel.init()
        bankLabel.font = .systemFont(ofSize: 16)
        bankLabel.text = "中国建设银行(9089)"
        bankV.addSubview(bankLabel)
        bankLabel.snp.makeConstraints { make in
            make.left.equalTo(bankIconV.snp_right).offset(6)
            make.top.equalTo(12)
            make.height.equalTo(22)
        }
        
        let tipsLabel = UILabel.init()
        tipsLabel.textColor = .init(hexString: "#999999")
        tipsLabel.font = .systemFont(ofSize: 12)
        tipsLabel.text = "预计24小时内到账"
        bankV.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(bankLabel.snp_left)
            make.top.equalTo(bankLabel.snp_bottom).offset(5)
            make.height.equalTo(17)
        }
        
        let arrowLabel = UILabel.init()
        arrowLabel.textColor = .init(hexString: "#999999")
        arrowLabel.font = .systemFont(ofSize: 12)
        arrowLabel.text = ">"
        bankV.addSubview(arrowLabel)
        arrowLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        //提现金额
        let withdrawal = UIView.init()
        withdrawal.backgroundColor = .white
        view.addSubview(withdrawal)
        withdrawal.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bankV.snp_bottom).offset(10)
            make.height.equalTo(128)
        }
        
        let withdrawalLabel = UILabel.init()
        withdrawalLabel.text = "提现金额"
        withdrawalLabel.font = .systemFont(ofSize: 14)
        withdrawalLabel.textColor = .init(hexString: "#2E3135")
        withdrawal.addSubview(withdrawalLabel)
        withdrawalLabel.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.height.equalTo(20)
        }
        
        let unitLabel = UILabel.init()
        unitLabel.textColor = .init(hexString: "#2E3135")
        unitLabel.font = .boldSystemFont(ofSize: 24)
        unitLabel.text = "￥"
        withdrawal.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(withdrawalLabel.snp_bottom).offset(10)
            make.width.equalTo(24)
            make.height.equalTo(33)
        }
        
        let withdrawalTextfield = UITextField.init()
        withdrawalTextfield.placeholder = "please input"
        withdrawalTextfield.textColor = .init(hexString: "#2E3135")
        withdrawalTextfield.font = .boldSystemFont(ofSize: 24)
        withdrawal.addSubview(withdrawalTextfield)
        withdrawalTextfield.snp.makeConstraints { make in
            make.left.equalTo(unitLabel.snp_right).offset(10)
            make.top.equalTo(unitLabel.snp_top)
            make.height.equalTo(unitLabel.snp_height)
            make.right.equalToSuperview().offset(-16)
        }
        
        let lineView = UIView.init()
        lineView.backgroundColor = .init(hexString: "#F3F3F5")
        withdrawal.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(unitLabel.snp_bottom).offset(4)
            make.height.equalTo(0.5)
        }
        
        let rateTitleLabel = UILabel.init()
        rateTitleLabel.textColor = .init(hexString: "#2E3135")
        rateTitleLabel.font = .systemFont(ofSize: 14)
        rateTitleLabel.text = "手续费："
        withdrawal.addSubview(rateTitleLabel)
        rateTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(lineView.snp_bottom).offset(11)
            make.height.equalTo(20)
        }
        
        rateLabel = UILabel.init()
        rateLabel.textColor = RPColor.redWine
        rateLabel.font = .systemFont(ofSize: 14)
        rateLabel.text = "0.00"
        withdrawal.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.left.equalTo(rateTitleLabel.snp_right).offset(10)
            make.top.equalTo(rateTitleLabel.snp_top)
            make.height.equalTo(20)
        }
        
        //提现按钮
        let  withdrawalBtn = UIButton.init(type: .custom)
        withdrawalBtn.setTitle("确定提现", for: .normal)
        withdrawalBtn.titleLabel?.font = .systemFont(ofSize: 16)
        withdrawalBtn.backgroundColor = RPColor.redWine
        view.addSubview(withdrawalBtn)
        withdrawalBtn.snp.makeConstraints { make in
            make.top.equalTo(withdrawal.snp_bottom).offset(30)
            make.left.equalTo(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(45)
        }
        withdrawalBtn.layercornerRadius(cornerRadius: 6)
        withdrawalBtn.addTarget(self, action: #selector(withdrawalBtnClick), for: .touchUpInside)
    }
    
    @objc func withdrawalBtnClick() {
        
    }
}
