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
    
    //提示语显示
    func viewShowToast(_ tips:String,position:ToastPosition = ToastManager.shared.position) {
        if self.navigationController != nil {
            self.navigationController?.view.hideAllToasts(includeActivity: true, clearQueue: true)
            self.navigationController?.view.makeToast(tips,
                                                      duration: 3.0,
                                                      position: position,
                                                      style: RPTools.RPToastStyle)
        }else{
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
            self.view.makeToast(tips,
                                duration: 3.0,
                                position: position,
                                style: RPTools.RPToastStyle)
        }
    }
    
    func windowShowToast(_ tips:String) {
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: true, clearQueue: true)
        let b = UIButton.init(type: .custom)
        b.frame = CGRect(x: 0, y: 0, width: 270, height: 40)
        b.titleLabel?.font = .systemFont(ofSize: 14)
        b.setTitle(tips, for: .normal)
        b.setTitleColor(.white, for: .normal)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.titleAlignment = .trailing
            configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 16, bottom: 5, trailing: 16)
            b.configuration = configuration
        }else{
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
            b.titleLabel?.textAlignment = .right
        }
        b.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        b.layercornerRadius(cornerRadius: 4)
        b.sizeToFit()
        UIApplication.shared.keyWindow?.showToast(b, point:CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2))
    }
    
    deinit {
        /**
         检查内存泄露：
         
         可选方案1：MLeaksFinder+FBRetainCycleDetector ,
         MLeaksFinder手动导入 or pod 'MLeaksFinder', :git => 'https://github.com/Zepo/MLeaksFinder.git', :configurations => ['Debug']
         pod 'FBRetainCycleDetector', :git => 'https://github.com/facebook/FBRetainCycleDetector.git' ,:branch => 'main', :configurations => ['Debug']
         
         方案2：uber/RIBs内存泄漏工具（LeakDetector.swift）
         */
        log.debug("❤️❤️❤️❤️❤️❤️❤️❤️ \(self.classForCoder)释放了...")
    }
}
