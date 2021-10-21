//
//  RPMainTabBarViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

class RPMainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChildsControllors();
        
        //隐藏tabbar上面的黑线
        self.tabBar.backgroundImage = UIImage(color: .white)
        self.tabBar.shadowImage = UIImage.init()
        self.tabBar.isTranslucent = false
        if #available(iOS 13.0, *) {
            let dict = {[NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#13227a")]}()
            let tabBarAppearance = UITabBarAppearance.init()
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = dict
        }
    }
    
    func addAllChildsControllors() {
        
        addOneChildVC(childVC:RPHomeViewController(),title:"首页",imageName: "home")
        
        addOneChildVC(childVC:RPExploreViewController(),title:"通讯录",imageName: "friend")
        
        addOneChildVC(childVC:RPFindViewController(), title:"发现", imageName: "find")
        
        addOneChildVC(childVC:RPMineViewController(), title:"我", imageName: "mine")
    }
    
    func addOneChildVC(childVC: RPBaseViewController, title: String?, imageName: String) {
        childVC.tabBarItem.title = title
        childVC.title = title
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#13227a")], for: .selected)
        childVC.tabBarItem.image = RPTools.getPngImage(forResource:imageName+"_nor@2x").withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = RPTools.getPngImage(forResource:imageName+"_selected@2x").withRenderingMode(.alwaysOriginal)
        let navVC = RPNavigationController(rootViewController: childVC)
        self.addChild(navVC)
    }
}
