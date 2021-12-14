//
//  RPRecommendListViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit

//IGListKit 创建瀑布流也是可以的 参考示例Demo的StoryboardViewController
//但是瀑布流一般不会出现变化很大的复杂布局 所以这里就没测试更改了
class RPRecommendListViewController: RPBaseViewController {

    private var pageIndex = 1
    private lazy var dataArray = [RPFollowModel]()
    private lazy var collectionView = UICollectionView()
    private lazy var viewModel  = RPNiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        configuration()
        refreshUI()
    }
    
    func initUI () {
        let flowLayout = RPNiceCollectionViewLayout.init()
        flowLayout.delegate = self
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    private func configuration() {
        //下拉刷新
        collectionView.refreshIdentifier = "RPRefreshHeader"
        collectionView.expiredTimeInterval = 20.0
        collectionView.es.addPullToRefresh(animator: RPRefreshHeader.init(frame: CGRect.zero)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.pageIndex = 1
                self?.refreshUI()
            }
        }
        
        //上拉加载
        collectionView.es.addInfiniteScrolling(animator: RPZeroDistanceFooter.init(frame: CGRect.zero)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self?.refreshUI()
            }
        }
    }
    
    func refreshUI () {
        viewModel.getNicesLists(params: NSDictionary.init()) { (datas) in
            collectionView.es.stopPullToRefresh()
            collectionView.es.stopLoadingMore()
            if pageIndex == 1 {
                collectionView.es.resetNoMoreData()
                dataArray = datas 
                collectionView.reloadData()
                pageIndex += 1
            }else{
                let indexPaths = NSMutableArray.init()
                for i in 0 ..< datas.count {
                    dataArray.append(datas[i] )
                    let indexPath = NSIndexPath.init(row: dataArray.count-1, section: 0)
                    indexPaths.add(indexPath)
                }
//                if pageIndex >= 10 {
//                    collectionView.es.noticeNoMoreData()
//                }
                pageIndex += 1
                if indexPaths.count > 0 {
                    collectionView.insertItems(at: indexPaths as! [IndexPath])
                    UIView.performWithoutAnimation {
                        collectionView.reloadItems(at: indexPaths as! [IndexPath])
                    }
                }
            }
        } failed: { (error) in
            //collectionView.reloadData()
        }
    }

}

extension RPRecommendListViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : RPNicePicCell = collectionView.dequeueReusableCell(withReuseIdentifier: RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPNicePicCell.self, collectionView: collectionView), for: indexPath) as! RPNicePicCell
        cell.model = self.dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RPNicePicCell
        let type = indexPath.item%2 == 0 ? RPDynamicViewControllerType.pictures : RPDynamicViewControllerType.video
        let x = RPDynamicController.init()
        x.type = type
        x.data = [self.dataArray[indexPath.item]]
        x.transitionView = cell.converImgV
        self.customPresent(x, animated: true)
    }
}

extension RPRecommendListViewController : RPNiceCollectionViewLayoutDelegate {
    func waterFlowLayout(layout: RPNiceCollectionViewLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        let item : RPFollowModel = self.dataArray[indexPath.item]
        return item.cellH
    }
}
