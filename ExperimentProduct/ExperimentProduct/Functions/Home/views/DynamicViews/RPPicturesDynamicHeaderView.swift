//
//  RPPicturesDynamicHeaderView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit

class RPPicturesDynamicHeaderView: UIView {
    weak var delegate:RPDynamicViewEventDelegate?
    lazy var collectionView = UICollectionView()
    lazy var pageControl = UIPageControl()
//    lazy var titleLabel = UILabel()
//    lazy var descrLabel = UILabel()
    var dataArray = [String]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        self.dataArray = []
        super.init(frame: frame)
        creatUI()
    }

    func creatUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = self.backgroundColor
        self.addSubview(collectionView)
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }

        pageControl = UIPageControl.init()
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = RPColor.Separator
        self.addSubview(pageControl)

//        titleLabel = UILabel.init()
//        self.addSubview(titleLabel)
//
//        descrLabel = UILabel.init()
//        self.addSubview(descrLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        pageControl.numberOfPages = dataArray.count
        let size = pageControl.size(forNumberOfPages: dataArray.count)
        pageControl.frame.size = size
        pageControl.center.x = self.bounds.size.width * 0.5
        pageControl.frame.origin.y = collectionView.frame.maxY - 20
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RPPicturesDynamicHeaderView:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPPicturesDynamicCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPPicturesDynamicCell
        cell.imgV.setImageWithURL(dataArray[indexPath.item], placeholder: UIImage.init(color: RPColor.RandomColor)!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(.browser, indexPath.item)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = lroundf(Float(current))
    }
}
