//
//  RPNewsViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//fix bug:https://github.com/ReactiveX/RxSwift/issues/2081

class RPNewsViewController: RPBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = RPUserInfoViewModel()
    
    private let offset = Variable("0")
    
    //tableView
    lazy var tableView = UITableView()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SettingSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        createTableViewUI()
        
        let output = viewModel.transform(input: offset, dependecies: RPNetWorkManager.shared)
        
        dataSource = RxTableViewSectionedReloadDataSource<SettingSection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
            cell.imageView?.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(20)
            cell.textLabel?.text = item.title
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        })
        
        tableView.rx.modelSelected(RPUserInfoModel.self).subscribe(onNext: {[weak self] (item) in
            self?.navigationController?.pushViewController(RPPostersViewController.init(), animated: true)
        }).disposed(by: disposeBag)
        
        output.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
