//
//  RPSetupViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPSetupViewModel: NSObject {
    func getSetupData(params:NSDictionary,
                      success:(_ datas: NSArray)->(),
                      failed:(_ error: NSError)->()) {
        var tt = [RPTableViewSectionItem]()
        let xx = [["账户与安全","反馈建议","当前版本","隐私协议","清除缓存"],["关于"]]
        let xxs = [["accountAction", "feedbackAction","","privcyAction","clearCacheAction"], ["aboutAction"]]
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let xxss = [["", "",currentVersion+"版本","",RPCache.shared.calculateCacheSize()], [""]]
        for i in 0..<xx.count {
            let item = RPTableViewSectionItem.init()
            item.sectionHeaderH = 10
            let yy = xx[i]
            for j in 0..<yy.count {
                let model = RPYaModel.init()
                model.title = yy[j]
                model.detail = xxss[i][j] ?? ""
                model.clickAction = xxs[i][j]
                model.needArrow = (j != 2 && j != 4) ? true : false
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
