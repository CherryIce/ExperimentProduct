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
        
        let tableView = listView as! UITableView
        let cell = tableView.cellForRow(at: indexPath)
        
        switch model.title {
        case "大头贴":
            self.navigationController?.pushViewController(RPLookPictureViewController.init(), animated: true)
            break
        case "地区":
            let xCell = cell as! RPYaCell
            viewModel.getProvincesData(params: NSDictionary.init()) { (datas) in
                let xxx = RPSelectCityViewController.init()
                xxx.dataArray = datas as! [RProvincesModel]
                self.navigationController?.pushViewController(xxx, animated: true)
                xxx.selectCityFinishedCallBack { (model1, model2, model3) in
                    DispatchQueue.main.async {
                        xCell.detailTextLabel?.text = model1.ssqname+model2.ssqname+model3.ssqname
                    }
                }
            } failed: { (error) in
                
            }
            break
        case "个人二维码":
            self.navigationController?.pushViewController(RPMyQRCodeViewController.init(), animated: true)
            break
        case "性别":
            let xCell = cell as! RPYaCell
            let man = RPActionSheetCellItem.init(title: "男")
            let woman = RPActionSheetCellItem.init(title: "女")
            let alertC = RPActionSheetController.init(title:nil,
                                                      message:nil,
                                                      dataArray:[[man,woman],
                                                                 [RPActionSheetCellItem.cancel()]]) { (indexPath) in
                DispatchQueue.main.async {
                    xCell.detailTextLabel?.text = ["男","女"][indexPath.row]
                }
            }
            self.present(alertC, animated: true,completion: nil)
            break
        case "生日":
            break
        case "名字":
            let nickName = RPUpdateNickNameViewController.init()
            self.navigationController?.pushViewController(nickName, animated: true)
            let xCell = cell as! RPYaCell
            nickName.callBackFunction { (nick) in
                DispatchQueue.main.async {
                    xCell.detailTextLabel?.text = nick
                }
            }
            break
        case "个性签名":
            let fb = RPFeedBackViewController.init()
            fb.type = .personalInfo
            fb.navigationItem.title = model.title
            self.navigationController?.pushViewController(fb, animated: true)
            let xCell = cell as! RPYaCell
            fb.callBackFunction { (sign) in
                DispatchQueue.main.async {
                    xCell.detailTextLabel?.text = sign
                }
            }
            break
        default:
            break
        }
    }
}
