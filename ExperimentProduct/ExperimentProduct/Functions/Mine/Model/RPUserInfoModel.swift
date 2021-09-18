//
//  RPUserInfoModel.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/18.
//

import UIKit
import RxDataSources

struct RPUserInfoModel {
    var title: String
    var imgsrc: String
    var replyCount: String
    var source: String
    var imgnewextra: [Imgnewextra]?
}

struct Imgnewextra {
    var imgsrc: String
}

//自定义Section
struct SettingSection {
    var header: String
    var items: [RPUserInfoModel]
}

extension SettingSection : SectionModelType {
    typealias Item = RPUserInfoModel
    
    var identity: String {
        return header
    }
    
    init(original: SettingSection, items: [RPUserInfoModel]) {
        self = original
        self.items = items
    }
}
