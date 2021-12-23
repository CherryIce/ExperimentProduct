//
//  RPCommentViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import Then

class RPCommentViewCell: UICollectionViewCell {
    lazy var collectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let flow = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow).then {
            $0.backgroundColor = RPColor.ShallowColor
            $0.layercornerRadius(cornerRadius: 4)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            }
        }
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 16, y: 0, width: bounds.size.width - 32, height: bounds.size.height)
    }
}

extension RPCommentViewCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
//        guard let viewModel = viewModel as? RPCommentModel else { return }
//        contentLabel.text = viewModel.username + ":" + viewModel.text
    }
}

