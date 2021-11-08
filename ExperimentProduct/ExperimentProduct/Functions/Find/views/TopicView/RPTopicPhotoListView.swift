//
//  RPTopicPhotoListView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/8.
//

import UIKit

class RPTopicPhotoListView: UIView {
    public typealias ClickItemCallBack = (_ indexPath:IndexPath,_ currView:UIView)->()
    public var clickItemCallBack: ClickItemCallBack?
    private lazy var collectionView = UICollectionView()
    var itemSize:CGSize = .zero
    var dataArray = [RPImageModel](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup()  {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
        
        //cell左对齐
        collectionView.collectionViewLayout.perform(Selector.init(("_setRowAlignmentsOptions:")),with:NSDictionary.init(dictionary:["UIFlowLayoutCommonRowHorizontalAlignmentKey":NSNumber.init(value:NSTextAlignment.left.rawValue)]))
    }
    
    func callBack(_ block:@escaping ClickItemCallBack) {
        self.clickItemCallBack = block
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RPTopicPhotoListView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPTopicPhotoListCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPTopicPhotoListCell
        let xxx = self.dataArray[indexPath.item]
        cell.setCellData(xxx.url, placeholderImage: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if self.clickItemCallBack != nil {
            self.clickItemCallBack?(indexPath,cell!)
        }
    }
}


class RPTopicPhotoListCell: UICollectionViewCell {
    private var posterImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        posterImgView = UIImageView.init()
        self.addSubview(posterImgView)
        posterImgView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func setCellData(_ picture:String,placeholderImage:UIImage?){
        if picture.hasPrefix("http") {
            posterImgView.setImageWithURL(picture, placeholder:(placeholderImage ?? UIImage.init(color: .black))!)
        } else {
            posterImgView.image = UIImage(named: picture) ?? (placeholderImage ?? UIImage.init(color: .black))!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
