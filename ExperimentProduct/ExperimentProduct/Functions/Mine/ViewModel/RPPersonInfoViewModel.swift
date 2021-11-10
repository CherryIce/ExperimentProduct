//
//  RPPersonInfoViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/10.
//

import UIKit
import SwiftyJSON
import HandyJSON

class RPPersonInfoViewModel: NSObject {
    //获取省市区信息
    func getProvincesData(params:NSDictionary,
                          success:@escaping(_ datas: NSArray)->(),
                          failed:@escaping(_ error: Error)->()) {
        RPNetWorkManager.shared.provider.request(.provinces) { (response) in
            switch response {
            case let .success(results):
                let json = JSON(results.data)
                if let imageArr = JSONDeserializer<RProvincesModel>.deserializeModelArrayFrom(json: json["provinces"]["province"].description) {
                    success(imageArr as NSArray)
                }
            case let .failure(error):
                failed(error)
            }
        }
    }
    
    func getInfoData(params:NSDictionary,
                     success:(_ datas: NSArray)->(),
                     failed:(_ error: NSError)->()) {
        let xx = ["大头贴","名字","id","性别","地区","生日","个人二维码","个性签名"]
        let item = RPTableViewSectionItem.init()
        for i in 0..<xx.count {
            let model = RPYaModel.init()
            model.image = i == 0 ? "wechat@2x" : ""
            model.title = xx[i]
            let cellItem = RPTableViewCellItem.init()
            cellItem.cellClass = RPYaCell.self
            cellItem.cellh = i == 0 ? 100 : 60
            cellItem.cellData = model
            item.cellDatas.append(cellItem)
        }
        success([item])
    }
}
