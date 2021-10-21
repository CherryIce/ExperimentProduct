//
//  RPEmptyView.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/21.
//

import UIKit

public enum RPEmptyViewType : Int {
    case normal_no_data = 0
    case normal_no_network = 1
}

class RPEmptyView: UIView {
    
    private var placeholderIconV = UIImageView()
    private var reloadBtn = UIButton()
    private var tipsLabel = UILabel()
    
    //闭包
    public typealias ButtonClickCompletionHandler = ()->()
    public var blockButtonClick: ButtonClickCompletionHandler?

    //输入框类型
    public var type: RPEmptyViewType{
        didSet {
            adjustUI()
        }
    }
    
    private func adjustUI () {
        switch type {
        case .normal_no_data:
            establishConstraint(imageName: "empty_data_bill", imageSize: CGSize.init(width: 90, height: 80), tips: "no datas", hideBtn: true)
            break
        case .normal_no_network:
            establishConstraint(imageName: "empty_data_bill", imageSize: CGSize.init(width: 90, height: 80), tips: "no network", hideBtn: false)
            break
        }
    }
    
    //建立约束
    private func establishConstraint(imageName:String,imageSize:CGSize,tips:String,hideBtn:Bool){
        
        placeholderIconV.image = UIImage.init(named: imageName)
        tipsLabel.text = tips
        reloadBtn.isHidden = hideBtn
        
        placeholderIconV.snp.makeConstraints { (make) in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(placeholderIconV.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        reloadBtn.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(tipsLabel.snp.bottom).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
    }
    
    //回调闭包
    func callBackFunction ( block: @escaping () -> Void ) {
        blockButtonClick = block
    }
    
    override init(frame: CGRect) {
        self.type = .normal_no_data
        super.init(frame: frame)
        creatUI()
    }
    
    private func creatUI () {
        placeholderIconV = UIImageView.init()
        self.addSubview(placeholderIconV)
        
        tipsLabel = UILabel.init()
        tipsLabel.numberOfLines = 2
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        tipsLabel.textColor = RPColor.init(hexString: "#666666")
        tipsLabel.textAlignment = .center
        self.addSubview(tipsLabel)
        
        reloadBtn = UIButton.init(type: .custom)
        self.addSubview(reloadBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
