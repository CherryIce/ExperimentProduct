//
//  RPLoginViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/11.
//

import UIKit
import RxSwift

class RPLoginViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    var loginView = RPLoginView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        creatRightItem()
        
        loginView = RPLoginView.init(frame: self.view.bounds)
        self.view .addSubview(loginView)
    }
    
    func creatRightItem() {
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.setTitle("密码登录", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        rightBtn.rx.tap.subscribe(onNext:{ [weak self] in
                print("xxxxxxd")
        })
        .disposed(by: disposeBag)
        
        
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
}
