//
//  RPMineHeaderView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit

class RPMineHeaderView: UIView {
    
    var headImageButton = UIButton()
    
    var userNameLabel = UILabel()
    
    var descrLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headImageButton = UIButton.init(type: .custom)
        self.addSubview(headImageButton)
        
        userNameLabel = UILabel.init()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userNameLabel.textColor = .black
        self.addSubview(userNameLabel)
        
        descrLabel = UILabel.init()
        descrLabel.textColor = RPColor.MainColor
        descrLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(descrLabel)
        
        headImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(RPTools.IS_IPHONEX ? 40 : 30)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(headImageButton.snp_right).offset(10)
            make.top.equalTo(headImageButton.snp_top)
            make.height.equalTo(30)
        }
        
        descrLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel.snp_bottom)
            make.height.equalTo(20)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
