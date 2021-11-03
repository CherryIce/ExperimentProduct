//
//  RPFindHeaderView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/17.
//

import UIKit

protocol RPFindHeaderViewDelegate:NSObjectProtocol
{
    func clickLabelNeedFix(_ index:Int,data:AnyObject?)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPFindHeaderViewDelegate {
    func clickLabelNeedFix(_ index:Int,data:AnyObject?) {
        
    }
}

class RPFindHeaderView: UIView{
    
    weak var delegate:RPFindHeaderViewDelegate?
    
    var bannerView = UIView()
    
    lazy var collectionView :UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        self.addSubview(collectionView)
        
        adapter.c_delegate = self
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        return collectionView
    }()
    
    public var dataSourceArray: [AnyObject]{
        didSet {
            let tt = NSMutableArray.init()
            let width = (SCREEN_WIDTH - 16*6)/5
            let height = CGFloat(58)
            for i in 0...4 {
                let item = RPCollectionViewCellItem.init()
                let dd = RPPosterModel.init()
                dd.imgUrlPath = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i]
                item.cellData = dd
                item.cellClass = RPPosterCell.self
                item.cellSize = CGSize.init(width: width, height: height)
                tt.add(item)
            }
            adapter.dataSourceArray = tt as [AnyObject]
            collectionView.reloadData()
        }
    }
    
    private lazy var adapter = RPCollectionViewAdapter()
    
    override init(frame: CGRect) {
        dataSourceArray = []
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        dataSourceArray = []
        super.init(coder: coder)
    }
}

extension RPFindHeaderView : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        if delegate != nil {
            delegate?.clickLabelNeedFix(indexPath.item, data: cellData)
        }
    }
}
