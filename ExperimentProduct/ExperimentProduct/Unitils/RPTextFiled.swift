//
//  RPTextFiled.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/12.
//

import UIKit

class RPTextFiled: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rightIconView = UIImageView.init()
        self.addSubview(rightIconView)
        rightIconView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(5)
            make.width.equalTo(frame.height - 10)
        }
        
        let textField = UITextField.init()
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(rightIconView).offset(10)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(frame.height - 5)
        }
        
        let placeholderLabel = UILabel.init()
        self.addSubview(placeholderLabel)
        placeholderLabel.text = "请输入"
        placeholderLabel.frame = textField.frame;
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
