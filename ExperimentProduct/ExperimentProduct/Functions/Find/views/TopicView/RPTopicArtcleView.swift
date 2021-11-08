//
//  RPTopicArtcleView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/8.
//

import UIKit

class RPTopicArtcleView: UIView {
    public typealias ClickShareCallBack = ()->()
    public var clickShareCallBack: ClickShareCallBack?
    private lazy var converImgV = UIImageView()
    private lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RPColor.ShallowColor
        layercornerRadius(cornerRadius: 4)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
        
        converImgV = UIImageView.init()
        addSubview(converImgV)
        
        titleLabel = UILabel.init()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(titleLabel)
        
        converImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(converImgV.snp_right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
    }
    
    func initWithTitle(_ title:String,converURL:String?,block:@escaping ClickShareCallBack) {
        if converURL == nil {
            titleLabel.text = title
            titleLabel.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-5)
                make.centerY.equalToSuperview()
            }
            converImgV.snp.updateConstraints { (make) in
                make.left.right.top.bottom.equalTo(0)
            }
        }else{
            converImgV.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(5)
                make.width.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            
            titleLabel.snp.updateConstraints { (make) in
                make.left.equalTo(converImgV.snp_right).offset(5)
                make.right.equalToSuperview().offset(-5)
                make.centerY.equalToSuperview()
            }
            
            converImgV.setImageWithURL(converURL!, placeholder: RPImage.init(color: RPColor.RandomColor)!)
            titleLabel.text = title
            clickShareCallBack = block
        }
    }
    
    @objc private func tapClick() {
        self.clickShareCallBack?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
