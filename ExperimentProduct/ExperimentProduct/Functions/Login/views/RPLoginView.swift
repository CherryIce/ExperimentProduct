//
//  RPLoginView.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/12.
//

import UIKit

class RPLoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textField = RPTextFiled.init()
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.right.equalTo(32)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        
        let logoView = UIImageView.init(image: RPImage.init(color: RPColor.init(hexString:"#FFF3E6"))?.roundedCornerImageWithCornerRadius(8))
        self.addSubview(logoView)
        
        logoView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(textField.snp_top).offset(-50)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
