//
//  RPMineViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import TZImagePickerController

//fix bug:https://github.com/ReactiveX/RxSwift/issues/2081

class RPMineViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = RPUserInfoViewModel()
    
    private let offset = Variable("0")
    
    //头部视图
    lazy var headerView = RPMineHeaderView()
    
    //tableView
    lazy var tableView = UITableView()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SettingSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        creatHeaderView()
        createTableViewUI()
        
        let output = viewModel.transform(input: offset, dependecies: RPNetWorkManager.shared)
        
        dataSource = RxTableViewSectionedReloadDataSource<SettingSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
            cell.imageView?.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(20)
            cell.textLabel?.text = item.title
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        })
        
        tableView.rx.modelSelected(RPUserInfoModel.self).subscribe(onNext: { (item) in
            print(item)
            self.navigationController?.pushViewController(RPPostersViewController.init(), animated: true)
        }).disposed(by: disposeBag)
        
        output.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)


        self.tableView.tableHeaderView = self.headerView
    }
    
    func creatHeaderView () {
        headerView = RPMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.IS_IPHONEX ? 120 : 100))
        
        headerView.headImageButton.rx.tap.bind {
            self.doImage()
        }.disposed(by: disposeBag)
    }
    
    func doImage() {
        let alertC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertC.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.requestCameraPermission()
        }))
        alertC.addAction(UIAlertAction.init(title: "从相册中选", style: .default, handler: { (action) in
            self.requestPhotoPermission()
        }))
        alertC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        self.present(alertC, animated: true, completion: nil)
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
//                let imagePickerController = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 1, delegate: self)!
//                self.present(imagePickerController, animated: true, completion: nil)
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
                let imagePickerController = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 1, delegate: self)!
                self.present(imagePickerController, animated: true, completion: nil)
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
    
    //MARK: - 实例化tableView
    func createTableViewUI() {
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        //注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.separatorColor = RPColor.Separator
        //去掉多余的分割线
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // 隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 显示导航栏
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension RPMineViewController: TZImagePickerControllerDelegate {
    
}
