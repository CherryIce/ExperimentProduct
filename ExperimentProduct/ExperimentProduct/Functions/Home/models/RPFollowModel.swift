//
//  RPFollowModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import HandyJSON

class RPFollowModel: NSObject,HandyJSON{
    var imageList:[RPImageModel] = []
    var comments:[RPCommentModel]  = []
    var type = "" //类型 图片 视频
    var title = "" //主题
    var desc = "" //描述
    var keywords = "" //#标签🏷
    var datePublished = ""
    var uploadDate = ""
    var likes:Int = 0
    var isLiked:Bool = false
    var author = RPUserModel()
    var cover =  RPImageModel()
    
    var contentH:CGFloat = 0
    var cellH:CGFloat = 0
    
    required override init() {}
}

extension RPFollowModel:ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}
