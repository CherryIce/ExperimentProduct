//
//  RPCycleView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/4.
//

import UIKit

//复杂的效果可以自己写flowLayout 也可以直接用：https://github.com/WenchaoD/FSPagerView

protocol RPCycleViewDelegate: NSObjectProtocol {
    
    // 图片点击
    func didSelectItemAt(cycleView: RPCycleView,  index: Int)
    
    // 图片自动滚动
    func autoScrollingItemAt(cycleView: RPCycleView,  index: Int)
    
    // 自定义Cell
    func cycleView(cycleView: RPCycleView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell?
}

extension RPCycleViewDelegate {
    func didSelectItemAt(cycleView: RPCycleView,  index: Int){}
    func autoScrollingItemAt(cycleView: RPCycleView,  index: Int){}
    func cycleView(cycleView: RPCycleView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell?{return nil}
}

class RPCycleView: UIView {

    // collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var pageControl:RPPageControl = {
        let pageControl = RPPageControl.init()
        pageControl.cornerRadius = 3
        pageControl.dotHeight = 6
        pageControl.dotSpace = 10
        pageControl.currentDotWidth = 12
        pageControl.otherDotWidth = 6
        pageControl.otherDotColor = RPColor.init(hexString: "#CCCCCC")
        pageControl.currentDotColor = RPColor.init(hexString: "#FF0066")
        self.addSubview(pageControl)
        return pageControl
    }()
    
    // 定时器
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: autoScrollDelay, target: self, selector: #selector(updateCollectionViewAutoScrolling), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }()
    
    // 代理
    public weak var delegate: RPCycleViewDelegate?
    
    // 自动播放时间 默认3秒
    open var autoScrollDelay: TimeInterval = 3
    
    // 默认图
    open var placeholderImage: UIImage?
    
    // 默认大小
    open var itemSize: CGSize?
    
    /**
     - 展示图片数组
     - 支持本地图片和网络图片，根据图片名是否以“http”开头自动识别
     */
    open var pictures: [String] = [] {
        didSet {
            // 没有图片时，不处理
            guard pictures.count != 0 else { return }
            // 通过oldValue是否有值，判别页面刷新时是否需要赋值，防止每次刷新页面又从第一张图开始滚动
            guard oldValue.count == 0 else { return }
            xxxx()
        }
    }
    
    func xxxx() {
        collectionView.reloadData()
        // 图片数量大于1时可以滑动
        collectionView.isScrollEnabled = pictures.count > 1
        // 滚动到中间位置
        let indexPath: IndexPath = IndexPath(item: pictures.count, section: 0)
        
        if #available(iOS 14.0, *) {
            let attributes = collectionView.layoutAttributesForItem(at: indexPath)
            let x = attributes?.frame.origin.x ?? 0
            let y = attributes?.frame.origin.y ?? 0
            collectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
        }else{
            collectionView.scrollToItem(at: indexPath, at:.centeredHorizontally , animated: false)
        }
        
        if pictures.count > 1 {
            timer.fireDate = Date(timeIntervalSinceNow: autoScrollDelay)
        } else {
            // 防止列表滚动时复用
            timer.fireDate = Date.distantFuture
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if itemSize?.width == 0 || itemSize?.height == 0 {
            itemSize = bounds.size
        }
        collectionView.frame = bounds
        
        pageControl.numberOfPages = pictures.count
        pageControl.frame.size = CGSize(width: 200, height: 20)
        pageControl.center.x = self.bounds.size.width * 0.5
        pageControl.frame.origin.y = collectionView.frame.maxY - 20
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        timer.invalidate()
    }
    
    deinit {
        timer.invalidate()
    }
}

extension RPCycleView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return pictures.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell = delegate?.cycleView(cycleView: self, collectionView: collectionView, cellForItemAt: indexPath)
        if collectionCell != nil {
            return collectionCell!
        }
        
        let identifier =  RPCollectionViewAdapter().reuseIdentifierForCellClass(cellClass:RPCycleViewCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPCycleViewCell
        cell.setCellData(pictures[indexPath.item % pictures.count], placeholderImage: placeholderImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(cycleView: self, index: indexPath.item % pictures.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize ?? bounds.size
    }
}

// MARK: - 循环轮播实现
extension RPCycleView {
    
    // 定时器方法，更新Cell位置
    @objc private func updateCollectionViewAutoScrolling() {
        if let indexPath = collectionView.indexPathsForVisibleItems.last {
            let nextPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            if indexPath.item + 1 < pictures.count * 2 {
                if #available(iOS 14.0, *) {
                    let attributes = collectionView.layoutAttributesForItem(at: nextPath)
                    let x = attributes?.frame.origin.x ?? 0
                    let y = attributes?.frame.origin.y ?? 0
                    collectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: true)
                }else{
                    collectionView.scrollToItem(at: nextPath, at:.centeredHorizontally , animated: true)
                }
            } else {}
        }
    }
    
    // 开始拖拽时,停止定时器
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    // 结束拖拽时,恢复定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = Date(timeIntervalSinceNow: autoScrollDelay)
    }
    
    /**
     - 监听手动减速完成(停止滚动)
     - 1.collectionView的cell显示两倍数量的图片，展示图片分为两组，默认显示第二组的第一张
     - 2.左滑collectionView到第二组最后一张，即最后一个cell时，设置scrollView的contentOffset显示第一组的最后一张，继续左滑，实现了无限左滑
     - 3.右滑collectionView到第一组第一张，即第一cell时，设置scrollView的contentOffset显示第二组的第一张，继续右滑，实现了无限右滑
     - 4.由2，3实现无限循环
     */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / bounds.size.width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if page == 0 {
            // 第一页
            collectionView.contentOffset = CGPoint(x: offsetX + CGFloat(pictures.count) * bounds.size.width, y: 0)
        } else if page == itemsCount - 1 {
            // 最后一页
            collectionView.contentOffset = CGPoint(x: offsetX - CGFloat(pictures.count) * bounds.size.width, y: 0)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(collectionView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var page = Int(offsetX / bounds.size.width+0.5)
        page = page % pictures.count
        if pageControl.currentPage != page {
            pageControl.currentPage = page
        }
        delegate?.autoScrollingItemAt(cycleView: self, index: page)
    }
}

fileprivate class RPCycleViewCell: UICollectionViewCell {
    
    // 图片控件
    private lazy var imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgView = UIImageView.init()
//        imgView.contentMode = .scaleAspectFit
        addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imgView = UIImageView.init()
        addSubview(imgView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = bounds
    }
    
    func setCellData(_ picture:String,placeholderImage:UIImage?){
        if picture.hasPrefix("http") {
            imgView.setImageWithURL(picture, placeholder:(placeholderImage ?? UIImage.init(color:RPColor.ShallowColor))!)
        } else {
            imgView.image = UIImage(named: picture) ?? placeholderImage
        }
    }
}
