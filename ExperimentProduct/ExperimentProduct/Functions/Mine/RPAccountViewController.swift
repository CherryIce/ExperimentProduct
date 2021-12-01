//
//  RPAccountViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

class RPAccountViewController: RPBaseViewController {
    
    private var tableView = UITableView()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSArray = []
    private lazy var viewModel = RPSetupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "账户与安全"
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
        
        let v = UIView.init()
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
        let exitLogin = UIButton.init(type: .custom)
        exitLogin.frame = CGRect.init(x: 30, y: 30, width: v.frame.width - 60, height: 50)
        exitLogin.backgroundColor = UIColor.init(hexString: "#FFB366")
        exitLogin.setTitle("退出登录", for:.normal)
        exitLogin.addTarget(self, action: #selector(exitLoginClick), for: .touchUpInside)
        exitLogin.titleLabel?.font = .systemFont(ofSize: 16)
        exitLogin.layercornerRadius(cornerRadius: 4)
        v.addSubview(exitLogin)
        
        tableView.tableFooterView = v
    }
    
    func loadData () {
        viewModel.getAccountData(params: NSDictionary.init()) { (datas) in
            dataList = datas
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            print("请求失败了")
            tableView.reloadData()
        }
    }
    
    @objc func exitLoginClick() {
        let alert = RPAlertViewController.init(title: "温馨提示", message: "真的要残忍的离开吗?", cancel: "取消", confirm: "确定") { (index) in
            if index == 1 {
                UserDefaults.standard.removeObject(forKey: kTokenExpDateTime)
                UserDefaults.standard.synchronize()
                RPCache.shared.removeAllCache()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let window = UIApplication.shared.windows.first
                    window?.rootViewController = RPNavigationController.init(rootViewController: RPLoginViewController.init())
                }
            }
        }
        alert.titleColor = .black
        alert.msgColor = .red
        alert.cancelColor = RPColor.MainColor
        alert.confirmColor = .init(hexString: "999999")
        self.present(alert, animated: false,completion: nil)
    }
}

extension RPAccountViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        let xx = cellData as! RPTableViewCellItem
        let model = xx.cellData as! RPYaModel
        switch model.title {
        case "密码":
            //判断是否设置了密码是吧
            let ctl = RPPasswordViewController.init()
            ctl.type = .change
            self.navigationController?.pushViewController(ctl, animated: true)
            break
        default:break
        }
    }
}
