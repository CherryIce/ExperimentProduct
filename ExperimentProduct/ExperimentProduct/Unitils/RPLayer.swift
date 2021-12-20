//
//  RPLayer.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/17.
//

import UIKit

class RPLayer: CALayer {
    //如果是自己写CALayer CATextLayer布局的话就需要考虑异步绘制
}

extension CALayer {
    
    func setImageWithURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil) {
        if url.isEmpty {
            self.contents = placeholder.resize(toSize: self.bounds.size)?.cgImage
            closure?(nil)
            return
        }
        let cahce =  RPCache.shared.cache
        let image = cahce?.object(forKey: url) as? UIImage
        guard image != nil else {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            if let nsURL = URL(string: url) {
                session.dataTask(with: nsURL, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        DispatchQueue.main.async {
                            closure?(nil)
                        }
                    }
                    if url.contains("webp") {
                        if let data = data, let image = UIImage.imageWithWebPData(imageData: data) {
                            DispatchQueue.main.async {
                                closure?(image)
                                cahce?.setObject(image, forKey: url)
                                self.contents = image.resize(toSize: self.bounds.size)?.cgImage
                            }
                        }
                    }else{
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                closure?(image)
                                cahce?.setObject(image, forKey: url)
                                self.contents = image.resize(toSize: self.bounds.size)?.cgImage
                            }
                        }
                    }
                    session.finishTasksAndInvalidate()
                }).resume()
            }
            return
        }
        self.contents = image?.resize(toSize: self.bounds.size)?.cgImage
        closure?(nil)
    }
    
    func layerRoundedRect(byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize){
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.mask = maskLayer
    }
}
