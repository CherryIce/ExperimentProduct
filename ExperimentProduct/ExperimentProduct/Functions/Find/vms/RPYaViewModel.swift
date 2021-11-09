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
        let tt = ["表格适配器","🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫", "沙某", "河马"]
        for i in tt {
            let model = RPYaModel.init()
            model.title = i
            let cellItem = RPTableViewCellItem.init()
            cellItem.cellClass = RPYaCell.self
            cellItem.cellh = 60
            cellItem.cellData = model
            item.cellDatas.append(cellItem)
        }
        success([item])
//        failed(NSError.init())
    }
}
