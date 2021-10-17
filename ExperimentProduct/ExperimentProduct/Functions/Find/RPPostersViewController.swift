//
//  RPPostersViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit
import TYPagerController

class RPPostersViewController: RPBaseViewController {
    
    private lazy var tabBar = TYTabPagerBar()
    private lazy var pagerController = TYPagerController()
    private lazy var titlesArray = [String]()
    private lazy var controllersArray: NSMutableArray = []
    private lazy var viewModel  = RPPosterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "展业海报"
        
        creatNavRightItem()
        addTabPagerBar()
        addPagerController()
        loadData()
    }
    
    @objc func editAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "xxxx"), object: nil)
    }
    
    func creatNavRightItem() {
        let editBtn = UIButton.init(type: .custom)
        editBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        editBtn.setTitle("模拟", for:.normal)
        editBtn.setTitleColor(RPColor.MainColor, for: .normal)
        editBtn.setTitleColor(RPColor.red, for: .selected)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editBtn)
    }
    
    func addTabPagerBar() {
        self.tabBar.delegate = self
        self.tabBar.dataSource = self
        self.tabBar.layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        self.tabBar.layout.cellEdging = 10
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
        viewModel.getTitleLabel(params: NSDictionary.init()) { (datas) in
            titlesArray = ["一叶子","维生素","玻尿酸","爽肤水"]
            var i = 0
            while i < titlesArray.count {
                let vc = RPPosterListViewController.init()
                self.controllersArray.add(vc)
                i += 1
            }
            reloadData()
        } failed: { (error) in
            //搞张占位图？
        }
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
    }
}

extension RPPostersViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
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

extension RPPostersViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.controllersArray.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = self.controllersArray[index] as! RPPosterListViewController
//        vc.pageIndex += 1
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
