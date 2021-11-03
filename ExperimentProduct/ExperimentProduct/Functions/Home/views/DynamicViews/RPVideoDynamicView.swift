//
//  RPVideoDynamicView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit

class RPVideoDynamicView: UIView {
    weak var delegate:RPDynamicViewEventDelegate?
    lazy var collectionView = UICollectionView()
    var model:RPNiceModel{
        didSet {
            self.collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        self.model = RPNiceModel.init()
        super.init(frame: frame)
        creatUI()
    }
    
    func creatUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        self.addSubview(collectionView)
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RPVideoDynamicView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPVideoDynamicCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPVideoDynamicCell
        let path = URL.init(string: "https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4")!
        cell.delegate = self
        cell.path = path
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? RPVideoDynamicCell)?.playVideo()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? RPVideoDynamicCell)?.pauseVideo()
    }
}

extension RPVideoDynamicView: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(type, index)
        }
    }
}
