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
        addAllChildsControllors()
        
//        self.tabBar.tintColor = UIColor.init(hexString: "#13227a")
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .lightGray
        }
        
        // ios15
        if #available(iOS 15.0, *) {
//            let itemAppearance = UITabBarItemAppearance()
//            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
            //UIColor.init(hexString: "#13227a")
//            itemAppearance.selected.titleTextAttributes = [.foregroundColor:RPColor.redWine]
            
            let appearance = UITabBarAppearance()
//            appearance.stackedLayoutAppearance = itemAppearance
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
        let titles = ["动态","通讯录","话题","我"]
        let tabbarItems = RPTabBar.init(titles)
        tabbarItems.frame = tabBar.bounds
        tabbarItems.delegate = self
        tabBar.addSubview(tabbarItems)
        
        addOneChildVC(childVC:RPHomeViewController(),title:"动态",imageName: "home")
        
        addOneChildVC(childVC:RPExploreViewController(),title:"通讯录",imageName: "friend")
        
        addOneChildVC(childVC:RPFindViewController(), title:"话题", imageName: "topic")
        
        addOneChildVC(childVC:RPMineViewController(), title:"我", imageName: "me")
    }
    
    func addOneChildVC(childVC: RPBaseViewController, title: String?, imageName: String) {
//        childVC.tabBarItem.title = title
        childVC.title = title
//        UIColor.init(hexString: "#13227a")
//        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:RPColor.redWine], for: .selected)
//        childVC.tabBarItem.image = RPTools.getPngImage(forResource:imageName+"_nor@2x").withRenderingMode(.alwaysOriginal)
//        childVC.tabBarItem.selectedImage = RPTools.getPngImage(forResource:imageName+"_selected@2x").withRenderingMode(.alwaysOriginal)
        let navVC = RPNavigationController(rootViewController: childVC)
        self.addChild(navVC)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for tabBarItem in self.tabBar.subviews {
            if !(tabBarItem is RPTabBar) {
                tabBarItem.removeFromSuperview()
            }
        }
    }
    
    deinit {
        log.debug("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
    }
}

extension RPMainTabBarViewController : RPTabBarwEventDelegate {
    func clickTabBarEventCallBack(_ index: Int) {
        self.selectedIndex = index
    }
}
