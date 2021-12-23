//
//  RPCommentModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import HandyJSON

class RPCommentModel: HandyJSON {
    //评论人
    var replyPerson = RPPersonModel()
    //被评论人
    var byReplyPerson = RPPersonModel()
    //评论内容
    var content = ""
    //时间
    var dateTime = ""
    required init() {}
}

extension RPCommentModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "comment"/*(username + text)*/ as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
