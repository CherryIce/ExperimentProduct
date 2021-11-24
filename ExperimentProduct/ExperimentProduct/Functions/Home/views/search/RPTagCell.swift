//
//  RPTagCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit

class RPTagCell: UICollectionViewCell {
    lazy var tagLabel:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.textAlignment = .center
        tagLabel.font = UIFont.systemFont(ofSize: 13)
        return tagLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        tagLabel.frame = bounds
        
        tagLabel.layercornerRadius(cornerRadius: bounds.height*0.5)
        tagLabel.layercornerBorder(borderWidth: 0.5, borderColor: .init(hexString: "333333"))
    }
}
