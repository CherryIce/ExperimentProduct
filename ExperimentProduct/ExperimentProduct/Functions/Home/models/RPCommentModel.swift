//
//  RPCommentModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit

final class RPCommentsModel: NSObject {
    let username: String
    let text: String

    init(username: String, text: String) {
        self.username = username
        self.text = text
    }
}

extension RPCommentsModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "comment"/*(username + text)*/ as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
