//
//  RPTableViewAdapter.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit

//创建cell事件协议
protocol RPTableViewCellEventDelegate:NSObjectProtocol
{
    //回调方法 传一个String类型的值
    func didSelectTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,sectionData:RPTableViewSectionItem,cellData:RPTableViewCellItem)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPTableViewCellEventDelegate {
    func didSelectTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,sectionData:RPTableViewSectionItem,cellData:RPTableViewCellItem) {
        
    }
}

//构建数据类型协议
protocol RPCellDataDelegate:NSObjectProtocol
{
    func setData(data:RPTableViewCellItem,delegate:RPTableViewCellEventDelegate,indexPath:IndexPath)
}

class RPTableViewAdapter: NSObject {
    
    //数据源
    public var dataSourceArray: [RPTableViewSectionItem]{
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = dataSourceArray[section]
        return sectionItem.cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = dataSourceArray[indexPath.section]
        let item = sectionItem.cellDatas[indexPath.row]
        let identifier = reuseIdentifierForCellClass(cellClass: item.cellClass, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as! RPCellDataDelegate).setData(data: item, delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = dataSourceArray[indexPath.section]
        let item = sectionItem.cellDatas[indexPath.row]
        //调用代理方法
        if delegate != nil{
            delegate?.didSelectTableView(tableView, didSelectRowAt: indexPath,sectionData: sectionItem,cellData: item)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = dataSourceArray[section]
        if sectionItem.sectionHeaderH > 0 {
//            let customClass = String(describing:sectionItem.sectionHeaderView)
//            var v = type(of: NSClassFromString(customClass)).init()
//            if v is RPFindSectionHeaderView {
//                v = RPFindSectionHeaderView.init()
//                v.datas = sectionItem.sectionHeaderData as! [String]
//            }
//            let v = RPFindSectionHeaderView.init()
//            v.datas = 
//            return v
        }
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = dataSourceArray[indexPath.section]
        let item = sectionItem.cellDatas[indexPath.row]
        return item.cellh
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = dataSourceArray[section]
        return sectionItem.sectionHeaderH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = dataSourceArray[section]
        if sectionItem.sectionFooterH > 0 {
            return sectionItem.sectionFooterH
        }
        return 0
    }
}


class RPTableViewSectionItem: NSObject {
    //cell数据
    var cellDatas:[RPTableViewCellItem] = [RPTableViewCellItem]()
    
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

class RPTableViewCellItem: NSObject {
    //cell
    var cellClass = UITableViewCell.self
    //cell对应的数据
    var cellData = NSObject()
    //cell上的操作事件合集
    var cellEventActions = [Selector]()
    //行高
    var cellh = CGFloat()
}