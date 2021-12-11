//
//  RPDynamicCommentCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit

class RPDynamicCommentCell: UICollectionViewCell {
    
    var contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentLabel = UILabel.init()
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension RPDynamicCommentCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? RPExpandCommentModel else { return }
        contentLabel.text = viewModel.username + ":" + viewModel.text
    }
}
