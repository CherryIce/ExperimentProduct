//
//  RPFollowViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit
import IGListKit

//关注那些人的动态列表
class RPFollowViewController: RPBaseViewController {
    
    var data = [ListDiffable]()
    lazy var adapter: ListAdapter = {
        let a = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        a.dataSource = self
        return a
    }()
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        return collectionView
    }()
    
    private lazy var viewModel = RPNiceViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adapter.collectionView = collectionView
        loadData()
    }

    func loadData () {
        viewModel.getFollowLists(params: NSDictionary.init()) { (datas) in
            data = datas
            adapter.performUpdates(animated: true, completion: nil)
        } failed: { (error) in

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension RPFollowViewController:ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return RPFollViewSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


