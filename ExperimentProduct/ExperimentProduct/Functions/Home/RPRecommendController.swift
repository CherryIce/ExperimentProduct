//
//  RPRecommendController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit
import TYPagerController

class RPRecommendController: RPBaseViewController {
    private lazy var tabBar = TYTabPagerBar()
    private lazy var pagerController = TYPagerController()
    private lazy var titlesArray = [String]()
    private lazy var controllersArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabPagerBar()
        addPagerController()
        loadData()
    }
    
    func addTabPagerBar() {
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        tabBar.layout.cellEdging = 10
        tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: 14)
        tabBar.layout.selectedTextFont = UIFont.boldSystemFont(ofSize: 14)
        tabBar.layout.normalTextColor = .lightGray
        tabBar.layout.selectedTextColor = .black
        tabBar.layout.barStyle = .noneView
        tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func addPagerController() {
        pagerController.dataSource = self
        pagerController.delegate = self
        addChild(pagerController)
        view.addSubview(pagerController.view)
        pagerController.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tabBar.snp_bottom)
        }
    }
    
    func loadData() {
        titlesArray = ["推荐","穿搭","摄影","直播","Vlog"]
        
        var i = 0
        while i < titlesArray.count {
            let vc = RPRecommendListViewController.init()
            self.controllersArray.add(vc)
            i += 1
        }
        reloadData()
    }
    
    func reloadData() {
        tabBar.reloadData()
        pagerController.reloadData()
    }
}

extension RPRecommendController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        cell.titleLabel.text = titlesArray[index]
        return cell
    }
    
    func numberOfItemsInPagerTabBar() -> Int {
        return titlesArray.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = titlesArray[index]
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        pagerController.scrollToController(at: index, animate: true);
    }
}

extension RPRecommendController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return controllersArray.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = controllersArray[index]
        return vc as! UIViewController
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}

