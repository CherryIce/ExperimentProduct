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
    func clickBannerNeedFix(_ index:Int)
}

//将协议里的可选方法放这里实现一遍就行了
extension RPFindHeaderViewDelegate {
    func clickLabelNeedFix(_ index:Int,data:AnyObject?) {}
}

class RPFindHeaderView: UIView{
    
    weak var delegate:RPFindHeaderViewDelegate?
    
    var bannerView = RPCycleView()
    
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
        
        bannerView = RPCycleView.init()
        bannerView.delegate = self
        bannerView.pictures = ["https://nim-nosdn.netease.im/MTY2Nzk0NTU=/bmltYV8xMzgzOTQ1OTEyM18xNTk3OTkwOTE0NjU4XzNlYTcwYjRiLWJiZjAtNDExOS1hOTBkLTAxYTgyNGJjYTVmOA==","https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1734913275,3830009060&fm=26&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2189728697,1720975443&fm=26&gp=0.jpg"]
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-90)
        }
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

extension RPFindHeaderView: RPCycleViewDelegate {
    
    func didSelectItemAt(cycleView: RPCycleView, index: Int) {
        if delegate != nil {
            delegate?.clickBannerNeedFix(index)
        }
    }
    
    func autoScrollingItemAt(cycleView: RPCycleView, index: Int) {
        
    }
    
//    func cycleView(cycleView: RPCycleView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
//        let identifier =  RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass:RPCycleViewCell.self, collectionView: collectionView)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPCycleViewCell
//        cell.setCellData(pictures[indexPath.item % pictures.count], placeholderImage: placeholderImage)
//        return cell
//    }
}
