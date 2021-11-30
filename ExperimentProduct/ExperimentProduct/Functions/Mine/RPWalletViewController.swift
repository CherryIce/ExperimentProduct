//
//  RPWalletViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPWalletViewController: RPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "钱包"
        simpleUI()
    }
    
    func simpleUI() {
        let simpleView = UIView.init()
        simpleView.backgroundColor = .init(hexString: "#FFF3E6").withAlphaComponent(0.4)
        view.addSubview(simpleView)
        simpleView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(160)
        }
        simpleView.layercornerRadius(cornerRadius: 8)
        //收付款码
        let codeBtn = UIButton.init(type: .custom)
        codeBtn.setImage(UIImage.loadImage("qrcode"), for: .normal)
        codeBtn.setTitle("收付款码", for: .normal)
        codeBtn.setTitleColor(.init(hexString: "#18C47C"), for: .normal)
        codeBtn.titleLabel?.font = .systemFont(ofSize: 15)
        codeBtn.addTarget(self, action: #selector(codeClick), for: .touchUpInside)
        simpleView.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.equalTo((SCREEN_WIDTH-32)/2-32)
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }
        codeBtn.layoutButton(style: .Top, imageTitleSpace: 10)
        //余额
        let moneyBtn = UIButton.init(type: .custom)
        moneyBtn.setImage(UIImage.loadImage("balance"), for: .normal)
        moneyBtn.setTitle("余额", for: .normal)
        moneyBtn.titleLabel?.font = .systemFont(ofSize: 15)
        moneyBtn.setTitleColor(RPColor.redWine, for: .normal)
        moneyBtn.addTarget(self, action: #selector(moneyClick), for: .touchUpInside)
        simpleView.addSubview(moneyBtn)
        moneyBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(codeBtn.snp_width)
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }
        moneyBtn.layoutButton(style: .Top, imageTitleSpace: 10)
        //银行卡 这里只是随便给银行卡列表一个入口 就不再增加iOS对于按钮属性的适配了 实际情况按需处理
        let bankCardBtn = UIButton.init(type: .custom)
        bankCardBtn.titleLabel?.font = .systemFont(ofSize: 16)
        bankCardBtn.setTitle("银行卡", for: .normal)
        bankCardBtn.backgroundColor = .init(hexString: "#18C47C")
        bankCardBtn.addTarget(self, action: #selector(bankCardBtnClick), for: .touchUpInside)
        view.addSubview(bankCardBtn)
        bankCardBtn.layercornerRadius(cornerRadius: 5)
        bankCardBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(simpleView.snp_bottom).offset(16)
            make.width.equalTo(simpleView.snp_width)
            make.height.equalTo(40)
        }
        //扫一扫
        let btn = UIButton.init(type: .custom)
        btn.setTitle("☁️", for: .normal)
        btn.frame = CGRect.init(x:0 , y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(scan_scan), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func scan_scan()  {
        let ctl = RPScanViewController.init(cornerColor:nil, scanAnimationImage: nil)
        ctl.delegate = self
        self.present(ctl, animated: true, completion: nil)
    }

    @objc func codeClick()  {
        self.navigationController?.pushViewController(RPRecivePayCodeViewController.init(), animated: true)
    }
    
    @objc func moneyClick()  {
        self.navigationController?.pushViewController(RPYueViewController.init(), animated: true)
    }
    
    @objc func bankCardBtnClick() {
        self.navigationController?.pushViewController(RPBankCardListController.init(), animated: true)
    }
}

extension RPWalletViewController:RPScanViewControllerDelegate {
    func didOutput(_ code: String) {
        log.debug(code)
    }
    
    func didReceiveError(_ error: String) {
        log.debug(error)
    }
}
