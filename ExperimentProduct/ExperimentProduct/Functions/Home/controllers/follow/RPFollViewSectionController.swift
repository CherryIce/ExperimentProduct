//
//  RPFollViewSectionController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit

class RPFollViewSectionController:ListBindingSectionController<RPFollowModel> {
    lazy var adapter: ListAdapter = {
        let a = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        a.dataSource = self
        return a
    }()
    
    lazy var adapter2: ListAdapter = {
        let a = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        a.dataSource = self
        return a
    }()
    
    override init() {
        super.init()
        dataSource = self
    }
}

extension RPFollViewSectionController:ListBindingSectionControllerDataSource {
    
    //分割数据源
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? RPFollowModel else { fatalError() }
        return [object.author]+object.imageList+[RPFollowActionModel(likes: object.likes)]+object.comments
    }
    
    //每个部分对应的cell
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        //注意保证此处的identifier和model协议里面的相同
        let identifier: String
        let cellClass: AnyClass
        switch viewModel {
        case is RPImageViewModel: identifier = "image";cellClass = RPFollowCollectionViewCell.self
        case is RPCommentsModel: identifier = "comment";cellClass = RPCommentViewCell.self
        case is RPUserModel: identifier = "user";cellClass = RPFollowUserCell.self
        default: identifier = "action";cellClass = RPFollowActionCell.self
        }
        guard let cell = collectionContext?.dequeueReusableCell(of: cellClass, withReuseIdentifier: identifier, for: self, at: index) else { fatalError() }
        if cell is RPFollowCollectionViewCell {
            let imgCell = cell as! RPFollowCollectionViewCell
            adapter.collectionView = imgCell.collectionView
        }else if cell is RPCommentViewCell {
            let com = cell as! RPCommentViewCell
            adapter2.collectionView = com.collectionView
        }
        return cell as! (ListBindable & UICollectionViewCell)
    }
    
    //每块区域的高度
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is RPImageViewModel: height = SCREEN_WIDTH
        case is RPCommentsModel: height = 70
        default: height = 50
        }
        return CGSize(width: width, height: height)
    }
}

extension RPFollViewSectionController:ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        guard let list = object?.imageList else { fatalError() }
//        var data = [ListDiffable]()
//        for obj in list {
//            data.append(obj)
//        }
        return [object!]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if listAdapter == adapter2 {
            return RPCommentSectionController()
        }
        return RPListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
