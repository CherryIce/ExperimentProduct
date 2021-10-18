//
//  RPFindViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPFindViewModel: NSObject {
    
    func getFindLists(params:NSDictionary,
                      success:(_ datas: NSArray)->(),
                      failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        let arr = NSMutableArray.init()
        for j in 0 ..< 2 {
            let item = RPTableViewSectionItem.init()
            item.sectionHeaderData = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户"] as NSObject
            let cell = RPTableViewCellItem.init()
            let cc = NSMutableArray.init()
            for i in 0 ..< 8 {
                if j == 0 {
                    let item = RPCollectionViewCellItem.init()
                    let dd = RPPosterModel.init()
                    dd.imgUrlPath = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i]
                    item.cellData = dd
                    item.cellClass = RPNewsLinkCell.self
                    cc.add(item)
                }else{
                    let item = RPCollectionViewCellItem.init()
                    let dd = RPPosterModel.init()
                    dd.imgUrlPath = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i]
                    item.cellData = dd
                    item.cellClass = RPFindCardCell.self
                    cc.add(item)
                }
            }
            cell.cellData = cc
            cell.cellh = CGFloat(60 * cc.count + 40)
            cell.cellClass = RPFindNewsLinkCell.self
            item.cellDatas.append(cell)
            arr.add(item)
        }
        success(arr)
        
//        failed(NSError.init())
    }
}
