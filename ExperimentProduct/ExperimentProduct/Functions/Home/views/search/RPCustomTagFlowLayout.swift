//
//  RPCustomTagFlowLayout.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit

protocol RPCustomTagFlowLayoutDelegate : NSObjectProtocol {
    func getCollectionVIewHeight(H:CGFloat)
}

class RPCustomTagFlowLayout: UICollectionViewFlowLayout {
    
    var delegate:RPCustomTagFlowLayoutDelegate?
    var maximumInteritemSpacing: CGFloat = 10
    override func prepare() {
        super.prepare()
        self.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        //使用系统帮我们计算好的结果
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        //第0个cell没有上一个cell，所以从1开始
        for i in 1..<attributes.count {
            let curAttr = attributes[i]
            let preAttr = attributes[i-1]
            
            let origin = preAttr.frame.maxX
            //根据maximumInteritemSpacing计算出的新的x位置
            let targetX = origin + maximumInteritemSpacing
            //只有系统计算的间距大于maximumInteritemSpacing时才进行调整
            if curAttr.frame.minX > targetX {
                // 换行时不用调整
                if targetX + curAttr.frame.width < collectionViewContentSize.width {
                    var frame = curAttr.frame
                    frame.origin.x = targetX
                    curAttr.frame = frame
                }
            }
            
            if i == attributes.count-1 {
                self.delegate?.getCollectionVIewHeight(H: curAttr.frame.maxY)
            }
        }
        return attributes
    }
}
