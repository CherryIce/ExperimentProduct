//
//  RPFindViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

class RPFindViewController: RPBaseViewController {
    
    var tableView = UITableView()
    var adapter = RPTableViewAdapter()
    var dataList: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let num =  arc4random() % 20
        if num % 2 == 0 {
            self.tabBarItem.badgeValue = "\(num)"
        }else {
            self.tabBarItem.badgeValue = nil
        }
        
        //创建头部视图
        creatNav()
        
        createTableViewUI()
        
        adapter.delegate = self
        
        for i in 0...10 {
            let item = RPCellDataItem.init()
            item.cellData = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i] as NSObject
            item.cellClass = RPYaCell.self
            dataList.add(item)
        }
        adapter.dataSourceArray = dataList as! [RPCellDataItem]
        tableView.reloadData()
    }
    
    func creatNav(){
        var titleView = UIView()
        titleView = UIView.init()
        titleView.backgroundColor = .white
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(RPTools.NAV_HEIGHT)
        }
        
        var titleLab = UILabel()
        titleLab = UILabel.init()
        titleLab.text = "发现"
        titleLab.font = UIFont.boldSystemFont(ofSize: 24)
        titleView .addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    //MARK: - 实例化tableView
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorColor = RPColor.Separator
        //去掉多余的分割线
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(RPTools.NAV_HEIGHT)
        }
    }
    
    // 隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true) //避免的出现返回时导航栏的黑块
    }
    
    // 显示导航栏
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension RPFindViewController : RPTableViewCellEventDelegate {
    func didSelectTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,data:RPCellDataItem) {
        self.navigationController?.pushViewController(RPPostersViewController.init(), animated: true)
    }
}
