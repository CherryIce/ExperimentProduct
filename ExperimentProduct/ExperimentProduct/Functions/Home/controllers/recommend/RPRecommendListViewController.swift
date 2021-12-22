//
//  RPRecommendListViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit
import AsyncDisplayKit

class RPRecommendListViewController: RPBaseViewController {
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
    var itemSizeWidth = (SCREEN_WIDTH - 30)/2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        node.showsVerticalScrollIndicator = false
        node.backgroundColor = RPColor.ShallowColor
        node.allowsSelection = true
        node.dataSource = self
        node.delegate = self
        node.leadingScreensForBatching = 2
        //上滑隐藏导航栏
        //navigationController?.hidesBarsOnSwipe = true
        configuration()
    }
    
    private func configuration() {
        //下拉刷新
        node.view.refreshIdentifier = "RPRefreshHeader"
        node.view.expiredTimeInterval = 20.0
        let xx = RPRefreshHeader.init(frame: CGRect.zero)
        node.view.es.addPullToRefresh(animator: xx) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.pageIndex = 1
                self?.refreshUI(nil)
            }
        }
    }
    
    func refreshUI (_ context: ASBatchContext?) {
        viewModel.getNicesLists(params: NSDictionary.init()) { (datas) in
            DispatchQueue.main.async {
                self.node.view.es.stopPullToRefresh()
                self.node.view.es.stopLoadingMore()
                if self.pageIndex == 1 {
                    self.node.view.es.resetNoMoreData()
                    self.dataArray.removeAll()
                    //下拉刷新需要保证释放原来的
                    self.node.reloadData()
                }
                var indexPaths:[IndexPath] = []
                for i in 0 ..< datas.count {
                    self.dataArray.append(datas[i])
                    let indexPath:IndexPath = IndexPath(row:self.dataArray.count-1, section: 0)
                    indexPaths.append(indexPath)
                }
                self.pageIndex += 1
                if indexPaths.count > 0 {
                    self.node.insertItems(at: indexPaths)
                }
                context?.completeBatchFetching(true)
            }
        } failed: { (error) in
            DispatchQueue.main.async {
                context?.completeBatchFetching(true)
            }
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

extension RPRecommendListViewController: ASCollectionDataSource, ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    //    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    //        return RPNiceCellNode(model: self.dataArray[indexPath.item])
    //    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let nodeBlock: ASCellNodeBlock = {
            let node = RPNiceCellNode(model: self.dataArray[indexPath.item])
            return node
        }
        return nodeBlock
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
    
    //可以在这里设置上拉条件 无限上拉就直接返回true就OK
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        refreshUI(context)
    }
    
    //fix iOS 13 shows bugs below , Maybe it's caused by irregular layout. Let's deal with it like this for now. **RPNiceCellNode**
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let item = self.dataArray[indexPath.item]
        item.contentH = caucalContentHeight(item.title)
        return ASSizeRange.init(min: CGSize(width: itemSizeWidth, height: 100), max: CGSize(width: itemSizeWidth, height: item.cellH+item.contentH))
    }
}

extension RPRecommendListViewController:MosaicCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        let item = self.dataArray[originalItemSizeAtIndexPath.item]
        item.contentH = caucalContentHeight(item.title)
        return CGSize(width: itemSizeWidth, height: item.cellH+item.contentH)
    }
}

extension RPRecommendListViewController {
    func caucalContentHeight(_ content:String) -> CGFloat {
        if content.isEmpty {
            return 0.0
        }
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: itemSizeWidth - 20, height: 20)
        label.numberOfLines = 2
        label.text = content
        label.sizeToFit()
        return CGFloat(ceilf(Float(label.frame.size.height)))
    }
}
