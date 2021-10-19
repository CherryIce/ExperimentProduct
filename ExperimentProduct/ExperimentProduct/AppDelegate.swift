//
//  AppDelegate.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        
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

