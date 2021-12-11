//
//  RPFollowUserCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import Then
import SnapKit

class RPFollowUserCell: UICollectionViewCell {
    var userButton = UIButton()
    var shareButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userButton = UIButton.init().then {
            $0.contentHorizontalAlignment = .left
            $0.setTitleColor(.black, for: .normal)
        }
        addSubview(userButton)
        userButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    
        shareButton = UIButton.init().then {
            $0.setImage(UIImage.loadImage("share"), for: .normal)
        }
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
 
extension RPFollowUserCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? RPUserModel else { return }
        userButton.setImage(UIImage.loadImage("mine_nor"), for: .normal)
        userButton.setTitle(viewModel.name, for: .normal)
    }
}
