//
//  RPTopicViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/4.
//

import UIKit

class RPTopicViewController: RPBaseViewController {
    private lazy var viewModel = RPTopicViewModel()
    private var tableView = UITableView()
    private lazy var dataArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Welcome Topic"
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
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        viewModel.getTopicLists(params: NSDictionary.init()) { (dataArray) in
            self.dataArray = NSMutableArray.init(array: dataArray)
            self.tableView.reloadData()
        } failed: { (error) in
            
        }
    }
}

extension RPTopicViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        let cell = tableView.dequeueReusableCell(withIdentifier: RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPTopViewCell.self, tableView: tableView), for: indexPath) as! RPTopViewCell
        cell.setCellData(model: model, delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        return model.cellH
    }
}

extension RPTopicViewController : RPTopViewCellDelegate {
    func selectURLInTopic(_ cell: RPTopViewCell, url: String) {
        let ctl = RPWkwebViewController.init()
        ctl.urlString = url
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func expandTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath) {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        if model.isExpand {
            model.textCurrH = 90
            model.cellH -= (model.textTotalH - 90)
            model.isExpand = false
        }else{
            model.textCurrH = model.textTotalH
            model.cellH += (model.textTotalH - 90)
            model.isExpand = true
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func commentTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func updatePermission(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func deleteTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func likeTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func locationClickInTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
}
