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
            let dict = {[NSAttributedString.Key.foregroundColor:RPColor.MainColor]}()
            let tabBarAppearance = UITabBarAppearance.init()
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = dict
        }
    }
    
    func addAllChildsControllors() {
        
        addOneChildVC(childVC:RPHomeViewController(), title:"首页", imageNormal:UIImage(imageLiteralResourceName:"icon_nor_shouy"), imageSelect: UIImage(named:"icon_pre_shouy"))
        
        addOneChildVC(childVC:RPExploreViewController(), title:"探索", imageNormal:UIImage(imageLiteralResourceName:"icon_nor_find"), imageSelect: UIImage(named:"icon_pre_find"))
        
        addOneChildVC(childVC:RPFindViewController(), title:"发现", imageNormal:UIImage(imageLiteralResourceName:"icon_nor_xiaox"), imageSelect: UIImage(named:"icon_pre_xiaox"))
        
        addOneChildVC(childVC:RPMineViewController(), title:"我的", imageNormal:UIImage(imageLiteralResourceName:"icon_nor_my"), imageSelect: UIImage(named:"icon_pre_my"))
    }
    
    func addOneChildVC(childVC: RPBaseViewController, title: String?, imageNormal: UIImage?, imageSelect:UIImage?) {
        childVC.tabBarItem.title = title
        childVC.title = title
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:RPColor.MainColor], for: .selected)
        childVC.tabBarItem.image = imageNormal?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = imageSelect?.withRenderingMode(.alwaysOriginal)
        let navVC = RPNavigationController(rootViewController: childVC)
        self.addChild(navVC)
    }
}
