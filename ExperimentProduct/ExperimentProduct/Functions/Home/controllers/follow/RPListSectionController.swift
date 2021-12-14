//
//  RPListSectionController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/10.
//

import UIKit
import IGListKit
import JXPhotoBrowser

class RPListSectionController: ListSectionController{
    
    var model: RPFollowModel!
    var browser:Bool = false
    
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
        cell.posterImgView.setImageWithURL(a.url, placeholder: UIImage(color: RPColor.ShallowColor)!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.model = object as? RPFollowModel
    }
    
    override func didSelectItem(at index: Int) {
        if browser {
            let browser = JXPhotoBrowser()
            browser.numberOfItems = {
                self.model.imageList.count
            }
            browser.reloadCellAtIndex = { context in
                let imageModel = self.model.imageList[context.index]
                let browserCell = context.cell as? JXPhotoBrowserImageCell
                browserCell?.index = context.index
                let collectionCell = self.collectionContext?.cellForItem(at: index, sectionController: self) as? RPPosterCell
                let placeholder = collectionCell?.posterImgView.image
                browserCell?.imageView.setImageWithURL(imageModel.url, placeholder: placeholder ?? UIImage.init())
            }
            browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
                let cell = self.collectionContext?.cellForItem(at: index, sectionController: self) as? RPPosterCell
                return cell?.posterImgView
            })
            browser.pageIndex = index
            browser.show()
        }
    }
}
