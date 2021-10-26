//
//  RPTools.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit
import CommonCrypto
import YYCache

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

    //获取缓存地址
    public static func getCache() -> YYCache? {
        let cache = YYCache.init(name: "/RPCache")
        return cache
    }
}

extension UIView {
    func layercornerRadius(cornerRadius:CGFloat) {
        let layer = self.layer;
        layer.masksToBounds = true;
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false;
    }
    
    func layercornerBorder(borderWidth:CGFloat,borderColor:UIColor) {
        let layer = self.layer;
        layer.masksToBounds = true;
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = false;
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
