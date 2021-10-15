//
//  RPTableViewAdapter.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/15.
//

import UIKit

//创建cell事件协议
protocol RPTableViewCellEventDelegate:NSObjectProtocol
{
    //回调方法 传一个String类型的值
    func didSelectTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,data:RPCellDataItem)
    func delegateMethod(string:String)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPTableViewCellEventDelegate {
    func didSelectTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,data:RPCellDataItem) {
        
    }
    func delegateMethod(string: String) {
        
    }
}

//构建数据类型协议
protocol RPCellDataDelegate:NSObjectProtocol
{
    func setData(data:RPCellDataItem,delegate:RPTableViewCellEventDelegate)
}

class RPTableViewAdapter: NSObject {
    
    //数据源
    public var dataSourceArray: [RPCellDataItem]{
        didSet {
            
        }
    }
    
    //事件代理
    weak var delegate:RPTableViewCellEventDelegate?
    
    lazy var reuseSet: NSMutableSet = {
        var reuseSet = NSMutableSet.init()
        return reuseSet
    }()
    
    override init() {
        self.dataSourceArray = []
        super.init()
    }
    
    private func reuseIdentifierForCellClass(cellClass:AnyClass,tableView:UITableView) -> String {
        var identifier = String(describing:cellClass)//等同于oc NSStringFromClass(cellClass)
        if (identifier.count == 0) {
            identifier = "cellIdentifier"
        }
        if !reuseSet.contains(identifier) {
            let path = Bundle.main.path(forResource: identifier, ofType: "nib")
            if (path != nil) {
                tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            } else {
                tableView.register(cellClass, forCellReuseIdentifier: identifier)
            }
            reuseSet.add(identifier)
        }
        return identifier
    }
}

extension RPTableViewAdapter:UITableViewDelegate,UITableViewDataSource,RPTableViewCellEventDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSourceArray[indexPath.row]
        let identifier = reuseIdentifierForCellClass(cellClass: item.cellClass, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as! RPCellDataDelegate).setData(data: item, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSourceArray[indexPath.row]
        //调用代理方法
        if delegate != nil{
            delegate?.didSelectTableView(tableView, didSelectRowAt: indexPath,data:item)
        }
    }
}


class RPCellDataItem: NSObject {
    //cell
    var cellClass = UITableViewCell.self
    //cell对应的数据
    var cellData = NSObject()
    //cell上的操作事件合集
    var cellEventActions = NSArray()
    //行高
    var cellh = CGFloat()
    
    //sectionHeader数据
    var sectionHeaderData = NSObject()
    //sectionHeaderView
    var sectionHeaderView = UIView.self
    //头高
    var sectionHeaderH = CGFloat()
    
    //sectionFooter数据
    var sectionFooterData = NSObject()
    //sectionFooterview
    var sectionFooterview = UIView.self
    //尾高
    var sectionFooterH = CGFloat()
    
}
