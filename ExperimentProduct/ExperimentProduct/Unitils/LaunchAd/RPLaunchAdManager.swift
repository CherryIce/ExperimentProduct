//
//  RPLaunchAdManager.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/22.
//

import UIKit

class RPLaunchAdManager: NSObject {
    
    static let shared = RPLaunchAdManager()
    
    private var window = UIWindow()
    
    private override init() {
        super.init()
//        NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue:nil) { (note) in
//            self.setLauchAd()
//        }
    }
    
    func setLauchAd() {
        RPGCDTimer.start(1, 3) { (isFinish) in
            if isFinish {
                for v in self.window.subviews {
                    v.removeFromSuperview()
    //                    v = nil
                }
                self.window.isHidden = true
    //                window = nil
            }
        }
        let object = RPTools.getCache()?.objectForKey(key: kADLaunchCacheKey)
        if object == nil {
            //请求嘛
        }
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController.init()
        window.rootViewController?.view.backgroundColor = .clear
        window.rootViewController?.view.isUserInteractionEnabled = false
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.isHidden = false
        window.alpha = 1
        window.addSubview(RPLaunchImageView.init(frame: CGRect.zero))
    }
}

class RPGCDTimer: NSObject {
    
    static var codeTimer: DispatchSourceTimer?
    
    class func start(_ timeInterval: TimeInterval = 1,_ totolTimeInterval: TimeInterval = Double(MAXFLOAT), animation: @escaping (_ isFinish: Bool)->()){
        
        var timeCount = totolTimeInterval
        
        RPGCDTimer.codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        RPGCDTimer.codeTimer?.schedule(deadline: .now(), repeating: timeInterval)
        
        var isFinish = false
        
        RPGCDTimer.codeTimer?.setEventHandler(handler: {
            
            timeCount = timeCount - timeInterval
            
            if timeCount == 0 {
                RPGCDTimer.codeTimer?.cancel()
                isFinish = true
            }
            
            DispatchQueue.main.async {
                animation(isFinish)
            }
        })
        RPGCDTimer.codeTimer?.resume()
    }
    
    class func stop() {
        RPGCDTimer.codeTimer?.cancel()
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


