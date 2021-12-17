//
//  RPASDKViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/17.
//

import UIKit
import AsyncDisplayKit

class RPASDKViewController: ASDKViewController<ASCollectionNode> {
    private var pageIndex = 1
    private lazy var dataArray = [RPFollowModel]()
    private lazy var viewModel  = RPNiceViewModel()
    override init() {
        let flowLayout = UICollectionViewFlowLayout.init()
        super.init(node:ASCollectionNode(collectionViewLayout: flowLayout))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        node.allowsSelection = false
        node.dataSource = self
        node.delegate = self
        node.leadingScreensForBatching = 2.5
        navigationController?.hidesBarsOnSwipe = true
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
                dataArray = datas
                node.reloadData()
                pageIndex += 1
            }else{
                var indexPaths:[IndexPath] = []
                for i in 0 ..< datas.count {
                    dataArray.append(datas[i])
                    let indexPath:IndexPath = IndexPath(row: dataArray.count-1, section: 0)
                    indexPaths.append(indexPath)
                }
                pageIndex += 1
                if indexPaths.count > 0 {
                    node.insertItems(at: indexPaths)
                }
            }
        } failed: { (error) in
            
        }
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
        log.debug("点击事件无效 我不理解  Click event is invalid, I don’t understand")
//        let cellNode:RPNiceCellNode = RPNiceCellNode(model: self.dataArray[indexPath.item])
        let type = indexPath.item%2 == 0 ? RPDynamicViewControllerType.pictures : RPDynamicViewControllerType.video
        let x = RPDynamicController.init()
        x.type = type
        x.data = [self.dataArray[indexPath.item]]
//        x.transitionView = RPTools.snapshot(cellNode)
        self.customPresent(x, animated: true)
    }
}
