//
//  RPPersonInfoViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/10.
//

import UIKit

class RPPersonInfoViewController: RPBaseViewController {
    
    private var tableView = UITableView()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSArray = []
    private lazy var viewModel = RPPersonInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "基本信息"
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
        viewModel.getInfoData(params: NSDictionary.init()) { (datas) in
            dataList = datas
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            
        }
    }
    
    
}

extension RPPersonInfoViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        let xx = cellData as! RPTableViewCellItem
        let model = xx.cellData as! RPYaModel
        
        switch model.title {
        case "大头贴":
            self.navigationController?.pushViewController(RPLookPictureViewController.init(), animated: true)
            break
        case "地区":
            viewModel.getProvincesData(params: NSDictionary.init()) { (datas) in
                let xxx = RPSelectCityViewController.init()
                xxx.dataArray = datas as! [RProvincesModel]
                self.navigationController?.pushViewController(xxx, animated: true)
                xxx.selectCityFinishedCallBack { (model1, model2, model3) in
                    log.debug(model1.ssqname+model2.ssqname+model3.ssqname)
                }
            } failed: { (error) in
                
            }
            break
        default:
            break
        }
    }
}
