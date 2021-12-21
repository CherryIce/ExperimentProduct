//
//  RPMineViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPMineViewModel: NSObject {
    func getMeData(params:NSDictionary,
                   success:(_ datas: NSArray)->(),
                   failed:(_ error: NSError)->()) {
        var tt = [RPTableViewSectionItem]()
        let xx = [["支付中心"],["收藏", "活动中心"], ["设置"]]
        let xxs = [["payAction"],["collectAction", "activityAction"], ["setupAction"]]
        let imgs = [["balance"],["collect","xx"],["yy"]]
        for i in 0..<xx.count {
            let item = RPTableViewSectionItem.init()
            if i != 0 {
                item.sectionHeaderH = 10
            }
            let yy = xx[i]
            for j in 0..<yy.count {
                let model = RPYaModel.init()
                model.image = imgs[i][j]
                model.title = yy[j]
                model.clickAction = xxs[i][j]
                model.imgClickAction = "test"
                let cellItem = RPTableViewCellItem.init()
                cellItem.cellClass = RPYaCell.self
                cellItem.cellh = 60
                cellItem.cellData = model
                item.cellDatas.append(cellItem)
            }
            tt.append(item)
        }
        success(tt as NSArray)
    }
}
