//
//  RPPicturesDynamicView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit

class RPPicturesDynamicView: UIView {
    
    lazy var collectionView = UICollectionView()
    lazy var pageControl = UIPageControl()
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
        
        pageControl = UIPageControl.init()
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = RPColor.MainColor
        pageControl.pageIndicatorTintColor = RPColor.ShallowColor
        self.addSubview(pageControl)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        pageControl.numberOfPages = model.imgs.count
        let size = pageControl.size(forNumberOfPages: model.imgs.count)
        pageControl.frame.size = size
        pageControl.center.x = self.bounds.size.width * 0.5
        pageControl.frame.origin.y = collectionView.frame.maxY - 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RPPicturesDynamicView:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPPicturesDynamicCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPPicturesDynamicCell
        cell.imgV.setImageWithURL(model.imgs[indexPath.item], placeholder: UIImage.init(color: RPColor.RandomColor)!)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = lroundf(Float(current))
    }
}

class RPPicturesDynamicCell: UICollectionViewCell {
    var imgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgV = UIImageView.init()
        imgV.contentMode = .scaleAspectFill//scaleAspectFit
        self.addSubview(imgV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgV.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
