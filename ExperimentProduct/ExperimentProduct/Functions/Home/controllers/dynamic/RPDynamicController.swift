//
//  RPDynamicController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit
import Moya

class RPDynamicController: RPBaseViewController {
    // 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    // 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    private var imageView = UIImageView()
    lazy var scrollView = UIScrollView()
    
    var transitionView:UIView?
    var type:RPDynamicViewControllerType = .pictures
    
    var data = [ListDiffable]()
    lazy var adapter: ListAdapter = {
        let a = ListAdapter(updater: ListAdapterUpdater(), viewController: self ,workingRangeSize:1)
        a.dataSource = self
        return a
    }()
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        return collectionView
    }()
    
    private lazy var viewModel = RPNiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView = UIScrollView.init()
        view.addSubview(scrollView)
        imageView = UIImageView.init()
        imageView.isHidden = true
        scrollView.addSubview(imageView)
        adapter.collectionView = collectionView
        
        if type == .pictures {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            pan.delegate = self
            collectionView.addGestureRecognizer(pan)
        }else{
            collectionView.backgroundColor = .black
            collectionView.isPagingEnabled = true
        }
        
        adapter.performUpdates(animated: true, completion: nil)
        
        //不好说实际效果应该怎样 一般情况这里的视频加载可能会出现两种操作
        //第一种是拿上一个页面获取到的数据中的所有视频用来展示 到最后一条之后才加载更多
        //第二种就是只拿一条过来展示 剩下的全是上拉加载获取而来 这样可能就需要提前预加载 每一次上拉都提前获取足够多的数据
        //可以做上拉  图片类型上拉获取的是更多评论  视频类型获取的是下一条视频
        configuration()
    }
    
    private func configuration() {
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
            if datas.count == 0 {
                collectionView.es.noticeNoMoreData()
                collectionView.reloadData()
            }else{
                let x = datas.first
                data.append(x!)
                adapter.performUpdates(animated: true,completion: nil)
            }
            
        } failed: { (error) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        scrollView.frame = view.bounds
        imageView.frame = view.bounds
    }
    
    @objc open func onPan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            imageView.isHidden = false
            imageView.image = RPTools.snapshot(self.view)?.roundedCornerImageWithCornerRadius(8)
            collectionView.isHidden = true
            beganFrame = imageView.frame
            beganTouch = pan.location(in: scrollView)
        case .changed:
            let result = panResult(pan)
            imageView.frame = result.frame
            //透明度
            view.backgroundColor = UIColor.black.withAlphaComponent(result.scale * result.scale)
//            view.alpha = result.scale * result.scale
        case .ended, .cancelled:
            imageView.isHidden = true
            collectionView.isHidden = false
            imageView.frame = panResult(pan).frame
            let isDown = pan.velocity(in: self.view).y > 0
            if isDown {
                self.dismiss(animated: true, completion: nil)
            } else {
                view.backgroundColor = .white
//                view.alpha = 1.0
                imageView.frame = view.bounds
            }
        default:
            imageView.frame = view.bounds
        }
    }

    // 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)

        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / view.bounds.height))

        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale

        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX

        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY

        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
}

extension RPDynamicController:ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if type == .pictures {
            return RPDynamicPicturesController()
        }
        return RPDynamicVideosController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension RPDynamicController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只处理pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self.view)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if collectionView.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
    }
}

