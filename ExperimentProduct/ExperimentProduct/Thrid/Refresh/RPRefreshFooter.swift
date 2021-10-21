//
//  RPRefreshFooter.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/20.
//

import UIKit
import ESPullToRefresh

class RPRefreshFooter: UIView , ESRefreshProtocol, ESRefreshAnimatorProtocol{
    
    public let loadingMoreDescription: String = "Loading more"
    public let noMoreDataDescription: String  = "没有更多数据了"
    public let loadingDescription: String     = "Loading..."
    
    public var view: UIView {
        return self
    }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 48.0
    public var executeIncremental: CGFloat = 48.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let activityIndicatorView: NVActivityIndicatorView = {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero,
                                                            type: .audioEqualizer)
        activityIndicatorView.color = RPColor.MainColor
        return activityIndicatorView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(activityIndicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        titleLabel.isHidden = true
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        titleLabel.isHidden = false
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        switch state {
        case .refreshing :
            titleLabel.text = loadingDescription
            break
        case .autoRefreshing :
            titleLabel.text = loadingDescription
            break
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
            break
        default:
            titleLabel.text = loadingMoreDescription
            break
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.bounds
        activityIndicatorView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                                  y: self.bounds.size.height - 50.0,
                                                  width: 39.0,
                                                  height: 50.0)
    }
    
}
