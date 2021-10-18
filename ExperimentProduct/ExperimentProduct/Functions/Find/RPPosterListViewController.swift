//
//  RPPosterListViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPPosterListViewController: RPBaseViewController {
    
    private var pageIndex = Int()
    private lazy var dataArray = NSMutableArray()
    private lazy var collectionView = UICollectionView()
    private lazy var adapter = RPCollectionViewAdapter()
    private lazy var viewModel  = RPPosterViewModel()
    
    //分类类型 字符串或则id
    public var typeId: String = ""{
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        pageIndex = 1
        adapter.c_delegate = self
        initUI()
        refreshUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: NSNotification.Name(rawValue: "xxxx"), object: nil)
    }
    
    func initUI () {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    @objc func refreshUI () {
        viewModel.getPosterLists(params: NSDictionary.init()) { (datas) in
            if pageIndex == 1 {
                dataArray = NSMutableArray.init(array: datas)
                adapter.dataSourceArray = dataArray as [AnyObject]
                collectionView.reloadData()
                pageIndex += 1
            }else{
                let indexPaths = NSMutableArray.init()
                for i in 0 ..< datas.count {
                    dataArray.add(datas[i])
                    let indexPath = NSIndexPath.init(row: dataArray.count-1, section: 0)
                    indexPaths.add(indexPath)
                }
                adapter.dataSourceArray = dataArray as [AnyObject]
                if indexPaths.count > 0 {
                    collectionView.insertItems(at: indexPaths as! [IndexPath])
                    UIView.performWithoutAnimation {
                        collectionView.reloadItems(at: indexPaths as! [IndexPath])
                    }
                }
            }
        } failed: { (error) in
            
        }
    }
}

extension RPPosterListViewController : RPListViewCellEventDelegate {
    func didSelectListView(_ listView: UIScrollView, indexPath: IndexPath, sectionData: AnyObject, cellData: AnyObject) {
        
    }
}
