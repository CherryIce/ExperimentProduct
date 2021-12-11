//
//  RPUserModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import HandyJSON

class RPUserModel: NSObject,HandyJSON {
    
    var id = ""
    var officialVerified:Bool = false
    var type = "" //类型 个人/公司 or 普通/优质
    var name = ""
    var nickname = ""
    var image = "" //头像
    var url = "" //个人主页
    
    required override init() {}
}

extension RPUserModel : ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "user" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? RPUserModel else  { return false }
        return nickname == object.nickname
        && url == object.url
    }
}
