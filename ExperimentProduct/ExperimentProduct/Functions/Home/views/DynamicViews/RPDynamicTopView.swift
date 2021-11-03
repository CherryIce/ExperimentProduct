//
//  RPDynamicTopView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit

class RPDynamicTopView: UIView {
    weak var delegate:RPDynamicViewEventDelegate?
    lazy var leftItem = UIButton()
    lazy var rightItem = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }

    func creatUI() {
        leftItem = UIButton.init(type: .custom)
        leftItem.setImage(RPImage.NavBackImage, for: .normal)
        self.addSubview(leftItem)

        rightItem = UIButton.init(type: .custom)
        rightItem.setImage(RPTools.getPngImage(forResource: "share@2x"), for: .normal)
        self.addSubview(rightItem)
        
        leftItem.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        rightItem.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftItem.frame = CGRect.init(x: 16, y: frame.size.height - 30 - 10, width: 30, height: 30)
        rightItem.frame = CGRect.init(x: frame.size.width - 30 - 16, y: leftItem.frame.minY, width: 30, height: 30)
    }
    
    @objc func leftClick() {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(.dismiss, 0)
        }
    }

    @objc func rightClick() {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(.share, 0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
