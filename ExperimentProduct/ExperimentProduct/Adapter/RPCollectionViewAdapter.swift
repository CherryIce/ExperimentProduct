//
//  RPCollectionViewAdapter.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/15.
//

import UIKit

//创建cell事件协议
protocol RPCollectionViewCellEventDelegate:NSObjectProtocol
{
    //回调方法 传一个String类型的值
    func didSelectCollectionView(_ collectionView: UICollectionView, didSelectRowAt indexPath: IndexPath,data:RPCollectionViewCellDataItem)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPCollectionViewCellEventDelegate {
    func didSelectCollectionView(_ collectionView: UICollectionView, didSelectRowAt indexPath: IndexPath,data:RPCollectionViewCellDataItem) {
        
    }
}

//构建数据类型协议
protocol RPCollectionViewCellDataDelegate:NSObjectProtocol
{
    func setData(data:RPCollectionViewCellDataItem,delegate:RPCollectionViewCellEventDelegate)
}

class RPCollectionViewAdapter: NSObject {
    //数据源
    public var dataSourceArray: [RPCollectionViewCellDataItem]{
        didSet {
            
        }
    }
    
    //事件代理
    weak var delegate:RPCollectionViewCellEventDelegate?
    
    lazy var reuseSet: NSMutableSet = {
        var reuseSet = NSMutableSet.init()
        return reuseSet
    }()
    
    override init() {
        self.dataSourceArray = []
        super.init()
    }
    
    private func reuseIdentifierForCellClass(cellClass:AnyClass,collectionView:UICollectionView) -> String {
        var identifier = String(describing:cellClass)//等同于oc NSStringFromClass(cellClass)
        if (identifier.count == 0) {
            identifier = "cellIdentifier"
        }
        if !reuseSet.contains(identifier) {
            let path = Bundle.main.path(forResource: identifier, ofType: "nib")
            if (path != nil) {
                collectionView.register(UINib.init(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
            } else {
                collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
            }
            reuseSet.add(identifier)
        }
        return identifier
    }
    
    private func reuseIdentifierForReusableViewClass(reusableView:AnyClass,collectionView:UICollectionView,forSupplementaryViewOfKind kind: String) -> String {
        var identifier = String(describing:reusableView)//等同于oc NSStringFromClass(cellClass)
        if (identifier.count == 0) {
            identifier = "ReusableViewIdentifier"
        }
        if !reuseSet.contains(identifier) {
            let path = Bundle.main.path(forResource: identifier, ofType: "nib")
            if (path != nil) {
                collectionView.register(UINib.init(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
            } else {
                collectionView.register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
            }
            reuseSet.add(identifier)
        }
        return identifier
    }
}

extension RPCollectionViewAdapter:UICollectionViewDelegate,UICollectionViewDataSource,RPCollectionViewCellEventDelegate {
    
    //cell数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    //cell显示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSourceArray[indexPath.row]
        let identifier = reuseIdentifierForCellClass(cellClass: item.cellClass, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        (cell as! RPCollectionViewCellDataDelegate).setData(data: item, delegate: self)
        return cell
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSourceArray[indexPath.row]
        //调用代理方法
        if delegate != nil{
            delegate?.didSelectCollectionView(collectionView, didSelectRowAt: indexPath,data:item)
        }
    }
    
    //返回自定义HeadView或者FootView，我这里以headview为例
    private func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        let item = dataSourceArray[indexPath.row]
        if kind == UICollectionView.elementKindSectionHeader{
            let id = reuseIdentifierForReusableViewClass(reusableView: item.sectionHeaderView, collectionView: collectionView, forSupplementaryViewOfKind: kind)
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath as IndexPath)
            return v
        }
        return UICollectionReusableView.init()
    }
}


class RPCollectionViewCellDataItem: NSObject {
    //cell
    var cellClass = UICollectionViewCell.self
    //cell对应的数据
    var cellData = NSObject()
    //cell上的操作事件合集
    var cellEventActions = NSArray()
    //行高
    var cellh = CGFloat()
    
    //sectionHeader数据
    var sectionHeaderData = NSObject()
    //sectionHeaderView
    var sectionHeaderView = UICollectionReusableView.self
    //头高
    var sectionHeaderH = CGFloat()
    
    //sectionFooter数据
    var sectionFooterData = NSObject()
    //sectionFooterview
    var sectionFooterview = UICollectionReusableView.self
    //尾高
    var sectionFooterH = CGFloat()
    
}
