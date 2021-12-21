//
//  RPNearViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit
import AsyncDisplayKit

//同城 周边
class RPNearViewController: RPBaseViewController {

    private var pageIndex = 1
    private lazy var labelArray = [String]()
    private lazy var dataArray = [RPFollowModel]()
    private lazy var topCollectionView = UICollectionView()
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
        node.showsVerticalScrollIndicator = false
        node.backgroundColor = RPColor.ShallowColor
        node.allowsSelection = true
        node.dataSource = self
        node.delegate = self
        node.leadingScreensForBatching = 2
        initUI()
        configuration()
        labelArray = ["拍照", "下午茶", "甜品屋", "酒吧","舞蹈"]
    }
    
    func initUI () {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height:80)
        
        topCollectionView = UICollectionView(frame: CGRect(x: 0, y: -100, width: SCREEN_WIDTH, height: 100), collectionViewLayout: layout)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.backgroundColor = .white
        topCollectionView.showsVerticalScrollIndicator = false
        topCollectionView.alwaysBounceHorizontal = true
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.register(RPShareViewCell.self, forCellWithReuseIdentifier: "cell")
        node.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        node.view.addSubview(topCollectionView)
    }
    
    private func configuration() {
        //下拉刷新
        node.view.refreshIdentifier = "RPRefreshHeader"
        node.view.expiredTimeInterval = 20.0
        let xx = RPRefreshHeader.init(frame: CGRect.zero)
        xx.ignore = 100//适配collectionview添加headerview这种特殊情况
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

extension RPNearViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPShareViewCell.self, collectionView: collectionView), for: indexPath) as! RPShareViewCell
        cell.imgV.image = .init(color: RPColor.ShallowColor)?.roundCorners(cornerRadius: 4)
        cell.title.text = labelArray[indexPath.item]
        cell.title.font = .systemFont(ofSize: 14)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            
        }
    }
}

extension RPNearViewController: ASCollectionDataSource, ASCollectionDelegate {
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
}

extension RPNearViewController:MosaicCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        let item = self.dataArray[originalItemSizeAtIndexPath.item]
        if item.title.count > 0 {
            let label = UILabel.init()
            label.frame = CGRect.init(x: 0, y: 0, width: (SCREEN_WIDTH - 30)/2, height: 20)
            label.numberOfLines = 2
            label.text = item.title
            label.sizeToFit()
            item.contentH = CGFloat(ceilf(Float(label.frame.size.height)))
        }
        return CGSize(width: (SCREEN_WIDTH - 30)/2, height: item.cellH+item.contentH)
    }
}


