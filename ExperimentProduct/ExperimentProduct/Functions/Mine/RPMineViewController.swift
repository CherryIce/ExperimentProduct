//
//  RPMineViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import RxSwift

class RPMineViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    private var adapter = RPTableViewAdapter()
    private var dataList: NSMutableArray = []
    private lazy var viewModel = RPYaViewModel()
    
    //头部视图
    lazy var headerView = RPMineHeaderView()
    //tableView
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        creatHeaderView()
        createTableViewUI()
        adapter.c_delegate = self
        loadData()
        
        self.tableView.tableHeaderView = headerView
    }
    
    func creatHeaderView () {
        headerView = RPMineHeaderView.init(frame: CGRect.init(x: .zero, y: .zero, width: SCREEN_WIDTH, height: RPTools.IS_IPHONEX ? 170 : 150))
        
        headerView.headImageButton.rx.tap.bind {
            self.doImage()
        }.disposed(by: disposeBag)
    }
    
    func doImage() {
        let camera = RPActionSheetCellItem.init(title: "拍照")
        let photoLibary = RPActionSheetCellItem.init(title: "从相册中选")
        let alertC = RPActionSheetController.init(title:nil,
                                                  message:nil,
                                                  dataArray:[[camera,photoLibary],
                                                             [RPActionSheetCellItem.cancel()]]) { (indexPath) in
            DispatchQueue.main.async {
                if indexPath.section == 0 {
                    if indexPath.row == 0 {
                        self.requestCameraPermission()
                    }else{
                        self.requestPhotoPermission()
                    }
                }
            }
        }
        self.present(alertC, animated: true,completion: nil)
    }
    
    //请求相机权限
    func requestCameraPermission() {
        RPPermissions.request(.camera) { (status) in
            switch status {
            case .unknown,.restricted,.denied:
                //去设置
                break
            case .notDetermined:
                self.requestCameraPermission()
                break
            case .authorized,.provisional:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UUTakePhoto.init()
                    imagePicker.showImagePickerWithType(.camera, viewController: self,needEditing:false)
                }else{
                    log.debug("未检测到使用设备")
                }
                break
            case .noSupport:
                //设备不支持
                self.navigationController?.view.makeToast("设备不支持",
                                                          duration: 3.0,
                                                          position: .top,
                                                          style: RPTools.RPToastStyle)
                break
            }
        }
    }
    
    //请求相册权限
    func requestPhotoPermission() {
        RPPermissions.request(.photoLibrary) { (status) in
            switch status {
            case .unknown,.restricted,.denied:
                //去设置
                break
            case .notDetermined:
                self.requestCameraPermission()
                break
            case .authorized,.provisional:
                let imagePicker = UUTakePhoto.shared
                imagePicker.delegate = self
                imagePicker.showImagePickerWithType(.photoLibrary, viewController: self,needEditing:true)
                break
            case .noSupport:
                //设备不支持
                self.navigationController?.view.makeToast("设备不支持",
                                                          duration: 3.0,
                                                          position: .top,
                                                          style: RPTools.RPToastStyle)
                break
            }
        }
    }
    
    //UI
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    //请求数据
    func loadData () {
        viewModel.getYaData(params: NSDictionary.init()) { (datas) in
            dataList.addObjects(from: datas as! [Any])
            adapter.dataSourceArray = dataList as! [RPTableViewSectionItem]
            tableView.reloadData()
        } failed: { (error) in
            log.error("请求失败了")
        }
    }
}

extension RPMineViewController:UUTakePhotoDelegate {
    func imagePicker(_ imagePicker: UUTakePhoto, didFinished editedImage: UIImage?) {
        DispatchQueue.main.async {
            self.headerView.headImageButton.setBackgroundImage(editedImage!, for: .normal)
        }
    }
    
    func imagePickerDidCancel(_ imagePicker: UUTakePhoto) {
        log.alert("cancel")
    }
}

extension RPMineViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView,indexPath:IndexPath,sectionData:AnyObject?,cellData:AnyObject?) {
        self.navigationController?.pushViewController(RPNewsViewController.init(), animated: true)
    }
}

