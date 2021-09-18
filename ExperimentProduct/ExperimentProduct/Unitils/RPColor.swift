//
//  RPColor.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

class RPColor: UIColor {
    //主色调
    open class var  MainColor:UIColor {
        get{
            return UIColor.init(hexString: "#FF7700")
        }
    }
    //常用视图背景色
    open class var  MainViewBgColor:UIColor {
        get{
            return UIColor.init(hexString: "#FCFCFC")
        }
    }
    //常用分割线颜色
    open class var Separator:UIColor {
        get {
            return UIColor.init(hexString: "#F3F3F5")
        }
    }
    //浅色
    open class var ShallowColor:UIColor {
        get {
            return UIColor.init(hexString: "#F5F5F7")
        }
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

