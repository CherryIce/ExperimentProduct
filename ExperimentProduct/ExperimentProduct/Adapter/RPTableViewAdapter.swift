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
    func delegateMethod(string:String)
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
    
//    weak var delegate:RPCellDataDelegate?
//    func xxx() {
//        //调用代理方法
//        if delegate != nil{
//            delegate?.delegateMethod(string:"123")
//        }
//    }
    
    
    var reuseSet = NSMutableSet()
    
    override init() {
        self.dataSourceArray = []
        super.init()
        reuseSet = NSMutableSet.init()
    }
    
    func reuseIdentifierForCellClass(cellClass:AnyClass,tableView:UITableView) -> String {
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
    func delegateMethod(string: String) {
        
    }
    
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
        
    }
}


class RPCellDataItem: NSObject {
    var cellClass = UITableViewCell.self//cell
    var cellData = NSObject() //数据
}
