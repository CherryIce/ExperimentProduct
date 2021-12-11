//
//  RPListSectionController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/10.
//

import UIKit
import IGListKit

class RPListSectionController: ListSectionController{
    
    var model: RPFollowModel!
    
    override init() {
        super.init()
        inset = .zero
    }

    override func numberOfItems() -> Int {
        return self.model.imageList.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let height = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: height, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: RPPosterCell.self, withReuseIdentifier: "RPPosterCell", for: self, at: index) as? RPPosterCell else { fatalError() }
        let a = self.model.imageList[index]
        cell.posterImgView.setImageWithURL(a.url, placeholder: UIImage(color: RPColor.RandomColor)!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.model = object as? RPFollowModel
    }
    
    override func didSelectItem(at index: Int) {
        
    }
}
