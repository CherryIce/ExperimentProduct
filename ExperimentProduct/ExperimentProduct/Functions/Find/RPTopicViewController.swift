//
//  RPTopicViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/4.
//

import UIKit
import JXPhotoBrowser
import Photos

class RPTopicViewController: RPBaseViewController {
    private lazy var viewModel = RPTopicViewModel()
    private var tableView = UITableView()
    private lazy var dataArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Welcome Topic"
        createTableViewUI()
        loadData()
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        viewModel.getTopicLists(params: NSDictionary.init()) { (dataArray) in
            self.dataArray = NSMutableArray.init(array: dataArray)
            self.tableView.reloadData()
        } failed: { (error) in
            
        }
    }
    
    private func longPress(cell: JXPhotoBrowserImageCell) {
        let savePhoto = RPActionSheetCellItem.init(title: "保存到本地")
        let alertC = RPActionSheetController.init(title:nil,
                                                  message:nil,
                                                  dataArray:[[savePhoto],
                                                             [RPActionSheetCellItem.cancel()]]) { (indexPath) in
            DispatchQueue.main.async {
                if indexPath.section == 0 {
                    if indexPath.row == 0 {
                        self.requestPhotoPermission(cell.imageView.image)
                    }
                }
            }
        }
        cell.photoBrowser?.present(alertC, animated: true,completion: nil)
    }
    
    //请求相册权限
    func requestPhotoPermission(_ sourceImage:UIImage?) {
        if sourceImage == nil {
            self.viewShowToast("没找到可保存的图片资源", position: .center)
            return
        }
        RPPermissions.request(.photoLibrary) { (status) in
            switch status {
            case .unknown,.restricted,.denied:
                let alert = RPAlertViewController.init(title: "没有相册权限", message: "去设置打开相关权限?", cancel: "取消", confirm: "确定") { (index) in
                    if index == 1 {
                        RPTools.jumpToSystemPrivacySetting()
                    }
                }
                self.present(alert, animated: false,completion: nil)
                break
            case .notDetermined:
                self.requestPhotoPermission(sourceImage)
                break
            case .authorized,.provisional:
                PHPhotoLibrary.shared().performChanges {
//                    PHAssetChangeRequest.creationRequestForAsset(from: sourceImage!)
                    let options = PHAssetResourceCreationOptions()
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: (sourceImage?.pngData())!, options: options)
                } completionHandler: { (isSuccess: Bool, error: Error?) in
                    DispatchQueue.main.async {
                        if isSuccess {
                            self.windowShowToast("保存成功")
                        }else {
                            self.windowShowToast("保存失败")
                        }
                    }
                }
                break
            case .noSupport:
                //设备不支持
                self.viewShowToast("设备不支持", position: .top)
                break
            }
        }
    }
}

extension RPTopicViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        let cell = tableView.dequeueReusableCell(withIdentifier: RPTableViewAdapter().reuseIdentifierForCellClass(cellClass: RPTopViewCell.self, tableView: tableView), for: indexPath) as! RPTopViewCell
        cell.setCellData(model: model, delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        return model.cellH
    }
}

extension RPTopicViewController : RPTopViewCellDelegate {
    func clickHeaderIconInTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
//        let model = self.dataArray[indexPath.row] as! RPTopicModel
        let ctl = RPMineTopicController.init()
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func photoListClickInTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath, index: Int, extraData: [UIView]) {
        //图片 视频工具栏需要做自定义处理 - later
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            model.type == .pictures ? model.images.count : 1
        }
        browser.cellClassAtIndex = { index in
            model.type == .video ? RPVideoBrowserCell.self : JXPhotoBrowserImageCell.self
        }
        browser.reloadCellAtIndex = { context in
            if model.type == .pictures {
                let imgModel = model.images[context.index]
                let browserCell = context.cell as? JXPhotoBrowserImageCell
                browserCell?.index = context.index
                let placeholder = RPTools.snapshot(extraData[context.index])
                browserCell?.imageView.setImageWithURL(imgModel.url, placeholder: placeholder ?? UIImage.init())
                // 添加长按事件
                browserCell?.longPressedAction = { cell, _ in
                    self.longPress(cell: cell)
                }
            }else{
                let browserCell = context.cell as? RPVideoBrowserCell
                browserCell?.path = URL(string: model.video.videoPath)
            }
        }
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            return extraData[index]
        })
        browser.cellWillAppear = { cell,index in
            (cell as? RPVideoBrowserCell)?.play()
        }
        browser.cellWillDisappear = { cell,index in
            (cell as? RPVideoBrowserCell)?.pause()
        }
        browser.pageIndex = index
        browser.pageIndicator = JXPhotoBrowserDefaultPageIndicator()
        browser.show()
    }
    
    func selectURLInTopic(_ cell: RPTopViewCell, url: String) {
        let ctl = RPWkwebViewController.init()
        ctl.urlString = url
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func expandTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath) {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        if model.isExpand {
            model.textCurrH = model.textLimitH
            model.cellH -= (model.textTotalH - model.textLimitH)
            model.isExpand = false
        }else{
            model.textCurrH = model.textTotalH
            model.cellH += (model.textTotalH - model.textLimitH)
            model.isExpand = true
        }
        UIView.performWithoutAnimation {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func commentTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func updatePermission(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func deleteTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func likeTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
    
    func locationClickInTheTopic(_ cell: RPTopViewCell, indexPath: IndexPath) {
        
    }
}
