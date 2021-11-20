//
//  RPMineTopicViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/20.
//

import UIKit

class RPMineTopicViewCell: UITableViewCell {
    
    //左边时间 同一日的时间不重复显示
    lazy var dateTimeLabel = UILabel()
    //右边区域大致分为两种:
    //一种是纯文本或则分享类型 背景色是灰色的 非固定高度 文本最多显示2行
    //第二种是图片视频类型 左图右文妥妥的 固定高度 文本最多显示3行
    lazy var normal = RPMineTopicNormalView()
    lazy var picture = RPMineTopicPicturesView()
    
    var model:RPTopicModel = .init() {
        didSet {
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        dateTimeLabel = UILabel.init()
        contentView.addSubview(dateTimeLabel)
        
        normal = RPMineTopicNormalView.init()
        contentView.addSubview(normal)
        
        picture = RPMineTopicPicturesView.init()
        contentView.addSubview(picture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateTimeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let rframe = CGRect(x:110, y: 10, width: frame.width - 120, height: frame.size.height - 20)
        switch model.type {
        case .text,.article:
            picture.frame = .zero
            picture.isHidden = true
            normal.isHidden = false
            normal.frame = rframe
            normal.initWithTitle(model.artic.title, converURL: model.artic.converUrl, content: model.text)
            break
        case .pictures,.video:
            picture.frame = rframe
            picture.isHidden = false
            normal.isHidden = true
            normal.frame = .zero
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class RPMineTopicPicturesView:UIView {
    lazy var contentLabel = UILabel()
    lazy var numsLabel = UILabel()//共*张图
    lazy var pv = UIView()//显示图片或视频
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RPColor.red
        
        contentLabel = UILabel.init()
        contentLabel.numberOfLines = 3
        addSubview(contentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RPMineTopicNormalView:UIView {
    lazy var contentLabel = UILabel()
    lazy var titleLabel = UILabel()
    lazy var converImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RPColor.ShallowColor
        layercornerRadius(cornerRadius: 4)
        
        contentLabel = UILabel.init()
        contentLabel.font = .systemFont(ofSize: 15)
        contentLabel.numberOfLines = 2
        addSubview(contentLabel)
        
        converImgV = UIImageView.init()
        addSubview(converImgV)
        
        titleLabel = UILabel.init()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithTitle(_ title:String,converURL:String?,content:String?) {
        contentLabel.text = content
        if content?.count == 0 {
            contentLabel.frame = .zero
        }else{
            contentLabel.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: 20)
            contentLabel.sizeToFit()
        }
        if converURL?.count == 0 {
            converImgV.frame = .zero
        }else{
            converImgV.frame = CGRect(x: 5, y: contentLabel.frame.maxY+5, width: 35, height: 35)
            converImgV.setImageWithURL(converURL!, placeholder: RPImage.init(color: RPColor.RandomColor)!)
        }
        
        if title.count == 0 {
            titleLabel.frame = .zero
        }else{
            titleLabel.text = title
            titleLabel.frame = CGRect(x: converImgV.frame.maxX+5, y: converImgV.frame.origin.y, width: frame.width - converImgV.frame.maxX - 10, height: 20)
            titleLabel.sizeToFit()
            titleLabel.center.y = contentLabel.frame.maxY + (frame.height - contentLabel.frame.maxY) * 0.5
        }
    }
}
