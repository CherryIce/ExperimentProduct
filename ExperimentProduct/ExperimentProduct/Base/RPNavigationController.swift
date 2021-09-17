//
//  RPNavigationController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

class RPNavigationController: UINavigationController {

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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
