//
//  ImageViewExtension.swift
//
//  ImageHelper
//  Version 3.2.2
//
//  Created by Melvin Rivera on 7/23/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public extension UIImageView {
    
    /**
     Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.
     
     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter fadeIn: Weather the mage should fade in.
     - Parameter closure: Returns the image from the web the first time is fetched.
     
     - Returns A new image
     */
    func imageFromURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil)
    {
        self.image = UIImage.image(fromURL: url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.fade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }
    
    func setImageWithURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil) {
        if url.isEmpty {
            self.image = placeholder
            return
        }
        let cahce =  RPCache.shared.cache
        if cahce?.object(forKey: url) != nil {
            self.image = cahce?.object(forKey: url) as? UIImage
        }else{
            self.imageFromURL(url, placeholder: placeholder, fadeIn: fadeIn, shouldCacheImage: false) { (image) in
                DispatchQueue.main.async {
                    cahce?.setObject(image, forKey: url)
                }
            }
        }
    }
    
    //em... 感觉不是很好用的样子
    func setImageWithName(_ name:String,cornerRadius:CGFloat = 0) {
        if name.isEmpty {
            return
        }
        
        DispatchQueue.global().async {
            
            guard let image = UIImage.loadImage(name) else {
                DispatchQueue.main.async {
                    self.image = nil
                }
                return
            }
            
            guard let cgImage = image.cgImage else {
                DispatchQueue.main.async {
                    self.image = nil
                }
                return
            }
            
            let alphaInfo = CGImageAlphaInfo(rawValue: cgImage.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
            
            var hasAlpha = false
            
            if (alphaInfo == .premultipliedLast ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .last ||
                alphaInfo == .first) {
                hasAlpha = true
            }
            
            let tmpAlphaInfo = hasAlpha ? CGImageAlphaInfo.premultipliedFirst : CGImageAlphaInfo.noneSkipFirst
            var bitmapInfo:UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
            bitmapInfo = CGBitmapInfo(rawValue:tmpAlphaInfo.rawValue).rawValue
            
            let width = cgImage.width
            let height = cgImage.height
            
            guard let context = CGContext(data: nil,width: width,height: height,bitsPerComponent: 8,bytesPerRow: 0,space: CGColorSpaceCreateDeviceRGB(),bitmapInfo: bitmapInfo) else {
                DispatchQueue.main.async {
                    self.image = image.roundCorners(cornerRadius: cornerRadius)
                }
                return
            }
        
            context.draw(cgImage, in: CGRect(x: 0,y: 0,width:width,height:height))
            
            guard let newCgImage = context.makeImage() else {
                DispatchQueue.main.async {
                    self.image = image.roundCorners(cornerRadius: cornerRadius)
                }
                return
            }
            
            let newImage = UIImage(cgImage: newCgImage)
            
            DispatchQueue.main.async {
                self.image = newImage.roundCorners(cornerRadius: cornerRadius)
            }
        }
    }
}
 
