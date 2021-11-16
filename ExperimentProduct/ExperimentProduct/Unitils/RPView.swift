//
//  RPView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/16.
//

import UIKit

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

