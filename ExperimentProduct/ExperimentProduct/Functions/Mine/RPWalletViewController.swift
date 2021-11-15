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
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .red
        btn.frame = CGRect.init(x:100 , y: 100, width: 100, height: 100)
        btn.addTarget(self, action: #selector(xxxx), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func xxxx()  {
        let ctl = RPScanViewController.init(cornerColor:nil, scanAnimationImage: nil)
        ctl.delegate = self
        self.present(ctl, animated: true, completion: nil)
    }

}

extension RPWalletViewController:RPScanViewControllerDelegate {
    func didOutput(_ code: String) {
        log.debug(code)
    }
    
    func didReceiveError(_ error: Error) {
        log.debug(error)
    }
}
