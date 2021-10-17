//
//  RPPosterViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPPosterViewModel: NSObject {
    
    func getTitleLabel(params:NSDictionary,
                       success:(_ datas: NSArray)->(),
                       failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        success(["一叶子","维生素","玻尿酸","爽肤水"])
    }
    
    func getPosterLists(params:NSDictionary,
                        success:(_ datas: NSArray)->(),
                        failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        let tt = NSMutableArray.init()
        let width = (SCREEN_WIDTH - 16*4)/3
        let height = width*3/2
        for i in 0...10 {
            let item = RPCollectionViewCellItem.init()
            let dd = RPPosterModel.init()
            dd.imgUrlPath = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i]
            item.cellData = dd
            item.cellClass = RPPosterCell.self
            item.cellSize = CGSize.init(width: width, height: height)
            tt.add(item)
        }
        success(tt)
    }
}
