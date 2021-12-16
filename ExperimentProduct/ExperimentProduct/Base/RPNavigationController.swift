//
//  RPNavigationController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

class RPNavigationController: UINavigationController ,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //返回手势
        self.interactivePopGestureRecognizer?.delegate = self
        //导航栏背景
        self.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        //去线
        self.navigationBar.shadowImage = UIImage.init()
        //字体颜色
        let dict = {[NSAttributedString.Key.foregroundColor:RPColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]}()
        self.navigationBar.titleTextAttributes = dict
        //        self.navigationBar.barStyle = .black
        self.delegate = self
        
        // ios15 导航栏变黑
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = UIColor.clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().tintColor = .white
        }
    }
    
    // 重写此方法让 preferredStatusBarStyle 响应
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            //添加图片
            let x = UIBarButtonItem.init(image: RPImage.NavBackImage/*.withRenderingMode(.alwaysOriginal)*/, style: .plain, target: self, action: #selector(leftClick))
            if viewController is RPLookPictureViewController {
               x.tintColor = .white
            }else{
                x.tintColor = .black
            }
            viewController.navigationItem.leftBarButtonItem = x
            self.interactivePopGestureRecognizer?.isEnabled = true //self.viewControllers.count>1;
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        let hiddenVcs = ["RPHomeViewController","RPFindViewController","RPMineViewController","RPScanViewController","RPHotSearchViewController"]
        let identifier = NSStringFromClass(type(of: viewController)).components(separatedBy: ".").last ?? ""
        if hiddenVcs.contains(identifier) {
            navigationController.setNavigationBarHidden(true, animated: true)
        }else{
            if navigationController is UIImagePickerController {
                return
            }
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @objc func leftClick() {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.popViewController(animated: true)
        }
    }
}
