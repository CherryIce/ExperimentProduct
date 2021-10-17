//
//  RPPosterCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPPosterCell: UICollectionViewCell {
    
    weak var delegate:RPCollectionViewCellEventDelegate?
    var model = RPPosterModel()
    private var indexPath = IndexPath()
    
    private var posterImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        posterImgView = UIImageView.init()
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

extension RPPosterCell:RPCollectionViewCellDataDelegate {
    func setData(data: RPCollectionViewCellItem,
                 delegate: RPCollectionViewCellEventDelegate,
                 indexPath:IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if data.cellData is RPPosterModel {
            model = data.cellData as! RPPosterModel
            posterImgView.backgroundColor = RPColor.RandomColor
        }
    }
}
