//
//  RPExpandCommentModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit

class RPExpandCommentModel: NSObject {
    let username: String
    let text: String

    init(username: String, text: String) {
        self.username = username
        self.text = text
    }
}

extension RPExpandCommentModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return (username + text) as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
