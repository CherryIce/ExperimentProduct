//
//  RPFindCardCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/17.
//

import UIKit

class RPFindCardCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:RPListViewCellEventDelegate?
    private var indexPath = IndexPath()
    var datas = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
    }

}

extension RPFindCardCell:RPListCellDataDelegate {
    func setCellData(cellData:AnyObject,delegate:RPListViewCellEventDelegate,indexPath:IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if cellData is RPCollectionViewCellItem {
            let xx = cellData as! RPCollectionViewCellItem
            if xx.cellData is NSArray {
                datas = xx.cellData as! NSArray
                collectionView.reloadData()
            }
        }
    }
}

extension RPFindCardCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //cell数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    //cell显示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPPosterCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPPosterCell
        let model = datas[indexPath.row] as! RPPosterModel
        cell.posterImgView.setImageWithURL(model.imgUrlPath, placeholder: UIImage.init(color: .orange)!)
        return cell
    }
    
    //cell点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //调用代理方法
        if self.delegate != nil {
            self.delegate?.didSelectListView(collectionView, indexPath: indexPath, sectionData: nil, cellData: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 4 * 16)/3
        let height = (collectionView.frame.size.height - 4*16)/3
        return CGSize.init(width: width, height: height)
    }
}
