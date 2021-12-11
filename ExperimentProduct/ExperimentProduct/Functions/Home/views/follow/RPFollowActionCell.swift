//
//  RPFollowActionCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import SnapKit

class RPFollowActionCell: UICollectionViewCell {
    var shareButton = UIButton()
    var likeButton = UIButton()
    var collectButton = UIButton()
    var commentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shareButton = UIButton.init()
        shareButton.setImage(UIImage.loadImage("share"), for: .normal)
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        commentButton = UIButton.init()
        commentButton.setTitleColor(.black, for: .normal)
        addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(80)
        }
        
        collectButton = UIButton.init()
        collectButton.setTitleColor(.black, for: .normal)
        addSubview(collectButton)
        collectButton.snp.makeConstraints { make in
            make.right.equalTo(commentButton.snp_left).offset(-10)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(80)
        }
        
        likeButton = UIButton.init()
        likeButton.setTitleColor(.black, for: .normal)
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.right.equalTo(collectButton.snp_left).offset(-10)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension RPFollowActionCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? RPFollowActionModel else { return }
        likeButton .setTitle("\(viewModel.likes)", for: .normal)
    }
}
