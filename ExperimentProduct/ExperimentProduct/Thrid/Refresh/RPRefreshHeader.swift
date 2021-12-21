//
//  RPRefreshHeader.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/20.
//

import UIKit
import ESPullToRefresh

class RPRefreshHeader: UIView ,ESRefreshProtocol, ESRefreshAnimatorProtocol{

    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var ignore:CGFloat = 0.0//适配collectionview添加headerview这种特殊情况
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let activityIndicatorView: NVActivityIndicatorView = {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero,
                                                            type: .audioEqualizer)
        activityIndicatorView.color = RPColor.redWine
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(activityIndicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
//        activityIndicatorView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { [self] in
            self.activityIndicatorView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                               y: self.bounds.size.height - (ignore+50),
                                           width: 39.0,
                                          height: 50.0)


            }, completion: { (finished) in
                
                self.activityIndicatorView.startAnimating()
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
        }, completion: { (finished) in
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        activityIndicatorView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                      y: self.bounds.size.height - (50.0+ignore) * p,
                                      width: 39.0,
                                      height: 50.0 * p)
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            activityIndicatorView.stopAnimating()
            break
        case .releaseToRefresh:
            activityIndicatorView.startAnimating()
            break
        default:
            break
        }
    }

}
