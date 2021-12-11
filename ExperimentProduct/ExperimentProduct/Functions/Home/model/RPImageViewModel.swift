//
//  RPImageViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import HandyJSON

class RPImageViewModel: NSObject,HandyJSON {    
    //图片链接
    var url = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    required override init() {}
}

extension RPImageViewModel:ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "image" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? RPImageViewModel else { return false }
        return url == object.url
    }
}
