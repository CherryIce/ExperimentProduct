//
//  RPMeidDetailViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/25.
//

import UIKit

class RPMeidDetailViewController: RPBaseViewController {
    
    private lazy var collectionView = UICollectionView()
    private lazy var titleView = RPMediaTitleView()
    lazy var dataArray = [RPTopicModel]()
    lazy var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        simpleUI()
    }
    
    func simpleUI() {
        titleView = RPMediaTitleView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.NAV_HEIGHT))
        self.view.addSubview(titleView)
        titleView.leftBtn.setImage(RPTools.getPngImage(forResource: "back_white@2x"), for: .normal)
        titleView.leftBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        titleView.rightBtn.setImage(RPTools.getPngImage(forResource: "back_white@2x"), for: .normal)
        titleView.rightBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: RPTools.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-RPTools.NAV_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isFirst {
            self.isFirst = false
            let indexP = IndexPath.init(row: 0, section: currentIndex)
            if #available(iOS 14.0, *) {
                let attributes = collectionView.layoutAttributesForItem(at: indexP)
                let x = attributes?.frame.origin.x ?? 0
                let y = attributes?.frame.origin.y ?? 0
                collectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
            }else{
                collectionView.scrollToItem(at: indexP, at:UICollectionView.ScrollPosition.centeredHorizontally , animated: false)
            }
        }
    }
    
    @objc func back() {
        disMiss(true)
    }
    
    @objc func share() {
        log.debug("分享")
    }
    
    func disMiss(_ animation:Bool = false)  {
        dismiss(animated: animation, completion: nil)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}

extension RPMeidDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = dataArray[section]
        return model.images.count>0 ? model.images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArray[indexPath.section]
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPMediaImageCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPMediaImageCell
        var url = ""
        if model.images.count > 0 {
            let imgModel = model.images[indexPath.row]
            url = imgModel.url
        }else{
            url = model.video.converUrl
        }
        cell.photoBrowser = self
        cell.imageView.contentMode = .scaleAspectFit
        cell.imageView.setImageWithURL(url, placeholder: .init(color: RPColor.ShallowColor)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        titleView.titleLabel.text = String(format: "%d-%d", indexPath.section,indexPath.row)
    }
}

extension RPMeidDetailViewController:UIScrollViewDelegate {
    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        guard let cell = collectionView.visibleCells.first else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        titleView.titleLabel.text = String(format: "%d-%d", indexPath.section,indexPath.row)
    }
}
