//
//  RPPicturesDynamicView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit

class RPPicturesDynamicView: UIView {
    weak var delegate:RPDynamicViewEventDelegate?
    // 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    // 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    private var imageView = UIImageView()
    lazy var scrollView = UIScrollView()
    lazy var headerView = RPPicturesDynamicHeaderView()
    lazy var tableView = UITableView()
    var model = RPNiceModel() {
        didSet {
            headerView.dataArray = model.imgs
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    func creatUI() {
        scrollView = UIScrollView.init()
        self.addSubview(scrollView)

        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        tableView.addGestureRecognizer(pan)

        headerView = RPPicturesDynamicHeaderView.init()
        tableView.tableHeaderView = headerView

        headerView.delegate = self

        imageView = UIImageView.init()
        imageView.isHidden = true
        scrollView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        headerView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        tableView.frame = bounds
        imageView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc open func onPan(_ pan: UIPanGestureRecognizer) {
        guard headerView.pageControl.currentPage == 0 else {
            return
        }
        switch pan.state {
        case .began:
            imageView.isHidden = false
            imageView.image = RPTools.snapshot(tableView)
            tableView.isHidden = true
            beganFrame = imageView.frame
            beganTouch = pan.location(in: scrollView)
        case .changed:
            let result = panResult(pan)
            imageView.frame = result.frame
            self.superview!.alpha = result.scale * result.scale
        case .ended, .cancelled:
            imageView.isHidden = true
            tableView.isHidden = false
            imageView.frame = panResult(pan).frame
            let isDown = pan.velocity(in: self).y > 0
            if isDown {
                if (self.delegate != nil){
                    self.delegate?.clickEventCallBack(.dismiss,0)
                }
            } else {
                self.superview!.alpha = 1.0
                imageView.frame = self.bounds
            }
        default:
            imageView.frame = self.bounds
        }
    }

    // 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)

        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))

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

extension RPPicturesDynamicView : UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只处理pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if tableView.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
    }
}

extension RPPicturesDynamicView: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(type, index)
        }
    }
}

extension RPPicturesDynamicView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPDynamicCommentCell.self, tableView: tableView), for: indexPath) as! RPDynamicCommentCell
        return cell
    }
}

class RPPicturesDynamicCell: UICollectionViewCell {
    var imgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)

        imgV = UIImageView.init()
        imgV.contentMode = .scaleAspectFill//scaleAspectFit
        self.addSubview(imgV)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imgV.frame = self.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

