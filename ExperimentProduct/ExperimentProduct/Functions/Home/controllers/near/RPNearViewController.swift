//
//  RPNearViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit

//同城 周边
class RPNearViewController: RPBaseViewController {

    private var pageIndex = 1
    private lazy var labelArray = [String]()
    private lazy var dataArray = [RPFollowModel]()
    private lazy var topCollectionView = UICollectionView()
    private lazy var collectionView = UICollectionView()
    private lazy var viewModel  = RPNiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        configuration()
        refreshUI()
        labelArray = ["拍照", "下午茶", "甜品屋", "酒吧","舞蹈"]
    }
    
    func initUI () {
        let flowLayout = RPNiceCollectionViewLayout.init()
        flowLayout.delegate = self
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
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
        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(topCollectionView)
    }
    
    private func configuration() {
        //下拉刷新
        collectionView.refreshIdentifier = "RPRefreshHeader"
        collectionView.expiredTimeInterval = 20.0
        let xx = RPRefreshHeader.init(frame: CGRect.zero)
        xx.ignore = 100//适配collectionview添加headerview这种特殊情况
        collectionView.es.addPullToRefresh(animator: xx) { [weak self] in
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
                    dataArray.append(datas[i])
                    let indexPath = NSIndexPath.init(row: dataArray.count-1, section: 0)
                    indexPaths.add(indexPath)
                }
                if pageIndex >= 10 {
                    collectionView.es.noticeNoMoreData()
                }
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

extension RPNearViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return labelArray.count
        }
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPShareViewCell.self, collectionView: collectionView), for: indexPath) as! RPShareViewCell
            cell.imgV.image = .init(color: RPColor.RandomColor)?.roundCorners(cornerRadius: 4)
            cell.title.text = labelArray[indexPath.item]
            cell.title.font = .systemFont(ofSize: 14)
            return cell
        }
        let cell : RPNicePicCell = collectionView.dequeueReusableCell(withReuseIdentifier: RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPNicePicCell.self, collectionView: collectionView), for: indexPath) as! RPNicePicCell
        cell.model = self.dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! RPNicePicCell
            let type = indexPath.item%2 == 0 ? RPDynamicViewControllerType.pictures : RPDynamicViewControllerType.video
            let x = RPDynamicController.init()
            x.type = type
            x.data = [self.dataArray[indexPath.item]]
            x.transitionView = cell.converImgV
            self.customPresent(x, animated: true)
        }
    }
}

extension RPNearViewController : RPNiceCollectionViewLayoutDelegate {
    func waterFlowLayout(layout: RPNiceCollectionViewLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        let item : RPFollowModel = self.dataArray[indexPath.item]
        return item.cellH
    }
}

