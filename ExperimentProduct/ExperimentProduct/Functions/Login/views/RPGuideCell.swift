//
//  RPGuideCell.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/19.
//

import UIKit

class RPGuideCell: UICollectionViewCell {
    
    var posterImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        posterImgView = UIImageView.init()
        posterImgView.contentMode = .scaleAspectFill
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
