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
            tableView.reloadData()
        }
    }
    
    @objc func searchMore() {
        self.navigationController?.pushViewController(RPYaViewController.init(), animated: true)
    }
}

extension RPFindViewController:UITableViewDelegate,UITableViewDataSource {
    
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
        (cell as! RPFindNewsLinkCell).setData(data: item, delegate:self,titles: sectionItem.sectionHeaderData as! [String], indexPath: indexPath)
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
        v.backgroundColor = .white
        let btn = UIButton.init(type: .custom)
        btn.frame = v.bounds
        btn.setTitle("查看更多", for: .normal)
        btn.setTitleColor(RPColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(searchMore), for: .touchUpInside)
        v.addSubview(btn)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension RPFindViewController: RPFindHeaderViewDelegate {
    func clickBannerNeedFix(_ index: Int) {
        let ctl = RPWkwebViewController.init()
        ctl.urlString = "https://www.baidu.com"
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func clickLabelNeedFix(_ index:Int,data:AnyObject?) {
        self.navigationController?.pushViewController(RPTopicViewController.init(), animated: true)
    }
}

extension RPFindViewController: RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView, indexPath: IndexPath, sectionData: AnyObject?, cellData: AnyObject?) {
        self.navigationController?.pushViewController(RPYaViewController.init(), animated: true)
    }
}

//extension RPFindViewController : HBEmptyDelegate {
//    func makePlaceHolderView() -> UIView! {
//        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
//        v.backgroundColor = UIColor.red
//        return v
//    }
//}

/** .plain模式
extension RPFindViewController: UIScrollViewDelegate {
    //header不悬停
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //组头高度
        let sectionHeaderHeight:CGFloat = 30
        //获取是否有默认调整的内边距
        let defaultEdgeTop:CGFloat = navigationController?.navigationBar != nil
            && self.automaticallyAdjustsScrollViewInsets ? 64 : 0

        if scrollView.contentOffset.y >= -defaultEdgeTop &&
            scrollView.contentOffset.y <= sectionHeaderHeight - defaultEdgeTop  {
            scrollView.contentInset = UIEdgeInsets.init(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight - defaultEdgeTop) {
            scrollView.contentInset = UIEdgeInsets.init(top: -sectionHeaderHeight + defaultEdgeTop, left: 0, bottom: 0, right: 0)
        }
    }
    
    //footer不悬停
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //组尾高度
        let sectionFooterHeight:CGFloat = 30

        //获取是否有默认调整的内边距
        let defaultEdgeTop:CGFloat = self.navigationController?.navigationBar != nil
            && self.automaticallyAdjustsScrollViewInsets ? RPTools.NAV_HEIGHT : 0

        let b = scrollView.contentOffset.y + scrollView.frame.height
        let h = scrollView.contentSize.height - sectionFooterHeight

        if b <= h {
            scrollView.contentInset = UIEdgeInsets.init(top: defaultEdgeTop, left: 0, bottom: 0, right: 0)
        }else if b > h && b < scrollView.contentSize.height {
             scrollView.contentInset = UIEdgeInsets.init(top: defaultEdgeTop, left: 0, bottom: b - h - 30, right: 0)
        }
    }

    //header、footer均不悬停
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //组头高度
        let sectionHeaderHeight:CGFloat = 30
        //组尾高度
        let sectionFooterHeight:CGFloat = 30

        //获取是否有默认调整的内边距
        let defaultEdgeTop:CGFloat = self.navigationController?.navigationBar != nil
            && self.automaticallyAdjustsScrollViewInsets ? RPTools.NAV_HEIGHT : 0

        //上边距相关
        var edgeTop = defaultEdgeTop
        if scrollView.contentOffset.y >= -defaultEdgeTop &&
            scrollView.contentOffset.y <= sectionHeaderHeight - defaultEdgeTop  {
            edgeTop = -scrollView.contentOffset.y
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight - defaultEdgeTop) {
            edgeTop = -sectionHeaderHeight + defaultEdgeTop
        }

        //下边距相关
        var edgeBottom:CGFloat = 0
        let b = scrollView.contentOffset.y + scrollView.frame.height
        let h = scrollView.contentSize.height - sectionFooterHeight

        if b <= h {
            edgeBottom = -30
        }else if b > h && b < scrollView.contentSize.height {
            edgeBottom = b - h - 30
        }

        //设置内边距
        scrollView.contentInset = UIEdgeInsets.init(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
    }
}
 **/
