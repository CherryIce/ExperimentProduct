//
//  RPFollowCollectionViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/9.
//

import UIKit
import IGListKit
import Then

class RPFollowCollectionViewCell: UICollectionViewCell {
    lazy var collectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow).then {
            $0.backgroundColor = .clear
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
        collectionView.frame = bounds
    }
}

extension RPFollowCollectionViewCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
//        guard let viewModel = viewModel as? RPImageViewModel else { return }
//        imageView.setImageWithURL(viewModel.url, placeholder: UIImage(color: RPColor.redWine)!)
    }
}
