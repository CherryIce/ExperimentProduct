//
//  RPLookPictureViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/10.
//

import UIKit

class RPLookPictureViewController: RPBaseViewController {

    private lazy var imgV = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "大头贴"
        self.view.backgroundColor = .black
        creatUI()
    }
    
    func creatUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: RPTools.getPngImage(forResource: "more@2x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(doImage))
        
        imgV = UIImageView.init()
        self.view.addSubview(imgV)
        
        imgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(SCREEN_WIDTH)
            make.center.equalToSuperview()
        }
        
        imgV.image = RPImage.init(color: RPColor.ShallowColor)
    }
    
    //选择照片还是拍照片
    @objc func doImage() {
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
                self.requestPhotoPermission()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //字体颜色
        let dict = {[NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]}()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.shadowColor = UIColor.clear
            appearance.titleTextAttributes = dict
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }else{
            //导航栏背景
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .black), for: .default)
            self.navigationController?.navigationBar.titleTextAttributes = dict
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //字体颜色
        let dict = {[NSAttributedString.Key.foregroundColor:RPColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]}()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = UIColor.clear
            appearance.titleTextAttributes = dict
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }else{
            //导航栏背景
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
            self.navigationController?.navigationBar.titleTextAttributes = dict
        }
    }
    
    //状态栏字体白色 配合infoplist:View controller-based status bar appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension RPLookPictureViewController:UUTakePhotoDelegate {
    func imagePicker(_ imagePicker: UUTakePhoto, didFinished editedImage: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            if editedImage != nil {
                self!.imgV.image = editedImage
            }
        }
    }
    
    func imagePickerDidCancel(_ imagePicker: UUTakePhoto) {
        log.alert("cancel")
    }
}
