//
//  AppDelegate.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        
        let token = UserDefaults.standard.object(forKey: "token")
        if (token != nil) {
            window?.rootViewController = RPMainTabBarViewController.init()
        }else{
            window?.rootViewController = RPNavigationController.init(rootViewController: RPLoginViewController.init())
        }
        
        return true
    }
}

