//
//  RPDynamicViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit
import JXPhotoBrowser

class RPDynamicViewController: RPBaseViewController {
    
    var transitionView:UIView?
    var type:RPDynamicViewControllerType = .pictures
    var topView = RPDynamicTopView()
    private lazy var pictureMainView = RPPicturesDynamicView()
    private lazy var videoMainView = RPVideoDynamicView()
    var model = RPNiceModel()
    
    public convenience init(dynamicType:RPDynamicViewControllerType = .pictures,model:RPNiceModel) {
        self.init()
        self.type = dynamicType
        self.model = model
        initUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func initUI()  {
        switch type {
        case .pictures:
            topView = RPDynamicTopView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.NAV_HEIGHT))
            topView.delegate = self
            self.view.addSubview(topView)
            pictureMainView = RPPicturesDynamicView.init(frame: CGRect.init(x: 0, y: RPTools.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - RPTools.NAV_HEIGHT))
            pictureMainView.delegate = self
            pictureMainView.container = self
            pictureMainView.model = model
            self.view.addSubview(pictureMainView)
            break
        case .video:
            videoMainView = RPVideoDynamicView.init(frame: self.view.bounds)
            videoMainView.delegate = self
            videoMainView.model = model
            self.view.addSubview(videoMainView)
            break
        }
    }
    
    func goback() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RPDynamicViewController: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
        switch type {
        case.dismiss:
            self.goback()
            break
        case .share:
            let share = RPShareViewController.init(title: nil, dataArray: [[RPShareItem.shareToWeChat(),RPShareItem.shareToWechatCircle()]]) { (indexPath) in
                log.debug(indexPath)
            }
            self.present(share, animated: true, completion: nil)
            break
        case .commit:
            break
        case .like:
            break
        case .collect:
            break
        case .browser:
            let browser = JXPhotoBrowser()
            browser.numberOfItems = {
                self.model.imgs.count
            }
            browser.reloadCellAtIndex = { context in
                let url = self.model.imgs[context.index]
                let browserCell = context.cell as? JXPhotoBrowserImageCell
                browserCell?.index = context.index
                let collectionPath = IndexPath(item: context.index, section: 0)
                let collectionCell = self.pictureMainView.headerView.collectionView.cellForItem(at: collectionPath) as? RPPicturesDynamicCell
                let placeholder = collectionCell?.imgV.image
                browserCell?.imageView.setImageWithURL(url, placeholder: placeholder ?? UIImage.init())
            }
            browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
                let path = IndexPath(item: index, section: 0)
                let cell = self.pictureMainView.headerView.collectionView.cellForItem(at: path) as? RPPicturesDynamicCell
                return cell?.imgV
            })
            browser.pageIndex = index!
            browser.show()
            break
        }
    }
}
