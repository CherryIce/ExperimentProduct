//
//  RPDynamicVideosController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit

//视频动态如果使用iglistkit来处理的话 other processes内存释放是个问题
class RPDynamicVideosController: ListBindingSectionController<RPFollowModel>,ListDisplayDelegate {
    //sectionController 将要出现
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    //sectionController 将要消失
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    //cell 将要出现
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
//        guard let cell = collectionContext?.dequeueReusableCell(of: RPVideoDynamicCell.self, withReuseIdentifier: "RPVideoDynamicCell", for: self, at: index) as? RPVideoDynamicCell else { fatalError() }
        
    }
    
    //cell 将要消失
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        guard let cell = collectionContext?.dequeueReusableCell(of: RPVideoDynamicCell.self, withReuseIdentifier: "RPVideoDynamicCell", for: self, at: index) as? RPVideoDynamicCell else { fatalError() }
        cell.pauseVideo()
    }
    
    override init() {
        super.init()
        dataSource = self
        displayDelegate = self
    }
}

extension RPDynamicVideosController:ListBindingSectionControllerDataSource {
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? RPFollowModel else { fatalError() }
        return [object]
    }
    
    //每个部分对应的cell
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        guard let cell = collectionContext?.dequeueReusableCell(of: RPVideoDynamicCell.self, withReuseIdentifier: "RPVideoDynamicCell", for: self, at: index) as? RPVideoDynamicCell else { fatalError() }
        let path = URL.init(string: "https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4".urlEncoded())!
        cell.delegate = self
        cell.path = path
        cell.playVideo()
        return cell as (ListBindable & UICollectionViewCell)
    }
    
    //每块区域的高度
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: width, height: SCREEN_HEIGHT)
    }
}

extension RPDynamicVideosController: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
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

