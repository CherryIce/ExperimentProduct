//
//  RPYaViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPYaViewController: RPBaseViewController {
    
    private var tableView = UITableView()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSMutableArray = []
    private lazy var viewModel = RPYaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "试试适配器"
        createTableViewUI()
        adapter.c_delegate = self
        loadData()
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        tableView.hb_ept.delegate = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func loadData () {
        viewModel.getYaData(params: NSDictionary.init()) { (datas) in
            dataList.addObjects(from: datas as! [Any])
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            print("请求失败了")
            tableView.reloadData()
        }
    }
}

extension RPYaViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        self.navigationController?.pushViewController(RPPostersViewController.init(), animated: true)
    }
}

extension RPYaViewController: HBEmptyDelegate {
    
    func customViewForEmpty() -> UIView? {
        let v = RPEmptyView.init(frame: self.view.bounds)
        v.type = .normal_no_data
        return v
    }
}
