//
//  RPNavigationController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

class RPNavigationController: UINavigationController ,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //返回手势
        let isTrue = self.responds(to:#selector(getter: interactivePopGestureRecognizer))
        if isTrue{
            self.interactivePopGestureRecognizer?.isEnabled = self.viewControllers.count>1;
        }
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
            var backImg = RPImage.NavBackImage
            if viewController is RPLookPictureViewController {
                backImg = RPTools.getPngImage(forResource: "back_white@2x")
            }
            //添加图片
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: backImg.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(leftClick))
            //        //添加文字
            //        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(leftClick))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        let hiddenVcs = ["RPHomeViewController","RPFindViewController","RPMineViewController","RPScanViewController"]
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
