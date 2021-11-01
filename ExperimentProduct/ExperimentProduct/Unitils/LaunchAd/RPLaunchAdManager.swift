//
//  RPLaunchAdManager.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/22.
//

import UIKit

class RPLaunchAdManager: NSObject {
    
    static let shared = RPLaunchAdManager()
    private var window = UIWindow()
    private var skipButton = RPSkipButton()
    
    //设置广告
    func setLauchAd() {
        //3秒的停留
        let timer = RPTimer.init(interval: 1, queue: DispatchQueue.main, action: nil)
        timer.replaceOldAction { actions in
            DispatchQueue.main.async {
                if actions == 3 {
                    self.adFinished()
                    timer.cancel()
                }
            }
        }
        timer.start()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController.init()
        window.rootViewController?.view.backgroundColor = .clear
        window.rootViewController?.view.isUserInteractionEnabled = false
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.isHidden = false
        window.alpha = 1
        let imgV = RPLaunchImageView.init(frame: CGRect.zero)
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(pushToAdDetails))
        imgV.addGestureRecognizer(pan)
        window.addSubview(imgV)
        
        let object = RPCache.shared.cache?.object(forKey: kADLaunchCacheKey)
        if object != nil {
            timer.cancel()
            creatButton()
            imgV.image = object as? UIImage
        }
        
        //        //网络请求加缓存
        //        RPNetWorkManager.shared.provider.request(.adLaunch) { (respone) in
        //
        //        };
        imgV.imageFromURL("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg1.doubanio.com%2Fview%2Frichtext%2Flarge%2Fpublic%2Fp122617578.jpg&refer=http%3A%2F%2Fimg1.doubanio.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637733990&t=44048b827eb4c729ce27ecd49539d78c", placeholder: imgV.imageFromLaunchScreen()!, fadeIn: true, shouldCacheImage: false) { (image) in
            if image == nil {
                RPCache.shared.cache?.removeObject(forKey: kADLaunchCacheKey)
            }else{
                RPCache.shared.cache?.setObject(image, forKey: kADLaunchCacheKey, with: nil)
                //开始广告
                timer.cancel()
                self.creatButton()
            }
        }
    }
    
    //跳过按钮
    func creatButton() {
        if self.window.subviews.last is UIButton {
            skipButton.isHidden = false
        }else{
            let w = 60
            let p = 20
            skipButton = RPSkipButton.init(frame: CGRect.init(x: Int(SCREEN_WIDTH) - w - p, y: 2*p, width: w, height: w),
                                           totalDuration: 3,
                                           complete: { (finished) in
                if finished {
                    self.adFinished()
                }
            })
            skipButton.addTarget(self, action: #selector(adFinished), for: .touchUpInside)
            self.window.addSubview(skipButton)
            skipButton.layercornerRadius(cornerRadius: 30)
        }
    }
    
    //结束广告
    @objc func adFinished() {
        for v in self.window.subviews {
            v.removeFromSuperview()
            //                v = nil
        }
        self.window.isHidden = true
        //            self.window = nil
    }
    
    //广告详情
    @objc func pushToAdDetails() {
        //广告详情
        let wkweb = RPWkwebViewController.init()
        
        let ctl = UIApplication.shared.keyWindow?.rootViewController
        if ctl is RPMainTabBarViewController {
            let tab = ctl as! RPMainTabBarViewController
            let vc = tab.selectedViewController
            vc?.navigationController?.pushViewController(wkweb, animated: true)
        }
        if ctl is RPNavigationController {
            let nav = ctl as! RPNavigationController
            nav.pushViewController(wkweb, animated: true)
        }
        if ctl is RPBaseViewController {
            let vc = ctl as! RPBaseViewController
            let nav = RPNavigationController.init(rootViewController: vc)
            nav.pushViewController(wkweb, animated: true)
        }
    }
}

class RPLaunchImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.image = self.imageFromLaunchScreen()
    }
    
    func imageFromLaunchScreen() -> UIImage? {
        let UILaunchStoryboardName = Bundle.main.infoDictionary!["UILaunchStoryboardName"] as! String
        if UILaunchStoryboardName.count == 0 {
            return nil
        }
        let LaunchScreenSb = UIStoryboard.init(name: UILaunchStoryboardName, bundle: nil).instantiateInitialViewController()
        if LaunchScreenSb != nil {
            let v = LaunchScreenSb?.view
            // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
            var window:UIWindow? = UIWindow.init(frame: UIScreen.main.bounds)
            v?.frame = UIScreen.main.bounds
            window?.addSubview(v ?? UIView.init())
            window?.layoutIfNeeded()
            
            let image = self.imageFromView(view: v ?? UIView.init())
            window = nil
            return image
        }
        return nil;
    }
    
    func imageFromView(view:UIView) -> UIImage? {
        if view.frame.height == 0 || view.frame.width == 0 {
            return nil
        }
        let size = view.bounds.size
        //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RPSkipButton: UIButton {
    private var timeLabel  = UILabel()
    private var roundLayer = CAShapeLayer()
    private var totalDuration = Int()
    
    public typealias EndBlockCallBack = (_ finish:Bool)->()
    public var endblock: EndBlockCallBack?
    
    convenience init(frame: CGRect, totalDuration: Int,complete:@escaping EndBlockCallBack) {
        self.init(frame: frame)
        self.totalDuration = totalDuration
        self.endblock = complete
        creatUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func creatUI() {
        timeLabel = UILabel.init()
        timeLabel.frame = self.bounds
        timeLabel.textColor = .white
        timeLabel.text = "跳过"+" "+String(self.totalDuration)+"S"
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.addSubview(timeLabel)
        
        timeLabel.layercornerRadius(cornerRadius: frame.size.width/2)
        timeLabel.clipsToBounds = true
        
        roundLayer = CAShapeLayer.init()
        roundLayer.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        roundLayer.strokeColor = UIColor.white.cgColor
        roundLayer.lineCap = .round
        roundLayer.lineJoin = .round
        roundLayer.lineWidth = 5
        roundLayer.frame = timeLabel.frame
        roundLayer.path = UIBezierPath.init(arcCenter: CGPoint.init(x: timeLabel.frame.size.width/2,
                                                                    y: timeLabel.frame.size.height/2),
                                            radius: timeLabel.frame.size.width/2-1,
                                            startAngle: CGFloat(-0.5*Double.pi),
                                            endAngle: CGFloat(1.5*Double.pi) ,
                                            clockwise: true).cgPath
        roundLayer.strokeStart = 0
        timeLabel.layer.addSublayer(roundLayer)
        
        startTime()
    }
    
    func startTime() {
        //执行间隔0.1 所以先算总执行次数
        let dos = self.totalDuration*10
        let timer = RPTimer.init(interval: 0.1, queue: DispatchQueue.main, action: nil)
        timer.replaceOldAction { actions in
            DispatchQueue.main.async {
                if actions == dos {
                    if self.endblock != nil {
                        self.endblock?(true)
                    }
                    timer.cancel()
                }
                let progress = CGFloat(CGFloat(actions) / CGFloat(dos))
                self.roundLayer.strokeStart = progress
                if actions%10 == 0 {
                    self.timeLabel.text = "跳过"+" "+String(Int(self.totalDuration-actions/10))+"S"
                }
            }
        }
        timer.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


