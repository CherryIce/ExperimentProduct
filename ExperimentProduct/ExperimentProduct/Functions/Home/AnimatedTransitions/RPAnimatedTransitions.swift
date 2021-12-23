//
//  RPAnimatedTransitions.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit

enum RPDynamicAnimatedTransitionsType {
    case present
    case dismiss
    case push
    case pop
}

class RPDynamicAnimatedTransitions: UIPercentDrivenInteractiveTransition {
    var type = RPDynamicAnimatedTransitionsType.present
    var durations:TimeInterval = 0.25
    
    func scaleAspectFitImageViewWithImage(_ image:UIImage) -> CGSize {
        var  imageSize = image.size
        
        let w_rate = imageSize.width/UIScreen.main.bounds.size.width
        let h_rate = imageSize.height/UIScreen.main.bounds.size.width
        
        if (w_rate > h_rate) {
            imageSize.width = UIScreen.main.bounds.size.width
            imageSize.height /= w_rate
        }
        
        if (w_rate < h_rate) {
            imageSize.width  /= h_rate;
            imageSize.height = UIScreen.main.bounds.size.width
        }
        
        if (w_rate == h_rate) {
            imageSize.width = UIScreen.main.bounds.size.width
            imageSize.height = UIScreen.main.bounds.size.width
        }
        
        return imageSize
    }
}

extension RPDynamicAnimatedTransitions : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durations
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch type {
        case .present:
            let toViewController = transitionContext.viewController(forKey: .to) as!RPDynamicController
            let containerView = transitionContext.containerView
            let duration:TimeInterval = self.transitionDuration(using: transitionContext)
            
            let view = toViewController.transitionView
            if view == nil {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            
            //cell在view上的位置
            let cell_frame = containerView.convert((toViewController.transitionView?.superview!.superview!.frame)!, from: (toViewController.transitionView?.superview!.superview!.superview!)!)
            let size = toViewController.transitionView?.frame.size ?? CGSize.zero
            let conver_frame = CGRect.init(x: cell_frame.origin.x, y: cell_frame.origin.y, width: size.width, height: size.height)
            let presentingImageView = UIImageView.init(frame: conver_frame)
            if view is UIImageView {
                let tt:UIImageView = view as! UIImageView
                presentingImageView.image = tt.image
            }else{
                presentingImageView.image = RPTools.snapshot(view!)
            }
            presentingImageView.contentMode = view!.contentMode
            presentingImageView.clipsToBounds = view!.clipsToBounds
            presentingImageView.layer.cornerRadius = view!.layer.cornerRadius
            
            view?.isHidden = true
            //添加目标控制器view
            toViewController.view.alpha = 0
            containerView.addSubview((toViewController.view)!)
            
            //添加imageView
            containerView.addSubview(presentingImageView)
            
            UIView.animate(withDuration: duration) {
                if toViewController.type == .pictures {
                    //图片类型的
                    presentingImageView.frame = CGRect.init(x:0, y: RPTools.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
                }else{
                    //视频类型的 应该是按封面图比对应屏幕显示的区域计算来的
                    presentingImageView.frame = CGRect.init(x:0, y: RPTools.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                }
            } completion: { (finished) in
                toViewController.view.alpha = 1
                presentingImageView.isHidden = true
                toViewController.transitionView?.superview?.isHidden = true//zz
                presentingImageView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
            
            break
        case .dismiss:
            let fromVC = transitionContext.viewController(forKey: .from) as! RPDynamicController
            let  containerView = transitionContext.containerView
            let snapShotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            snapShotView!.frame = containerView.convert(fromVC.view.frame, from: fromVC.view)
            fromVC.view.isHidden = true
            
            fromVC.transitionView?.isHidden = true
            fromVC.view.alpha = 1
            containerView.addSubview(fromVC.view)
            containerView.addSubview(snapShotView!)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions(rawValue: 0)) {
                fromVC.view.alpha = 0
                //cell在view上的位置
                let frame = containerView.convert((fromVC.transitionView?.superview!.superview!.frame)!, from: (fromVC.transitionView?.superview!.superview!.superview!)!)
                let size = fromVC.transitionView?.frame.size ?? CGSize.zero
                snapShotView?.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: size.width, height: size.height)
            } completion: { (finished) in
                snapShotView?.removeFromSuperview()
                fromVC.view.isHidden = false
                fromVC.transitionView?.isHidden = false
                fromVC.transitionView?.superview?.isHidden = false//zz
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            break
        case .push:
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            
            let containerView = transitionContext.containerView
            
            let toView = toVC?.view//transitionContext.view(forKey: UITransitionContextViewKey.to)
            
            containerView.addSubview(toView!)
            var frame = toView?.frame ?? .zero
            frame.origin.x = SCREEN_WIDTH
            toView?.frame = frame
            
            let durationN = self.transitionDuration(using: transitionContext)
        
            //usingSpringWithDamping弹力系数
            UIView.animate(withDuration: durationN, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {() -> Void in
                frame.origin.x = 0
                toView?.frame = frame
            }, completion: ({(Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }))
            break
        case .pop:
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            
            let containerView = transitionContext.containerView
            let fromView = fromVC?.view
            
            containerView.addSubview(fromView!)
            var frame = fromView?.frame ?? .zero
            frame.origin.x = 0
            fromView?.frame = frame
            
            let durationN = self.transitionDuration(using: transitionContext)
        
            UIView.animate(withDuration: durationN, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {() -> Void in
                frame.origin.x = SCREEN_WIDTH
                fromView?.frame = frame
            }, completion: ({(Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }))
            break
        }
    }
}

extension UIViewController:UIViewControllerTransitioningDelegate{
    func customPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
        viewControllerToPresent.transitioningDelegate = self
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //如果是多效果 根据presented不同 指定不同动画效果
        if presented is RPDynamicController {
            let transition = RPDynamicAnimatedTransitions()
            transition.type = .present
            return transition
        }else if (presented is RPMeidDetailViewController) {
            let transition = RPDynamicAnimatedTransitions()
            transition.type = .push
            transition.durations = 0.5
            return transition
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is RPDynamicController {
            let transition = RPDynamicAnimatedTransitions()
            transition.type = .dismiss
            return transition
        }else if (dismissed is RPMeidDetailViewController) {
            let transition = RPDynamicAnimatedTransitions()
            transition.type = .pop
            transition.durations = 0.5
            return transition
        }
        return nil
    }
}
