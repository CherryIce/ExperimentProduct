//
//  RPPasswordViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/11.
//

import UIKit

//修改或重置密码
public enum RPPasswordHandleType : Int {
    case add //设置密码
    case change //修改密码
}

class RPPasswordViewController: RPBaseViewController {
    
    var type = RPPasswordHandleType(rawValue: 0)
    private var tableView = UITableView()
    private var dataList:NSMutableArray = NSMutableArray()
    private var submitBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createTableViewUI()
        loadData()
    }
    
    fileprivate func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.backgroundColor = RPColor.Separator
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let v = UIView.init()
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
        submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: 30, y: 30, width: v.frame.width - 60, height: 50)
        submitBtn.backgroundColor = .red
        submitBtn.setTitle("确定", for:.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        submitBtn.titleLabel?.font = .systemFont(ofSize: 16)
        submitBtn.layercornerRadius(cornerRadius: 4)
        v.addSubview(submitBtn)
        
        tableView.tableFooterView = v
    }
    
    fileprivate func loadData () {
        dataList.removeAllObjects()
        if type == .add {
            self.navigationItem.title = "设置密码"
            let xx = ["设置密码","再次确认","验 证 码"]
            let xxs = ["请设置密码","请再次输入密码","请输入验证码"]
            let yy = [RPFromTableType.inputMid,RPFromTableType.inputMid,RPFromTableType.verification]
            for i in 0..<xx.count {
                let model = RPFromTableModel.init(title: xx[i], placeholder:xxs[i], cellClass:nil, type: yy[i])
                model.maxLength = i == 2 ? 4 : 12
                dataList.add(model)
            }
            tableView.reloadData()
        }else{
            self.navigationItem.title = "修改密码"
            //这里只考虑手机验证码修改密码这一选择 用原密码修改方案有需求可以增加
            let xx = ["新 密 码","再次确认","验 证 码"]
            let xxs = ["请设置新密码","请再次输入新密码","请输入验证码"]
            let yy = [RPFromTableType.inputMid,RPFromTableType.inputMid,RPFromTableType.verification]
            for i in 0..<xx.count {
                let model = RPFromTableModel.init(title: xx[i], placeholder:xxs[i], cellClass:nil, type: yy[i])
                model.maxLength = i == 2 ? 4 : 12
                dataList.add(model)
            }
            tableView.reloadData()
        }
    }
    
    @objc func submitClick()  {
        var unfinished = false
        var tips = ""
        for xx in dataList {
            let model = xx as! RPFromTableModel
            if model.info.count == 0 {
                unfinished = true
                tips = model.textfiledPlaceholder
                break
            }
        }
        
        if unfinished {
            self.navigationController?.view.hideAllToasts(includeActivity: true, clearQueue: true)
            self.navigationController?.view.makeToast(tips,
                                                      duration: 3.0,
                                                      position: .center,
                                                      style: RPTools.RPToastStyle)
            return
        }
        
        switch type {
        case .add:
            
            break
        case .change:
            
            break
        case .none:
            break
        }
    }
}

extension RPPasswordViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataList[indexPath.row] as! RPFromTableModel
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: model.cellClass, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as! RPFromTableCellDataDelegate).setCellData(cellData: model, delegate: self, indexPath: indexPath)
        return cell
    }
}

extension RPPasswordViewController:RPFromTableCellActionDelegate{
    func textfiledDidChangeValue(_ indexPath: IndexPath, cellData: RPFromTableModel) {
        //按RPFromTableVerificationCell和可变数组填装数据源的处理 其实这个方法有点多余 不过开心就好
        let model = dataList[indexPath.row] as! RPFromTableModel
        log.debug(cellData.info + "\n" + model.info)
    }
}

