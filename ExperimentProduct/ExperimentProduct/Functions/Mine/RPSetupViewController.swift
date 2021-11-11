//
//  RPSetupViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPSetupViewController: RPBaseViewController {
    
    private var tableView = UITableView()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSArray = []
    private lazy var viewModel = RPSetupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "设置"
        createTableViewUI()
        adapter.c_delegate = self
        loadData()
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorColor = RPColor.Separator
        tableView.backgroundColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func loadData () {
        viewModel.getSetupData(params: NSDictionary.init()) { (datas) in
            dataList = datas
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            print("请求失败了")
            tableView.reloadData()
        }
    }
}

extension RPSetupViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        let xx = cellData as! RPTableViewCellItem
        let model = xx.cellData as! RPYaModel
        let normalSelector = NSSelectorFromString(model.clickAction)
        if (self.responds(to: normalSelector)) {
            self.perform(normalSelector)
        }
    }
    
    @objc func accountAction() {
        
    }
    
    @objc func feedbackAction() {
        let fb = RPFeedBackViewController.init()
        fb.type = .feedback
        fb.navigationItem.title = "反馈建议"
        self.navigationController?.pushViewController(fb, animated: true)
    }
    
    @objc func privcyAction() {
        
    }
    
    @objc func clearCacheAction() {
        //带参数的传参方法在swift中实现貌似不太容易 暂时先缓缓
        RPCache.shared.removeAllCache()
        loadData()
    }
    
    @objc func aboutAction() {
        
    }
}
