//
//  RPDynamicPicHeaderCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/12/11.
//

import UIKit
import IGListKit
import Then
import SnapKit

class RPDynamicPicHeaderCell: UICollectionViewCell {
    var cellAction: ((RPDynamicPicHeaderCell,RPDynamicViewEventType) -> Void)?
    private var backButton = UIButton()
    private var userButton = UIButton()//用control？
    private var followButton = UIButton()
    private var shareButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backButton = UIButton.init().then {
            $0.contentHorizontalAlignment = .left
            $0.setImage(RPImage.NavBackImage, for: .normal)
        }
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-7)
        }
        backButton.addTarget(self, action: #selector(goback), for: .touchUpInside)
        
        userButton = UIButton.init().then {
            $0.contentHorizontalAlignment = .left
            $0.setTitleColor(.black, for: .normal)
        }
        addSubview(userButton)
        userButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp_right).offset(5)
            make.width.lessThanOrEqualTo(120)
            make.height.equalTo(30)
            make.centerY.equalTo(backButton.snp_centerY)
        }
        userButton.addTarget(self, action: #selector(userInfoClick), for: .touchUpInside)
    
        shareButton = UIButton.init().then {
            $0.setImage(UIImage.loadImage("share"), for: .normal)
        }
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
            make.centerY.equalTo(backButton.snp_centerY)
        }
        shareButton.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        
        followButton = UIButton.init().then {
            $0.setTitle("关注", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.backgroundColor = .red
            $0.layercornerRadius(cornerRadius: 12)
        }
        addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.right.equalTo(shareButton.snp_left).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(24)
            make.centerY.equalTo(backButton.snp_centerY)
        }
        followButton.addTarget(self, action: #selector(followClick), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func goback() {
        cellAction?(self, .dismiss)
    }
    
    @objc fileprivate func userInfoClick() {
        cellAction?(self, .look)
    }
    
    @objc fileprivate func followClick() {
        cellAction?(self, .follow)
    }

    @objc fileprivate func shareClick() {
        cellAction?(self,.share)
    }
}

extension RPDynamicPicHeaderCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? RPUserModel else { return }
        userButton.setImage(UIImage.loadImage("mine_nor"), for: .normal)
        userButton.setTitle(viewModel.name, for: .normal)
    }
}
