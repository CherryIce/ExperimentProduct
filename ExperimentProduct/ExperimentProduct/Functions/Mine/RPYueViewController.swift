//
//  RPYueViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/17.
//

import UIKit

class RPYueViewController: RPBaseViewController {
    //一切从简 🌫
    private lazy var balanceBtn = UIButton()
    private lazy var incomeBtn = UIButton()
    private lazy var spendBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的余额"
        simpleUI()
    }
    
    func simpleUI() {
        //提现
        let withdrawal = UIButton.init(type: .custom)
        withdrawal.titleLabel?.font = .systemFont(ofSize: 15)
        withdrawal.setTitle("提现", for: .normal)
        withdrawal.setTitleColor(RPColor.redWine, for: .normal)
        withdrawal.frame = CGRect(x:0 , y: 0, width: 40, height: 30)
        withdrawal.addTarget(self, action: #selector(withdrawalClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: withdrawal)
        
        let scrollView = UIScrollView.init()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:SCREEN_HEIGHT-RPTools.NAV_HEIGHT)
        
        let topV = UIView.init()
        topV.frame = CGRect(x: 20, y: 20, width: SCREEN_WIDTH - 40, height: 162)
        topV.backgroundColor = RPColor.redWine
        topV.layercornerRadius(cornerRadius: 8)
        scrollView.addSubview(topV)
        
        let eyeBtn = UIButton.init(type: .custom)
        eyeBtn.frame = CGRect(x: topV.frame.width - 30 - 16, y: 10, width: 30, height: 30)
        eyeBtn.setImage(UIImage(named: "eye"), for: .normal)
        eyeBtn.setImage(UIImage(named: "eye_hide"), for: .selected)
        eyeBtn.addTarget(self, action: #selector(showHideBill), for: .touchUpInside)
        topV.addSubview(eyeBtn)
        
        let balanceTitleLabel = UILabel.init()
        balanceTitleLabel.frame = CGRect(x: 50, y: 16, width: topV.frame.width - 100, height: 20)
        balanceTitleLabel.font = .systemFont(ofSize: 13)
        balanceTitleLabel.text = "账户余额(元)"
        balanceTitleLabel.textAlignment = .center
        balanceTitleLabel.textColor = .white
        topV.addSubview(balanceTitleLabel)
        
        balanceBtn = UIButton.init(type: .custom)
        balanceBtn.frame = CGRect(x:50, y: balanceTitleLabel.frame.maxY+5, width: balanceTitleLabel.frame.width, height: 35)
        balanceBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        balanceBtn.setTitle("0.00", for: .normal)
        balanceBtn.addTarget(self, action: #selector(balanceBtnClick), for: .touchUpInside)
        topV.addSubview(balanceBtn)
        
        let incomeLabel = UILabel.init()
        incomeLabel.frame = CGRect(x: 16, y: balanceBtn.frame.maxY + 16, width: topV.frame.width/2 - 32, height: 20)
        incomeLabel.font = .systemFont(ofSize: 13)
        incomeLabel.textAlignment = .center
        incomeLabel.text = "累计收益(元)"
        incomeLabel.textColor = .white
        topV.addSubview(incomeLabel)
        
        incomeBtn = UIButton.init(type: .custom)
        incomeBtn.frame = CGRect(x: 16, y: incomeLabel.frame.maxY + 5, width: incomeLabel.frame.width, height: 35)
        incomeBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        incomeBtn.setTitle("0.00", for: .normal)
        incomeBtn.tag = 0
        incomeBtn.addTarget(self, action: #selector(gotoBill), for: .touchUpInside)
        topV.addSubview(incomeBtn)
        
        let spendLabel = UILabel.init()
        spendLabel.frame = CGRect(x: topV.frame.width/2 + 16, y: incomeLabel.frame.minY, width: topV.frame.width/2 - 32, height: 20)
        spendLabel.textAlignment = .center
        spendLabel.font = .systemFont(ofSize: 13)
        spendLabel.text = "累计支出(元)"
        spendLabel.textColor = .white
        topV.addSubview(spendLabel)
        
        spendBtn = UIButton.init(type: .custom)
        spendBtn.frame = CGRect(x: spendLabel.frame.minX, y: spendLabel.frame.maxY+5, width: spendLabel.frame.width, height: 35)
        spendBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        spendBtn.setTitle("0.00", for: .normal)
        spendBtn.tag = 1
        spendBtn.addTarget(self, action: #selector(gotoBill), for: .touchUpInside)
        topV.addSubview(spendBtn)
        
        //收益表 - 收益详情 可切换
        //支出表 - 支出详情 可切换
    }

    @objc func withdrawalClick() {
        self.navigationController?.pushViewController(RPWithdrawalViewController.init(), animated: true)
    }
    
    @objc func balanceBtnClick() {
       //...
    }
    
    @objc func showHideBill(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        balanceBtn.setTitle(sender.isSelected ? "***" : "0.00", for: .normal)
        incomeBtn.setTitle(sender.isSelected ? "***" : "0.00", for: .normal)
        spendBtn.setTitle(sender.isSelected ? "***" : "0.00", for: .normal)
    }
    
    @objc func gotoBill(_ sender:UIButton) {
        let bill = RPBillViewController.init()
        bill.cIndex = sender.tag
        self.navigationController?.pushViewController(bill, animated: true)
    }
}
