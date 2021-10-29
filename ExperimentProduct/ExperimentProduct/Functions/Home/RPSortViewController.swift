//
//  RPSortViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/29.
//

import UIKit

//sort table

class RPSortViewController: RPBaseViewController {
    
    var tableView = UITableView()
    var editBtn = UIButton()
    var dataList: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        creatNavRightItem()
        dataList = NSMutableArray.init(array: ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"])
        createTableViewUI()
    }
    
    func creatNavRightItem() {
        editBtn = UIButton.init(type: .custom)
        editBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        editBtn.setTitle("编辑", for:.normal)
        editBtn.setTitle("完成", for: .selected)
        editBtn.setTitleColor(RPColor.MainColor, for: .normal)
        editBtn.setTitleColor(RPColor.red, for: .selected)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editBtn)
    }
    
    //MARK: - 实例化tableView
    func createTableViewUI() {
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        //去除分割线
//        tableView.separatorStyle = .none
        tableView.separatorColor = RPColor.Separator
        //去掉多余的分割线
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        self.view.addSubview(tableView)
    }
    
    //MARK: - 编辑
    @objc func editAction(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        //设置可编辑、不可编辑
        tableView.setEditing(sender.isSelected, animated: true)
    }
}

extension RPSortViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - 返回多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.textLabel?.text = dataList[indexPath.row] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: - 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RPYaViewController.init(), animated: true)
    }
    
    //MARK: - 使cell的分割线与屏幕两端对齐
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    //MARK: - 设置编辑样式
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //编辑的时候返回带有选择按钮的样式
        //        return UITableViewCell.EditingStyle(rawValue: UITableViewCell.EditingStyle.RawValue(UInt8(UITableViewCell.EditingStyle.insert.rawValue) | UInt8(UITableViewCell.EditingStyle.delete.rawValue)))!
        
        //添加
        //        return .insert
        
        //删除
        return .delete
    }
    
    //MARK: - 删除单元格
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = RPAlertViewController.init(title: "温馨提示", message: "确定要删除\(self.dataList[indexPath.row])？", cancel: "取消", confirm: "确定") { (index) in
                if index == 1 {
                    self.dataList.removeObject(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            alert.titleColor = .red
            alert.msgColor = .black
            alert.cancelColor = .blue
            alert.confirmColor = .red
            self.present(alert, animated: true,completion: nil)
        }
        
        if editingStyle == .insert {
            print("增加")
        }
    }
    
    //MARK: - 允许排序
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - 排序
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        dataList.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)
        tableView.reloadData()
    }
}
