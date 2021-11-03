//
//  RPPosterListViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit
import TABAnimated

class RPPosterListViewController: RPBaseViewController {
    
    private var pageIndex = Int()
    private lazy var dataArray = NSMutableArray()
    private lazy var collectionView = UICollectionView()
    private lazy var adapter = RPCollectionViewAdapter()
    private lazy var viewModel  = RPPosterViewModel()
    
    //分类类型 字符串或则id
    public var typeId: String = ""{
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        pageIndex = 1
        adapter.c_delegate = self
        initUI()
        configuration()
    }
    
    func initUI () {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let width = (SCREEN_WIDTH - 16*4)/3
        let height = width*3/2
        collectionView.tabAnimated = TABCollectionAnimated.init(cellClass: RPPosterCell.self, cellSize: CGSize.init(width: width, height: height))
        collectionView.tabAnimated?.canLoadAgain = true
    }
    
    private func configuration() {
        //开启动画
        collectionView.tab_startAnimation { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.refreshUI()
            }
        }
        
        //下拉刷新
        collectionView.refreshIdentifier = "RPRefreshHeader"
        collectionView.expiredTimeInterval = 20.0
        collectionView.es.addPullToRefresh(animator: RPRefreshHeader.init(frame: CGRect.zero)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.pageIndex = 1
                self?.refreshUI()
            }
        }
        
        //上拉加载
        collectionView.es.addInfiniteScrolling(animator: RPRefreshFooter.init(frame: CGRect.zero)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.refreshUI()
            }
        }
    }
    
    func refreshUI () {
        viewModel.getPosterLists(params: NSDictionary.init()) { (datas) in
            collectionView.es.stopPullToRefresh()
            collectionView.es.stopLoadingMore()
            if pageIndex == 1 {
                dataArray = NSMutableArray.init(array: datas)
                adapter.dataSourceArray = dataArray as [AnyObject]
                if self.isFirst {
                    // 停止动画,并刷新数据
                    collectionView.tab_endAnimationEaseOut()
                    self.isFirst = false
                }else{
                    collectionView.reloadData()
                }
                pageIndex += 1
            }else{
                let indexPaths = NSMutableArray.init()
                for i in 0 ..< datas.count {
                    dataArray.add(datas[i])
                    let indexPath = NSIndexPath.init(row: dataArray.count-1, section: 0)
                    indexPaths.add(indexPath)
                }
                if pageIndex >= 2 {
                    collectionView.es.noticeNoMoreData()
                }
                adapter.dataSourceArray = dataArray as [AnyObject]
                if indexPaths.count > 0 {
                    collectionView.insertItems(at: indexPaths as! [IndexPath])
                    UIView.performWithoutAnimation {
                        collectionView.reloadItems(at: indexPaths as! [IndexPath])
                    }
                }
            }
        } failed: { (error) in
            if self.isFirst {
                // 停止动画,并刷新数据
                collectionView.tab_endAnimationEaseOut()
                self.isFirst = false
            }else{
                collectionView.reloadData()
            }
        }
    }
}

extension RPPosterListViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView, indexPath: IndexPath, sectionData: AnyObject?, cellData: AnyObject?) {
        
    }
}
