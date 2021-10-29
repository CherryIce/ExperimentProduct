//
//  RPNiceCollectionViewLayout.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/29.
//

import UIKit

private let RPNiceDefalutColumnCount = 2
private let RPNiceDefalutColumnMargin = CGFloat(10)
private let RPNiceDefalutRowMargin = CGFloat(10)
private let RPNiceDefalutEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)

protocol RPNiceCollectionViewLayoutDelegate : NSObjectProtocol {
    func waterFlowLayout(layout : RPNiceCollectionViewLayout,indexPath : NSIndexPath,itemWidth : CGFloat) -> CGFloat
    func columnCountInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> Int
    func columnMarginInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> CGFloat
    func rowMarginInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> CGFloat
    func edgeInsetsInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> UIEdgeInsets
}

extension RPNiceCollectionViewLayoutDelegate {
    func columnCountInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> Int {
        return RPNiceDefalutColumnCount
    }
    
    func columnMarginInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> CGFloat {
        return RPNiceDefalutColumnMargin
    }
    
    func rowMarginInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> CGFloat {
        return RPNiceDefalutRowMargin
    }
    
    func edgeInsetsInWaterFlowLayout(layout : RPNiceCollectionViewLayout) -> UIEdgeInsets {
        return RPNiceDefalutEdgeInsets
    }
}

class RPNiceCollectionViewLayout: UICollectionViewFlowLayout {
    
    weak open var delegate : RPNiceCollectionViewLayoutDelegate?
    /*懒加载创建存放属性的数组*/
    fileprivate lazy var attrs : [UICollectionViewLayoutAttributes] = []
    fileprivate lazy var columnHeights : [CGFloat] = []
    fileprivate var contentHeight : CGFloat = 0
    
    fileprivate func columnCount() -> Int {
        if self.delegate != nil {
            return (self.delegate?.columnCountInWaterFlowLayout(layout: self))!
        }
        return RPNiceDefalutColumnCount
    }
    
    fileprivate func columnMargin() -> CGFloat {
        if self.delegate != nil {
            return (self.delegate?.columnMarginInWaterFlowLayout(layout: self))!
        }
        return RPNiceDefalutColumnMargin
    }
    
    fileprivate func rowMargin() -> CGFloat {
        if self.delegate != nil {
            return (self.delegate?.rowMarginInWaterFlowLayout(layout: self))!
        }
        return RPNiceDefalutRowMargin
    }
    
    fileprivate func edgeInsets() -> UIEdgeInsets {
        if self.delegate != nil {
            return (self.delegate?.edgeInsetsInWaterFlowLayout(layout: self))!
        }
        return RPNiceDefalutEdgeInsets
    }
    
    override func prepare() {
        super.prepare()
        
        if self.collectionView == nil {
            return
        }
        
        self.columnHeights.removeAll()
        self.contentHeight = 0
        
        for  _ in 0 ..< self.columnCount() {
            self.columnHeights.append(self.edgeInsets().top)
        }
        
        self.attrs.removeAll()
        let count : Int = (self.collectionView?.numberOfItems(inSection: 0))!
        let width : CGFloat = (self.collectionView?.frame.size.width)!
        let colMagin = (CGFloat)(self.columnCount() - 1) * self.columnMargin()
        
        let cellWidth : CGFloat = (width - self.edgeInsets().left - self.edgeInsets().right - colMagin) / CGFloat(self.columnCount())
        
        for i in 0 ..< count {
            // 设置indexPath,默认一个分区
            let indexPath : NSIndexPath = NSIndexPath(item: i, section: 0)
            let attr : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
            
            //获取高度
            let cellHeight : CGFloat =  (self.delegate?.waterFlowLayout(layout: self, indexPath: indexPath as NSIndexPath, itemWidth: cellWidth))!
            
            //找出最低的那个
            var minColumnHeight = self.columnHeights[0]
            var minColumn : Int = 0
            for i in 1 ..< self.columnCount() {
                let colHeight = self.columnHeights[i]
                
                if colHeight < minColumnHeight {
                    minColumnHeight = colHeight
                    minColumn = i
                }
            }
            
            let cellX : CGFloat = self.edgeInsets().left + CGFloat(minColumn) * (self.columnMargin() + cellWidth)
            var cellY = minColumnHeight
            if cellY != self.edgeInsets().top {
                cellY = self.rowMargin() + cellY
            }
            
            attr.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
            let maxY = cellY + cellHeight
            
            self.columnHeights[minColumn] = maxY
            let maxContentHeight = self.columnHeights[minColumn]
            if CGFloat(self.contentHeight) < CGFloat(maxContentHeight) {
                self.contentHeight = maxContentHeight
            }
            self.attrs.append(attr)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        var maxHeight = columnHeights[0]
        
        for i in 1 ..< self.columnCount() {
            let columnHeight = columnHeights[i]
            
            if maxHeight < columnHeight {
                maxHeight = columnHeight
            }
        }
        return CGSize.init(width: 0, height: self.contentHeight)//maxHeight + self.edgeInsets().bottom)
    }
    
    // 将设置好存放每个item的布局信息返回
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrs
    }
}
