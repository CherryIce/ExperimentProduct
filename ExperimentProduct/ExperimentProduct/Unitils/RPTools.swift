//
//  RPTools.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit
import CommonCrypto

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kLastVersionKey = "kLastVersionKey"
let kTokenExpDateTime = "kTokenExpDateTime"
let kADLaunchCacheKey = "kADLaunchCacheKey"

class RPTools: NSObject {
    
    //导航栏高度
    open class var NAV_HEIGHT : CGFloat {
        get {
            return IS_IPHONEX ? 88 : 64
        }
    }
    
    //屏幕高
    open class var IS_IPHONEX : Bool {
        get {
            if #available(iOS 11.0, *) {
                return  UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0 > 0.0
            }else{
                return false
            }
        }
    }
    
    //底部空隙
    open class var BottomPadding : CGFloat {
        get {
            if IS_IPHONEX {
                return  32
            }else{
                return 0
            }
        }
    }
    
    //totast样式
    open class var RPToastStyle : ToastStyle {
        get {
            var style = ToastStyle()
            style.messageFont = UIFont.systemFont(ofSize: 14)
            style.messageColor = .white
            style.messageAlignment = .center
            style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            style.cornerRadius = 4
            style.horizontalPadding = 15
            style.verticalPadding = 15
            return style
        }
    }
    
    //通过文件名获取png图片
    public static func getPngImage(forResource: String) -> UIImage {
        let path = Bundle.main.path(forResource: forResource, ofType: "png")!
        let image = RPImage.init(contentsOfFile: path)!
        return image
    }
    
    //计算字符串宽高
    class func calculateTextSize(_ text:String,size:CGSize,font:UIFont) -> CGSize  {
        let rect: CGRect = text.boundingRect(with: size, options: NSStringDrawingOptions.init(rawValue: 0) , attributes: [NSAttributedString.Key.font:font], context: nil) as CGRect
        return rect.size
    }
    
    //view -> image
    class func snapshot(_ view:UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //控制器获取
    open class var topViewController: UIViewController? {
        return topViewController(of: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    open class func topViewController(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topViewController(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topViewController(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topViewController(of: childViewController)
            }
        }
        
        return viewController
    }
    
    //生成二维码
    class func creatQRCodeImage(text: String,logoImage:UIImage?) -> UIImage{
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //还原滤镜的默认属性
        filter?.setDefaults()
        //设置需要生成二维码的数据
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //从滤镜中取出生成的图片
        let ciImage = filter?.outputImage
        //调整清晰度
        let bgImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size:SCREEN_WIDTH)
        
        //5.嵌入LOGO
        //5.1开启图形上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //5.2将二维码的LOGO画入
        bgImage.draw(in: CGRect.init(x: 0, y: 0, width: bgImage.size.width, height: bgImage.size.height))
        
        if logoImage != nil {
            let centerW = bgImage.size.width * 0.25
            let centerH = centerW
            let centerX = (bgImage.size.width-centerW)*0.5
            let centerY = (bgImage.size.height-centerH)*0.5
            logoImage?.draw(in: CGRect.init(x: centerX, y: centerY, width: centerW, height: centerH))
            //5.3获取绘制好的图片
            let finalImg = UIGraphicsGetImageFromCurrentImageContext()
            //5.4关闭图像上下文
            UIGraphicsEndImageContext()
            return finalImg!
        }
        return bgImage
    }
    
    //根据CIImage生成指定大小的高清UIImage
    class func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        let scaledImage: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: scaledImage)
    }
    
    //获取当前版本
    class func getVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    //去设置
    static func jumpToSystemPrivacySetting() {
        guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appSetting)
        }
    }
}

extension UIView {
    func layercornerRadius(cornerRadius:CGFloat) {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    
    func layercornerBorder(borderWidth:CGFloat,borderColor:UIColor) {
        let layer = self.layer
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = false
    }
    
    func layerRoundedRect(byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize){
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

public extension String {
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }
}

var codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
extension UIButton {
    //倒计时启动
    func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        var remainingCount: Int = count {
            willSet {
                setTitle("\(newValue)s", for: .normal)
                if newValue <= 0 {
                    setTitle("获取验证码", for: .normal)
                }
            }
        }

        if codeTimer.isCancelled {
            codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        }

        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))

        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }

    //取消倒计时
    func countdownCancel() {
        if !codeTimer.isCancelled {
            codeTimer.cancel()
        }

        // 返回主线程
        DispatchQueue.main.async {
            self.isEnabled = true
            if self.titleLabel?.text?.count != 0
            {
                self.setTitle("获取验证码", for: .normal)
            }
        }
    }
}
