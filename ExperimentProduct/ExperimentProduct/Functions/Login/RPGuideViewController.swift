//
//  RPGuideViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/19.
//

import UIKit
import Then

class RPGuideViewController: RPBaseViewController {
    
    private lazy var collectionView = UICollectionView()
    private lazy var pageControl = UIPageControl()
    private lazy var skipButton = UIButton()
    private lazy var images = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        creatUI()
    }
    
    func creatUI() {
        images = ["001","002","003"]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = view.backgroundColor
        view.addSubview(collectionView)
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        pageControl = UIPageControl().then {
            $0.isUserInteractionEnabled = false
            $0.hidesForSinglePage = true
            $0.numberOfPages = images.count
            $0.currentPageIndicatorTintColor = RPColor.MainColor
            $0.pageIndicatorTintColor = RPColor.ShallowColor
        }
        view.addSubview(pageControl)
        
        let size = pageControl.size(forNumberOfPages: images.count)
        pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        
        skipButton = UIButton.init(type: .custom).then {
            $0.isHidden = true
            $0.setTitle("立即体验", for: .normal)
            $0.setTitleColor(RPColor.MainColor, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        skipButton.addTarget(self, action:#selector(hide) , for: .touchUpInside)
        view.addSubview(skipButton)
        
        skipButton.layercornerRadius(cornerRadius: 3)
        skipButton.layercornerBorder(borderWidth: 1, borderColor: RPColor.MainColor)
        skipButton.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(pageControl.snp_centerY)
        }
    }
    
    @objc func hide() {
        let currentVersion = RPTools.getVersion()
        UserDefaults.standard.setValue(currentVersion, forKey: kLastVersionKey)
        UserDefaults.standard.synchronize()
        
        let deletegate = UIApplication.shared.delegate as! AppDelegate
        deletegate.setMainRoot()
    }
}

extension RPGuideViewController:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPGuideCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPGuideCell
        cell.posterImgView.setImageWithName(images[indexPath.row] as! String)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let current = Int(offsetX / SCREEN_WIDTH+0.5)
//        let current = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = current
        
        skipButton.isHidden = images.count - 1 != lroundf(Float(current))
        pageControl.isHidden = !skipButton.isHidden
    }
}
