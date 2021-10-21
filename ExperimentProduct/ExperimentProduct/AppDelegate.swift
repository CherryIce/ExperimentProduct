//
//  AppDelegate.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import IQKeyboardManagerSwift
import TABAnimated

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        thirdInstall()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        jungleEnter()
        return true
    }
    
    func jungleEnter() {
        let lastVersion = UserDefaults.standard.string(forKey: kLastVersionKey)
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if lastVersion != currentVersion {
            window?.rootViewController = RPGuideViewController.init()
        }else{
            setMainRoot()
        }
    }
    
    func setMainRoot() {
        let token = UserDefaults.standard.object(forKey: kTokenExpDateTime)
        if (token != nil) {
            window?.rootViewController = RPMainTabBarViewController.init()
        }else{
            window?.rootViewController = RPNavigationController.init(rootViewController: RPLoginViewController.init())
        }
    }
}

extension AppDelegate {
    
    func thirdInstall() {
        IQKeyboardManager.shared.enable = true
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        
        // 初始化TABAnimated，并设置TABAnimated相关属性
        TABAnimated.shared()?.initWithShimmerAnimated()
        // 开启日志
        TABAnimated.shared()?.openLog = false
        // 是否开启动画坐标标记，如果开启，也仅在debug环境下有效。
        // 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
        TABAnimated.shared()?.openAnimationTag = false
    }
}

