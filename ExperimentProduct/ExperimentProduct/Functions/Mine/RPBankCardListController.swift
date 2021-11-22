//
//  RPBankCardListController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/22.
//

import UIKit

class RPBankCardListController: RPBaseViewController {

    private var tableView = UITableView()
    private var dataList:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的银行卡"
        createTableViewUI()
        loadData()
    }
    
    fileprivate func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 1
        tableView.sectionFooterHeight = 50
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    fileprivate func loadData () {
        //请求拿到数据
        tableView.reloadData()
    }

    @objc func addClick() {
        self.navigationController?.pushViewController(RPAddBankCardController.init(), animated: true)
    }
}

extension RPBankCardListController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: UITableViewCell.self, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        //RPBankCardModel
        cell.textLabel?.text = "天地银行(0808)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        v.backgroundColor = .white
        let addBtn = UIButton.init(type: .custom)
        addBtn.frame = CGRect.init(x: 16, y: 0, width: v.frame.width - 32, height: 50)
        addBtn.setTitleColor(RPColor.redWine, for: .normal)
        addBtn.setTitle("添加新卡", for:.normal)
        addBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        addBtn.titleLabel?.font = .systemFont(ofSize: 13)
        v.addSubview(addBtn)
        return v
    }
}

