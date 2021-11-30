//
//  RPSearchTitleView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit

class RPSearchTitleView: UICollectionReusableView {
    lazy var titleLabel = UILabel()
    lazy var deleBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel.init()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        addSubview(titleLabel)
        
        deleBtn = UIButton.init(type: .custom)
        deleBtn.setImage(UIImage.loadImage("delete"), for: .normal)
        addSubview(deleBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleBtn.frame = CGRect(x: bounds.width - 36, y: bounds.height/2 - 10, width: 20, height: 20)
        titleLabel.frame = CGRect(x: 16, y: 10, width:deleBtn.frame.minX-32, height: bounds.height-20)
    }
}
