//
//  RPMediaTitleView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/25.
//

import UIKit

class RPMediaTitleView: UIView {

    lazy var leftBtn = UIButton()
    lazy var titleLabel = UILabel()
    lazy var rightBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftBtn = UIButton.init(type: .custom)
        leftBtn.tintColor = .white
        addSubview(leftBtn)
        
        rightBtn = UIButton.init(type: .custom)
        rightBtn.tintColor = .white
        addSubview(rightBtn)
        
        titleLabel = UILabel.init()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftBtn.frame = CGRect(x: 16, y: frame.height - 30 - 7, width: 30, height: 30)
        rightBtn.frame = CGRect(x: frame.width-30-16, y: frame.height - 30 - 7, width: 30, height: 30)
        titleLabel.frame = CGRect(x: leftBtn.frame.maxX + 10, y: leftBtn.frame.minY, width: rightBtn.frame.minX - leftBtn.frame.maxX - 20, height: leftBtn.frame.height)
    }
    
}
