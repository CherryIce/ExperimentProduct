//
//  AppDelegate.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = RPMainTabBarViewController.init()
        
        return true
    }
}

