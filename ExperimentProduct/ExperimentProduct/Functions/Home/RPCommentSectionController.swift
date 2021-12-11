//
//  RPCommentSectionController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/10.
//

import UIKit
import IGListKit

class RPCommentSectionController: ListSectionController {
    var model: RPFollowModel!
    
    override init() {
        super.init()
        inset = .zero
    }

    override func numberOfItems() -> Int {
        return self.model.comments.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let height = collectionContext?.containerSize.height,let width = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: width, height: height/CGFloat(self.model.comments.count))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: RPUserCommentCell.self, withReuseIdentifier: "RPUserCommentCell", for: self, at: index) as? RPUserCommentCell else { fatalError() }
        let a = self.model.comments[index]
        cell.bindViewModel(a)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.model = object as? RPFollowModel
    }
    
    override func didSelectItem(at index: Int) {
        
    }
}
