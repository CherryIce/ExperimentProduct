//
//  RPBillViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/17.
//

import UIKit
import TYPagerController

class RPBillViewController: RPBaseViewController {
    var cIndex = Int()
    private lazy var tabBar = TYTabPagerBar()
    private lazy var pagerController = TYPagerController()
    private let titlesArray = ["收入","支出"]
    private lazy var controllersArray: NSMutableArray = []
    private lazy var dateTimeBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的账单"
        addTabPagerBar()
        addPagerController()
        loadData()
    }

    func addTabPagerBar() {
        self.tabBar.delegate = self
        self.tabBar.dataSource = self
        self.tabBar.layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        self.tabBar.layout.cellEdging = 10
        self.tabBar.layout.normalTextFont = .systemFont(ofSize: 16)
        self.tabBar.layout.selectedTextFont = .boldSystemFont(ofSize: 16)
        self.tabBar.layout.normalTextColor = RPColor.lightGray
        self.tabBar.layout.selectedTextColor = RPColor.redWine
        self.tabBar.layout.progressColor = RPColor.redWine
        self.tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.view.addSubview(self.tabBar)
        self.tabBar.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        dateTimeBtn = UIButton.init(type: .custom)
        dateTimeBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        dateTimeBtn.setTitle("2021/11/17", for: .normal)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.titleAlignment = .trailing
            configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 16, bottom: 5, trailing: 16)
            dateTimeBtn.configuration = configuration
        }else{
            dateTimeBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
            dateTimeBtn.titleLabel?.textAlignment = .right
        }
        
        dateTimeBtn.addTarget(self, action: #selector(selectedTimeBill), for: .touchUpInside)
        view.addSubview(dateTimeBtn)
        dateTimeBtn.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
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
        while i < titlesArray.count {
            let vc = RPBillListsViewController.init()
            self.controllersArray.add(vc)
            i += 1
        }
        if cIndex != 0 {
            self.tabBar.scrollToItem(from: 0, to: cIndex, animate: true)
            self.pagerController.scrollToController(at: cIndex, animate: true)
        }
        reloadData()
    }
    
    func reloadData() {
        self.tabBar.reloadData()
        self.pagerController.reloadData()
    }
    
    @objc func selectedTimeBill() {
        //选日期查看账单信息
    }
}

extension RPBillViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
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

extension RPBillViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.controllersArray.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = self.controllersArray[index] as! RPBillListsViewController
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
