//
//  RPFollowViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit

class RPFollowViewCell: UITableViewCell {
    
    @IBOutlet weak var authorBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var decrLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    
    var model = RPNiceModel.init() {
        didSet {
            //粗略的👁
            pageControl.numberOfPages = model.imageList.count
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.backgroundColor = RPColor.RandomColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = RPColor.redWine
//        pageControl.pageIndicatorTintColor = RPColor.Separator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RPFollowViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPPicturesDynamicCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPPicturesDynamicCell
        let model = model.imageList[indexPath.item]
        cell.imgV.setImageWithURL(model.url, placeholder: UIImage.init(color: RPColor.RandomColor)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let current = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = lroundf(Float(current))
    }
}
