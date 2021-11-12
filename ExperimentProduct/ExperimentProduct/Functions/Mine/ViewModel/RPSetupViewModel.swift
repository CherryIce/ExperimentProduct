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
        let currentVersion = RPTools.getVersion()
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
    
    func getAccountData(params:NSDictionary,
                        success:(_ datas: NSArray)->(),
                        failed:(_ error: NSError)->()) {
        let xx = ["账号","密码","隐私"]
        let yy = ["一般是手机号","已设置/未设置",""]
        let item = RPTableViewSectionItem.init()
        for i in 0..<xx.count {
            let model = RPYaModel.init()
            model.title = xx[i]
            model.detail = yy[i]
            let cellItem = RPTableViewCellItem.init()
            cellItem.cellClass = RPYaCell.self
            cellItem.cellh =  60
            cellItem.cellData = model
            item.cellDatas.append(cellItem)
        }
        success([item])
    }
}
