//
//  RPGuideViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/19.
//

import UIKit

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
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
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
        collectionView.backgroundColor = view.backgroundColor;
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        pageControl = UIPageControl.init()
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = images.count
        pageControl.currentPageIndicatorTintColor = RPColor.MainColor
        pageControl.pageIndicatorTintColor = RPColor.ShallowColor
        self.view .addSubview(pageControl)
        
        let size = pageControl.size(forNumberOfPages: images.count)
        pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
        
        skipButton = UIButton.init(type: .custom)
        skipButton.isHidden = true
        skipButton.setTitle("立即体验", for: .normal)
        skipButton.setTitleColor(RPColor.MainColor, for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        skipButton.addTarget(self, action:#selector(hide) , for: .touchUpInside)
        self.view.addSubview(skipButton)
        
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
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
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
        cell.posterImgView.image = RPTools.getPngImage(forResource: images[indexPath.row] as! String)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = lroundf(Float(current))
        
        skipButton.isHidden = images.count - 1 != lroundf(Float(current))
        pageControl.isHidden = !skipButton.isHidden;
    }
}
