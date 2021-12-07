//
//  RPNicePicCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/19.
//

import UIKit
import RxCocoa
import Then

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
        converImgV.setImageWithURL(model.cover.url, placeholder: UIImage.init(color: RPColor.RandomColor)!)
        contentLabel.text = model.title
        userNameLabel.text = model.author.name
        likesButton.setTitle(String(Int(model.likes)), for: .normal)
        headImgV.setImageWithURL(model.author.image, placeholder: UIImage.init(color: RPColor.RandomColor)!, closure: nil)
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
        
        likesButton = UIButton.init(type: .custom).then {
            $0.setTitleColor(.init(hexString: "999999"), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.plain()
                configuration.imagePlacement = .trailing
                configuration.imagePadding = 5
                configuration.contentInsets = NSDirectionalEdgeInsets.zero
                $0.configuration = configuration
            }else{
                $0.titleLabel?.textAlignment = .right
                $0.layoutButton(style: .Right, imageTitleSpace: 5)
            }
        }
        contentView.addSubview(likesButton)
        likesButton.setImage(UIImage.loadImage("likes"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //实际情况 cell的宽是固定的 那么高度应由图片宽高比例得出
        converImgV.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: model.cover.height)
        var top = model.cover.height+10
        contentLabel.frame = CGRect(x: 10, y: top, width:frame.size.width-20, height:model.contentH)
        if model.contentH > 0 {
            top += model.contentH
            top += 10
        }
        headImgV.frame = CGRect(x: 10, y: top, width: 20, height: 20)
        likesButton.frame = CGRect(x: frame.size.width - 10 - 60, y: top, width: 60, height: 20)
        likesButton.sizeToFit()
        likesButton.frame.size = CGSize(width: likesButton.frame.width, height: 20)
        likesButton.frame.origin.x = frame.size.width - 10 - likesButton.frame.width
        userNameLabel.frame = CGRect(x: headImgV.frame.maxX+5, y: top, width: likesButton.frame.minX - headImgV.frame.maxX - 15, height: 20)
        
        contentView.layercornerRadius(cornerRadius: 4)
        converImgV.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 4, height: 4))
        headImgV.layercornerRadius(cornerRadius: 10)
    }
}
