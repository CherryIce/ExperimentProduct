//
//  RPCollectionViewAdapter.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit

//创建cell事件协议
protocol RPCollectionViewCellEventDelegate:NSObjectProtocol
{
    //点击cell
    func didSelectCollectionView(_ collectionView: UICollectionView,
                                 indexPath: IndexPath,
                                 sectionData:RPCollectionViewSectionItem,
                                 cellData:RPCollectionViewCellItem)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPCollectionViewCellEventDelegate {
    func didSelectCollectionView(_ collectionView: UICollectionView,
                                 indexPath: IndexPath,
                                 sectionData:RPCollectionViewSectionItem,
                                 cellData:RPCollectionViewCellItem) {
        
    }
}

//构建数据类型协议
protocol RPCollectionViewCellDataDelegate:NSObjectProtocol
{
    func setData(data:RPCollectionViewCellItem,delegate:RPCollectionViewCellEventDelegate,indexPath:IndexPath)
}

class RPCollectionViewAdapter: NSObject {
    //数据源
    public var dataSourceArray: [AnyObject]{
        didSet {
            jungleData()
        }
    }
    
    //事件代理
    weak var delegate:RPCollectionViewCellEventDelegate?
    
    lazy var reuseSet: NSMutableSet = {
        var reuseSet = NSMutableSet.init()
        return reuseSet
    }()
    
    private var isExistedSectionDatas = Bool()
    
    override init() {
        self.dataSourceArray = []
        super.init()
    }
    
    private func jungleData() {
        let xx = dataSourceArray.first
        isExistedSectionDatas = xx is  RPCollectionViewSectionItem
    }
    
    func reuseIdentifierForCellClass(cellClass:AnyClass,collectionView:UICollectionView) -> String {
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
    
    func reuseIdentifierForReusableViewClass(reusableView:AnyClass,collectionView:UICollectionView,forSupplementaryViewOfKind kind: String) -> String {
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

extension RPCollectionViewAdapter:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RPCollectionViewCellEventDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isExistedSectionDatas{
            return dataSourceArray.count
        }
        return 1
    }
    
    //cell数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExistedSectionDatas{
            let yy = dataSourceArray[section] as! RPCollectionViewSectionItem
            return yy.cellDatas.count
        }
        return dataSourceArray.count
    }
    
    //cell显示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item = RPCollectionViewCellItem()
        if isExistedSectionDatas {
            let sectionDatas = dataSourceArray[indexPath.section] as! RPCollectionViewSectionItem
            item = sectionDatas.cellDatas[indexPath.row]
        }else{
            item = dataSourceArray[indexPath.row] as! RPCollectionViewCellItem
        }
        let identifier = reuseIdentifierForCellClass(cellClass: item.cellClass, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        (cell as! RPCollectionViewCellDataDelegate).setData(data: item, delegate: self,indexPath: indexPath)
        return cell
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var sectionDatas = RPCollectionViewSectionItem()
        var item = RPCollectionViewCellItem()
        if isExistedSectionDatas {
            sectionDatas = dataSourceArray[indexPath.section] as! RPCollectionViewSectionItem
            item = sectionDatas.cellDatas[indexPath.row]
        }else{
            item = dataSourceArray[indexPath.row] as! RPCollectionViewCellItem
        }
        //调用代理方法
        if delegate != nil{
            delegate?.didSelectCollectionView(collectionView, indexPath: indexPath, sectionData: sectionDatas, cellData: item)
        }
    }
    
    //返回自定义HeadView或者FootView，我这里以headview为例
    private func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if isExistedSectionDatas {
            let sectionDatas = dataSourceArray[indexPath.section] as! RPCollectionViewSectionItem
            if kind == UICollectionView.elementKindSectionHeader{
                let id = reuseIdentifierForReusableViewClass(reusableView: sectionDatas.sectionHeaderView, collectionView: collectionView, forSupplementaryViewOfKind: kind)
                let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath as IndexPath)
                return v
            }
        }
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var item = RPCollectionViewCellItem()
        if isExistedSectionDatas {
            let sectionDatas = dataSourceArray[indexPath.section] as! RPCollectionViewSectionItem
            item = sectionDatas.cellDatas[indexPath.row]
        }else{
            item = dataSourceArray[indexPath.row] as! RPCollectionViewCellItem
        }
        return item.cellSize
    }
}

class RPCollectionViewSectionItem: NSObject {
    //cell数据
    var cellDatas:[RPCollectionViewCellItem] = [RPCollectionViewCellItem]()
    
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

class RPCollectionViewCellItem: NSObject {
    //cell
    var cellClass = UICollectionViewCell.self
    //cell对应的数据
    var cellData = NSObject()
    //cell上的操作事件合集
    var cellEventActions = [Selector]()
    //size
    var cellSize = CGSize()
}
