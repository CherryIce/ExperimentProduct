//
//  RPPagerViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/18.
//

import UIKit
import TYPagerController

class RPPagerViewController: RPBaseViewController {
    
    lazy var tabBar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    
    lazy var datas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "分页控制器"
        self.addTabPagerBar()
        self.addPagerController()
        
        self.loadData()
    }
    
    func addTabPagerBar() {
        self.tabBar.delegate = self
        self.tabBar.dataSource = self
        self.tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: 14)
        self.tabBar.layout.selectedTextFont = UIFont.boldSystemFont(ofSize: 14)
        self.tabBar.layout.normalTextColor = RPColor.lightGray
        self.tabBar.layout.selectedTextColor = RPColor.MainColor
        self.tabBar.layout.progressColor = RPColor.MainColor
        self.tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.view.addSubview(self.tabBar)
        self.tabBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func addPagerController() {
        self.pagerController.dataSource = self
        self.pagerController.delegate = self
        self.addChild(self.pagerController)
        self.view.addSubview(self.pagerController.view)
        self.pagerController.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.tabBar.snp_bottom)
        }
    }
    
    func loadData() {
        var i = 0
        while i < 20 {
            self.datas.append("Tab \(i)")
            i += 1
        }
        self.reloadData()
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RPPagerViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        cell.titleLabel.text = self.datas[index]
        return cell
    }
    
    func numberOfItemsInPagerTabBar() -> Int {
        return self.datas.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = self.datas[index]
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
    }
}

extension RPPagerViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.datas.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 1)
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
