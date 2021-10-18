//
//  RPFindNewsLinkCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit
import TYPagerController

class RPFindNewsLinkCell: UITableViewCell{
    
    var indexPath = IndexPath()
    var datas = NSArray()
    var fromIndex = Int()
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var titles: [String] = []{
        didSet {
            tabBar.reloadData()
        }
    }
    
    private lazy var tabBar: TYTabPagerBar = {
        let tabBar = TYTabPagerBar()
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        tabBar.layout.cellEdging = 10
        tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: 14)
        tabBar.layout.selectedTextFont = UIFont.boldSystemFont(ofSize: 14)
        tabBar.layout.normalTextColor = RPColor.lightGray
        tabBar.layout.selectedTextColor = RPColor.MainColor
        tabBar.layout.progressColor = RPColor.MainColor
        tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
        return tabBar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fromIndex = 0
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func setData(data: RPTableViewCellItem,
                 titles: [String],
                 indexPath:IndexPath) {
        self.indexPath = indexPath
        if data.cellData is NSArray {
            datas = data.cellData as! NSArray
            
            self.titles = titles
            collectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RPFindNewsLinkCell:TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        cell.titleLabel.text = titles[index]
        return cell
    }
    
    func numberOfItemsInPagerTabBar() -> Int {
        return datas.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = titles[index]
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        if fromIndex == index {
            return
        }
        tabBar.scrollToItem(from: fromIndex, to: index, animate: true)
        fromIndex = index
        let indexP = IndexPath.init(row: Int(index), section: 0)
        if #available(iOS 14.0, *) {
            let attributes = collectionView.layoutAttributesForItem(at: indexP)
            let x = attributes?.frame.origin.x ?? 0
            let y = attributes?.frame.origin.y ?? 0
            collectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
        }else{
            collectionView.scrollToItem(at: indexP, at:UICollectionView.ScrollPosition.centeredHorizontally , animated: false)
        }
    }
}

extension RPFindNewsLinkCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //cell数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    //cell显示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datas[indexPath.row] as! RPCollectionViewCellItem
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: item.cellClass, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        (cell as! RPListCellDataDelegate).setCellData(cellData: item, delegate: self, indexPath: indexPath)
        return cell
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width,
                           height: collectionView.frame.size.height)
    }
}

extension RPFindNewsLinkCell:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let collectionV = scrollView as! UICollectionView
            for i in collectionV.visibleCells {
                for j in 0 ..< (i.gestureRecognizers?.count ?? 0) {
                    let x = i.gestureRecognizers?[j]
                    x?.state = .failed
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if (scrollToScrollStop) {
            scrollViewDidEndScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            let dragToDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating;
            if (dragToDragStop) {
                scrollViewDidEndScroll(scrollView)
            }
        }
    }
    
    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let index = roundf(Float(scrollView.contentOffset.x / scrollView.bounds.size.width))
        if fromIndex == Int(index) {
            return
        }
        tabBar.scrollToItem(from: fromIndex, to: Int(index), animate: true)
        fromIndex = Int(index)
        let indexP = IndexPath.init(row: Int(index), section: 0)
        if #available(iOS 14.0, *) {
            let attributes = collectionView.layoutAttributesForItem(at: indexP)
            let x = attributes?.frame.origin.x ?? 0
            let y = attributes?.frame.origin.y ?? 0
            collectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
        }else{
            collectionView.scrollToItem(at: indexP, at:UICollectionView.ScrollPosition.centeredHorizontally , animated: false)
        }
    }
}

extension RPFindNewsLinkCell : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView, indexPath: IndexPath, sectionData: AnyObject, cellData: AnyObject) {
        //collectionView点击cell回调
    }
}
