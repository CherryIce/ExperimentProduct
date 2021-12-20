//
//  RPASDKViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPASDKViewController:RPBaseViewController   {
    private var pageIndex = 1
    private lazy var dataArray = [RPFollowModel]()
    private lazy var viewModel  = RPNiceViewModel()
    private lazy var node:ASCollectionNode = {
        let flowLayout = MosaicCollectionViewLayout()
        flowLayout.headerHeight = 0
        let node = ASCollectionNode(frame: view.bounds,collectionViewLayout: flowLayout)
        view.addSubview(node.view)
        flowLayout.delegate = self
        return node
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        node.allowsSelection = true
        node.dataSource = self
        node.delegate = self
        node.leadingScreensForBatching = 2.5
        //上滑隐藏导航栏
//        navigationController?.hidesBarsOnSwipe = true
        configuration()
        refreshUI()
    }
    
    private func configuration() {
        //下拉刷新
        node.view.refreshIdentifier = "RPRefreshHeader"
        node.view.expiredTimeInterval = 20.0
        let xx = RPRefreshHeader.init(frame: CGRect.zero)
        node.view.es.addPullToRefresh(animator: xx) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.pageIndex = 1
                self?.refreshUI()
            }
        }
        
        //上拉加载
        node.view.es.addInfiniteScrolling(animator: RPZeroDistanceFooter.init(frame: CGRect.zero)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self?.refreshUI()
            }
        }
    }
    
    func refreshUI () {
        viewModel.getNicesLists(params: NSDictionary.init()) { (datas) in
            node.view.es.stopPullToRefresh()
            node.view.es.stopLoadingMore()
            if pageIndex == 1 {
                node.view.es.resetNoMoreData()
            }
            var indexPaths:[IndexPath] = []
            for i in 0 ..< datas.count {
                dataArray.append(datas[i])
                let indexPath:IndexPath = IndexPath(row:dataArray.count-1, section: 0)
                indexPaths.append(indexPath)
            }
            pageIndex += 1
            if indexPaths.count > 0 {
                node.insertItems(at: indexPaths)
            }
        } failed: { (error) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        node.frame = view.bounds
    }
    
    deinit {
        node.delegate = nil
        node.dataSource = nil
    }
}

extension RPASDKViewController: ASCollectionDataSource, ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return RPNiceCellNode(model: self.dataArray[indexPath.item])
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        
        let cellNode = node.nodeForItem(at: indexPath) as! RPNiceCellNode
        let type = indexPath.item%2 == 0 ? RPDynamicViewControllerType.pictures : RPDynamicViewControllerType.video
        let x = RPDynamicController.init()
        x.type = type
        x.data = [self.dataArray[indexPath.item]]
        x.transitionView = cellNode.view
        self.customPresent(x, animated: true)
    }
}

extension RPASDKViewController:MosaicCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        let x = self.dataArray[originalItemSizeAtIndexPath.item]
        return CGSize(width: (SCREEN_WIDTH - 3 * 16)/2, height: x.cellH)
    }
}
