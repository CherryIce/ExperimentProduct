//
//  RPBaseViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import SnapKit

class RPBaseViewController: UIViewController {
    
    var isFirst: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the vie
        self.view.backgroundColor = RPColor.MainViewBgColor
        self.automaticallyAdjustsScrollViewInsets = false
        //解决往上偏移导航栏高度问题
        self.extendedLayoutIncludesOpaqueBars = true
        self .edgesForExtendedLayout = UIRectEdge . init (rawValue: 0 )
        //防止以上方法导致需要透明的导航栏变黑
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        //iOS 11以上需要...
        if #available(iOS 11.0, *) {
            
        }
        
    }
}
