//
//  RPYaViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPYaViewModel: NSObject {
    
    func getYaData(params:NSDictionary,
                   success:(_ datas: NSArray)->(),
                   failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        let item = RPTableViewSectionItem.init()
        for i in 0...10 {
            let cellItem = RPTableViewCellItem.init()
            cellItem.cellClass = RPYaCell.self
            cellItem.cellh = 60
            cellItem.cellData = ["表格适配器","🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"][i] as NSObject
            item.cellDatas.append(cellItem)
        }
        success([item])
    }
}
