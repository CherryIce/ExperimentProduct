//
//  RPPosterCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPPosterCell: UICollectionViewCell {
    
    weak var delegate:RPListViewCellEventDelegate?
    var model = RPPosterModel()
    private var indexPath = IndexPath()
    
    var posterImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        posterImgView = UIImageView.init()
        posterImgView.contentMode = .scaleToFill
        self.addSubview(posterImgView)
        
        posterImgView.layercornerRadius(cornerRadius: 4)
        posterImgView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RPPosterCell:RPListCellDataDelegate {
    func setCellData(cellData: AnyObject, delegate: RPListViewCellEventDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if cellData is RPCollectionViewCellItem {
            let xx = cellData as! RPCollectionViewCellItem
            if xx.cellData is RPPosterModel {
                model = xx.cellData as! RPPosterModel
                posterImgView.backgroundColor = RPColor.RandomColor
            }
        }
    }
}
