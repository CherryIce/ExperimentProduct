//
//  RPFollowViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit

//关注那些人的动态列表
class RPFollowViewController: RPBaseViewController {
    private var tableView = UITableView()
    private var dataList: NSMutableArray = []
    private lazy var viewModel = RPNiceViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createTableViewUI()
        loadData()
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        tableView.hb_ept.delegate = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func loadData () {
        viewModel.getFollowLists(params: NSDictionary.init()) { (datas) in
            dataList.addObjects(from: datas as! [Any])
            tableView.reloadData()
        } failed: { (error) in
            tableView.reloadData()
        }
    }
}

extension RPFollowViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPFollowViewCell.self, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RPFollowViewCell
        cell.model = dataList[indexPath.item] as! RPNiceModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
}

extension RPFollowViewController: HBEmptyDelegate {
    func customViewForEmpty() -> UIView? {
        let v = RPEmptyView.init(frame: self.view.bounds)
        v.type = .normal_no_data
        return v
    }
}


