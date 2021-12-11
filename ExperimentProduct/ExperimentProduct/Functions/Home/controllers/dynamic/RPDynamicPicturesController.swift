//
//  RPDynamicPicturesController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit

class RPDynamicPicturesController: ListBindingSectionController<RPFollowModel>,ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let author = object?.author else { fatalError() }
        let view = self.collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, class: RPDynamicPicHeaderCell.self, at: index) as! RPDynamicPicHeaderCell
        view.bindViewModel(author)
        view.cellAction = {[weak self] (xCell,type) in
            guard let self = self else {
                return
            }
            self.action(xCell, type: type)
        }
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: width, height: RPTools.NAV_HEIGHT)
    }
    
    lazy var adapter: ListAdapter = {
        let a = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        a.dataSource = self
        return a
    }()
    
    override init() {
        super.init()
        dataSource = self
        supplementaryViewSource = self
    }
}

extension RPDynamicPicturesController:ListBindingSectionControllerDataSource {
    
    //分割数据源
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? RPFollowModel else { fatalError() }
        var results = [ListDiffable]()
        for comment in object.comments {
            let vm = RPExpandCommentModel.init(username: comment.username, text: comment.text)
            results.append(vm)
        }
        return object.imageList+results
    }
    
    //每个部分对应的cell
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        //注意保证此处的identifier和model协议里面的相同
        let identifier: String
        let cellClass: AnyClass
        switch viewModel {
        case is RPImageViewModel: identifier = "image";cellClass = RPFollowCollectionViewCell.self
        case is RPExpandCommentModel: identifier = "ExpandComment";cellClass = RPDynamicCommentCell.self
        default: identifier = "action";cellClass = RPFollowActionCell.self
        }
        guard let cell = collectionContext?.dequeueReusableCell(of: cellClass, withReuseIdentifier: identifier, for: self, at: index) else { fatalError() }
        if cell is RPFollowCollectionViewCell {
            let imgCell = cell as! RPFollowCollectionViewCell
            adapter.collectionView = imgCell.collectionView
        }
        return cell as! (ListBindable & UICollectionViewCell)
    }
    
    //每块区域的高度
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is RPImageViewModel: height = SCREEN_WIDTH
        case is RPExpandCommentModel: height = 35
        default: height = 50
        }
        return CGSize(width: width, height: height)
    }
}

extension RPDynamicPicturesController:ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [object!]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let x = RPListSectionController()
        x.browser = true
        return x
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension RPDynamicPicturesController {
    func action(_ cell:UICollectionViewCell,type:RPDynamicViewEventType) {
        switch type {
        case.dismiss:
            self.viewController?.dismiss(animated: true, completion: nil)
            break
        case .share:
            let share = RPShareViewController.init(title: nil, dataArray: [[RPShareItem.shareToWeChat(),RPShareItem.shareToWechatCircle()]]) { (indexPath) in
                log.debug(indexPath)
            }
            self.viewController?.present(share, animated: true, completion: nil)
            break
        case .commit:
            break
        case .like:
            break
        case .collect:
            break
        case .browser:
            break
        case .look:
            break
        case .follow:
            break
        }
    }
}
