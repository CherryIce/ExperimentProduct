//
//  RPFindViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

class RPFindViewController: RPBaseViewController {
    
    private var tableView = UITableView()
    private var dataList: NSMutableArray = []
    private lazy var viewModel = RPFindViewModel()
    private lazy var headerView: RPFindHeaderView = {
        var headerView = RPFindHeaderView.init()
        let bannerW = SCREEN_WIDTH - 20
        let bannerH = bannerW * 9 / 16
        let labelH = 90
        let headerH = CGFloat(bannerH+CGFloat(labelH))
        headerView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:headerH)
        headerView.backgroundColor = RPColor.ShallowColor
        headerView.delegate = self
        return headerView
    }()
    
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
        loadData()
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
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: String(describing:RPFindNewsLinkCell.self), bundle: nil), forCellReuseIdentifier: "RPFindNewsLinkCell")
        self.view.addSubview(tableView)
        
        tableView.tableHeaderView = headerView
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(RPTools.NAV_HEIGHT)
        }
    }
    
    
    func loadData () {
        viewModel.getFindLists(params: NSDictionary.init()) { (datas) in
            headerView.dataSourceArray = []
            dataList.addObjects(from: datas as! [Any])
            tableView.reloadData()
        } failed: { (error) in
            print("请求失败了")
        }
    }
    
    @objc func searchMore() {
        
    }
}

extension RPFindViewController:UITableViewDelegate,UITableViewDataSource,RPTableViewCellEventDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = dataList[section] as! RPTableViewSectionItem
        return sectionItem.cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = dataList[indexPath.section] as! RPTableViewSectionItem
        let item = sectionItem.cellDatas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:RPFindNewsLinkCell.self), for: indexPath)
        (cell as! RPFindNewsLinkCell).setData(data: item, titles: sectionItem.sectionHeaderData as! [String], indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = dataList[indexPath.section] as! RPTableViewSectionItem
        let item = sectionItem.cellDatas[indexPath.row]
        return item.cellh
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        let btn = UIButton.init(type: .custom)
        btn.frame = v.bounds
        btn.setTitle("查看更多", for: .normal)
        btn.setTitleColor(RPColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(searchMore), for: .touchUpInside)
        v.addSubview(btn)
        return v
    }
}

extension RPFindViewController: RPFindHeaderViewDelegate {
    func clickLabelNeedFix(_ index:Int,data:AnyObject) {
        self.navigationController?.pushViewController(RPYaViewController.init(), animated: true)
    }
}
