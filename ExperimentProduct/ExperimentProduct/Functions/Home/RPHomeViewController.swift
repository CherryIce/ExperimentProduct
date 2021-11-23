//
//  RPHomeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import TYPagerController

class RPHomeViewController: RPBaseViewController {
    private lazy var topNavView = UIView()
    private lazy var tabBar = TYTabPagerBar()
    private lazy var pagerController = TYPagerController()
    private lazy var titlesArray = [String]()
    private lazy var controllersArray: NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNav()
        addTabPagerBar()
        addPagerController()
        loadData()
    }
    
    func creatNav(){
        topNavView = UIView.init()
        topNavView.backgroundColor = .white
        self.view.addSubview(topNavView)
        topNavView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(RPTools.NAV_HEIGHT)
        }
        
        let search = UIButton.init(type: .custom)
        search.setImage(RPTools.getPngImage(forResource: "find_nor@2x"), for: .normal)
        search.addTarget(self, action: #selector(searchOthers), for: .touchUpInside)
        topNavView.addSubview(search)
        search.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-7)
        }
    }
    
    func addTabPagerBar() {
        self.tabBar.delegate = self
        self.tabBar.dataSource = self
        self.tabBar.layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        self.tabBar.layout.cellEdging = 10
        self.tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: 16)
        self.tabBar.layout.selectedTextFont = UIFont.boldSystemFont(ofSize: 16)
        self.tabBar.layout.normalTextColor = RPColor.lightGray
        self.tabBar.layout.selectedTextColor = RPColor.redWine
        self.tabBar.layout.progressColor = RPColor.redWine
        self.tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        topNavView.addSubview(self.tabBar)
        self.tabBar.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-2)
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
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
        titlesArray = ["关注","发现","附近"]
        
        let follow = RPFollowViewController.init()
        self.controllersArray.add(follow)
        
        let recommend = RPRecommendController.init()
        self.controllersArray.add(recommend)
        
        let near = RPNearViewController.init()
        self.controllersArray.add(near)

        reloadData()
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
        
        //指定默认
        self.tabBar.scrollToItem(from: 0, to: 1, animate: true)
        self.pagerController.scrollToController(at: 1, animate: true)
    }
    
    @objc func searchOthers() {
        
    }
}

extension RPHomeViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        cell.titleLabel.text = self.titlesArray[index]
        return cell
    }
    
    func numberOfItemsInPagerTabBar() -> Int {
        return self.titlesArray.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = self.titlesArray[index]
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
    }
}

extension RPHomeViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.controllersArray.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = self.controllersArray[index]
        return vc as! UIViewController
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}


