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
        
//        self.tabBar.tintColor = UIColor.init(hexString: "#13227a")
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .lightGray
        }
        
        // ios15
        if #available(iOS 15.0, *) {
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.init(hexString: "#13227a")]
            
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.backgroundEffect = nil
            appearance.shadowColor = .clear
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }else{
            //隐藏tabbar上面的黑线
            tabBar.backgroundImage = UIImage(color: .white)
            tabBar.shadowImage = UIImage.init()
            tabBar.isTranslucent = false
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
