//
//  RPZeroDistanceFooter.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/13.
//

import UIKit
import ESPullToRefresh

class RPZeroDistanceFooter: UIView , ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public var view: UIView {
        return self
    }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 0.5
    public var executeIncremental: CGFloat = 0.5
    public var state: ESRefreshViewState = .pullToRefresh
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        switch state {
        case .refreshing :
            break
        case .autoRefreshing :
            break
        case .noMoreData:
            break
        default:
            break
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
