//
//  RPImage.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit

class RPImage: UIImage {
    //导航栏返回按钮图
    open class var NavBackImage : UIImage {
        get {
            return UIImage.init(named: "back")!
        }
    }
    //默认头像
    open class var UserAvatarImage : UIImage {
        get {
            return UIImage.init(named: "组 1894")!
        }
    }
    //无网络
    open class var NoNetworkImage : UIImage {
        get {
            return UIImage.init(named: "")!
        }
    }
    //无数据
    open class var NoDatasImage : UIImage {
        get {
            return UIImage.init(contentsOfFile: "")!
        }
    }
}

extension UIImage {
    //图片切圆
    func roundedCornerImageWithCornerRadius(_ cornerRadius:CGFloat) -> UIImage {
        let w = self.size.width
        let h = self.size.height

        var targetCornerRadius = cornerRadius
        if cornerRadius < 0 {
            targetCornerRadius = 0
        }

        if cornerRadius > min(w, h) {
            targetCornerRadius = min(w,h)
        }

        let imageFrame = CGRect(x: 0, y: 0, width: w, height: h)

        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        UIBezierPath(roundedRect: imageFrame, cornerRadius: targetCornerRadius).addClip()

        self.draw(in: imageFrame)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
 }
