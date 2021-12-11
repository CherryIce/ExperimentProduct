//
//  RPFollowActionModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit

class RPFollowActionModel: NSObject {
    let likes: Int

    init(likes: Int) {
        self.likes = likes
    }
}

extension RPFollowActionModel : ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "action" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? RPFollowActionModel else { return false }
        return likes == object.likes
    }
}
