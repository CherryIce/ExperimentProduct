//
//  RPAddBankCardController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/22.
//

import UIKit
import ActiveLabel

class RPAddBankCardController: RPBaseViewController {

    private var tableView = UITableView()
    private var dataList:NSMutableArray = NSMutableArray()
    private var submitBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //如果是实际情况 有限制绑定银行的 最好是有个可绑定银行列表让客户选择银行 再去填写银行卡号
        self.navigationItem.title = "添加银行卡"
        createTableViewUI()
        loadData()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: RPImage.NavBackImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(trunBack))
    }

    fileprivate func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 40
        tableView.sectionFooterHeight = 1
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let v = UIView.init()
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 150)
        submitBtn = UIButton.init(type: .custom)
        submitBtn.frame = CGRect.init(x: 30, y: 50, width: v.frame.width - 60, height: 50)
        submitBtn.backgroundColor = RPColor.MainColor
        submitBtn.setTitle("添加", for:.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        submitBtn.titleLabel?.font = .systemFont(ofSize: 16)
        submitBtn.layercornerRadius(cornerRadius: 4)
        v.addSubview(submitBtn)
        
        let protocolLabel = ActiveLabel(frame: CGRect(x: submitBtn.frame.minX, y: submitBtn.frame.maxY + 10, width: submitBtn.frame.width, height: 30))
        protocolLabel.textAlignment = .center
        let customType = ActiveType.custom(pattern: "\\《xx银行卡使用协议》")
        protocolLabel.enabledTypes = [customType]
        protocolLabel.text = "添加即同意《xx银行卡使用协议》"
        protocolLabel.font = UIFont.systemFont(ofSize: 12)
        protocolLabel.customColor[customType] = RPColor.MainColor
        protocolLabel.textColor = .init(hexString: "#2E3135")
        protocolLabel.handleCustomTap(for: customType, handler: { (customType) in
            let ctl = RPWkwebViewController.init()
            ctl.urlString = "https://www.baidu.com"
            self.navigationController?.pushViewController(ctl, animated: true)
        })
        v.addSubview(protocolLabel)
        
        tableView.tableFooterView = v
    }
    
    fileprivate func loadData () {
        let xx = ["持卡人姓名","银行卡号","银行预留电话","验证码"]
        let xxs = ["请输入持卡人姓名","请输入银行卡号","请输入手机号","请输入短信验证码"]
        let limits = [20,18,11,4]
        let yy = [RPFromTableType.textField,RPFromTableType.textField,RPFromTableType.textField,RPFromTableType.textfieldAndButton]
        for i in 0..<xx.count {
            let model = RPFromTableModel.init(title: xx[i], placeholder:xxs[i], cellClass:nil, type: yy[i])
            model.titleFont = .systemFont(ofSize: 12)
            model.titleColor = .init(hexString: "666666")
            model.maxLength = limits[i]
            dataList.add(model)
        }
        tableView.reloadData()
    }
    
    @objc func submitClick()  {
        var unfinished = false
        var tips = ""
        for xx in dataList {
            let model = xx as! RPFromTableModel
            if model.info.count == 0 {
                unfinished = true
                tips = model.placeholder
                break
            }
        }
        
        if unfinished {
            self.viewShowToast(tips,position: .center)
            return
        }
        //...
    }
    
    @objc func trunBack() {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }else {
            if self.navigationController?.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RPAddBankCardController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataList[indexPath.section] as! RPFromTableModel
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: model.cellClass, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as! RPFromTableCellDataDelegate).setCellData(cellData: model, delegate: self, indexPath: indexPath)
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataList[section] as! RPFromTableModel
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        let label = UILabel.init(frame: CGRect(x: 16, y: 0, width: v.frame.width - 32, height: 20))
        label.center.y = v.frame.height * 0.5
        label.text = model.title
        label.textColor = model.titleColor
        label.font = model.titleFont
        v.addSubview(label)
        return v
    }
    
}

extension RPAddBankCardController:RPFromTableCellActionDelegate{
    func textfiledDidChangeValue(_ indexPath: IndexPath, cellData: RPFromTableModel) {
        //按RPFromTableVerificationCell和可变数组填装数据源的处理 其实这个方法有点多余 不过开心就好
        let model = dataList[indexPath.row] as! RPFromTableModel
        log.debug(cellData.info + "\n" + model.info)
    }
}
