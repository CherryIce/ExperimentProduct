//
//  RPNicePicCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/19.
//

import UIKit
import RxCocoa

class RPNicePicCell: UICollectionViewCell {
    
    var converImgV = UIImageView()
    var contentLabel = UILabel()
    var headImgV = UIImageView()
    var userNameLabel = UILabel()
    var likesButton =  UIButton()
    
    var model: RPNiceModel = RPNiceModel.init(){
        didSet {
            establish()
        }
    }
    
    func establish() {
        converImgV.setImageWithURL(model.converUrl, placeholder: UIImage.init(color: RPColor.RandomColor)!)
        contentLabel.text = model.content
        headImgV.setImageWithURL(model.headImgUrl, placeholder: UIImage.init(color: RPColor.RandomColor)!, closure: nil)
        userNameLabel.text = model.userName
        likesButton.setTitle(String(Int(model.likes)), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = RPColor.ShallowColor
        
        converImgV = UIImageView.init()
        contentView.addSubview(converImgV)
        
        contentLabel = UILabel.init()
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.numberOfLines = 2
        contentView.addSubview(contentLabel)
        
        headImgV = UIImageView.init()
        contentView.addSubview(headImgV)
        
        userNameLabel = UILabel.init()
        userNameLabel.font = .systemFont(ofSize: 13)
        contentView.addSubview(userNameLabel)
        
        likesButton = UIButton.init(type: .custom)
        likesButton.setTitleColor(.init(hexString: "999999"), for: .normal)
        likesButton.titleLabel?.font = .systemFont(ofSize: 13)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.imagePlacement = .trailing
            configuration.imagePadding = 5
            configuration.contentInsets = NSDirectionalEdgeInsets.zero
            likesButton.configuration = configuration
        }else{
            likesButton.titleLabel?.textAlignment = .right
            likesButton.layoutButton(style: .Right, imageTitleSpace: 5)
        }
        contentView.addSubview(likesButton)
        likesButton.setImage(RPTools.getPngImage(forResource: "likes@2x"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        converImgV.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: model.converH)
        var top = model.converH+10
        contentLabel.frame = CGRect(x: 10, y: top, width:frame.size.width-20, height:model.contentH)
        if model.contentH > 0 {
            top += model.contentH
            top += 10
        }
        headImgV.frame = CGRect(x: 10, y: top, width: 20, height: 20)
        likesButton.frame = CGRect(x: frame.size.width - 10 - 60, y: top, width: 60, height: 20)
        likesButton.sizeToFit()
        likesButton.frame.size = CGSize(width: likesButton.frame.width, height: 20)
        userNameLabel.frame = CGRect(x: headImgV.frame.maxX+5, y: top, width: likesButton.frame.minX - headImgV.frame.maxX - 15, height: 20)
        
        contentView.layercornerRadius(cornerRadius: 4)
        converImgV.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 4, height: 4))
        headImgV.layercornerRadius(cornerRadius: 10)
    }
}
