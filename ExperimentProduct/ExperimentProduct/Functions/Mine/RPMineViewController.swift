//
//  RPMineViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import RxSwift

class RPMineViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSMutableArray = []
    private lazy var viewModel = RPMineViewModel()
    
    //头部视图
    lazy var headerView = RPMineHeaderView()
    //tableView
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        creatHeaderView()
        createTableViewUI()
        adapter.c_delegate = self
        loadData()
        
        self.tableView.tableHeaderView = headerView
        headerView.userNameLabel.text = "userName"
        headerView.descrLabel.text = "descrInfo"
    }
    
    func creatHeaderView () {
        headerView = RPMineHeaderView.init(frame: CGRect.init(x: .zero, y: .zero, width: SCREEN_WIDTH, height: RPTools.IS_IPHONEX ? 170 : 150))
        
        headerView.headImageButton.rx.tap.bind {
            self.navigationController?.pushViewController(RPPersonInfoViewController.init(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    //UI
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    //请求数据
    func loadData () {
        viewModel.getMeData(params: NSDictionary.init()) { (datas) in
            dataList.addObjects(from: datas as! [Any])
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            log.error("请求失败了")
        }
    }
}

extension RPMineViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        let xx = cellData as! RPTableViewCellItem
        let model = xx.cellData as! RPYaModel
        let normalSelector = NSSelectorFromString(model.clickAction)
        if (self.responds(to: normalSelector)) {
            self.perform(normalSelector)
        }
    }
    
    func cellSubviewsClickAction(_ indexPath: IndexPath, cellData: AnyObject?) {
        let model = cellData as! RPYaModel
        let normalSelector = NSSelectorFromString(model.imgClickAction)
        if (self.responds(to: normalSelector)) {
            self.perform(normalSelector)
        }
    }
    
    @objc func payAction() {
        self.navigationController?.pushViewController(RPWalletViewController.init(), animated: true)
    }
    
    @objc func collectAction() {
        self.navigationController?.pushViewController(RPCollectViewController.init(), animated: true)
    }
    
    @objc func activityAction() {
        self.navigationController?.pushViewController(RPNewsViewController.init(), animated: true)
    }
    
    @objc func setupAction() {
        self.navigationController?.pushViewController(RPSetupViewController.init(), animated: true)
    }
}

