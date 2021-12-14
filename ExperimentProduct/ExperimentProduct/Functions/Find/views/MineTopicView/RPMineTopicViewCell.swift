//
//  RPMineTopicViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/20.
//

import UIKit
import RxDataSources

class RPMineTopicViewCell: UITableViewCell {
    
    //左边时间 同一日的时间不重复显示
    private lazy var dateTimeLabel = UILabel()
    //右边区域大致分为两种:
    //一种是纯文本或则分享类型 背景色是灰色的 非固定高度 文本最多显示2行
    //第二种是图片视频类型 左图右文妥妥的 固定高度 文本最多显示3行
    private lazy var normal = RPMineTopicNormalView()
    private lazy var picture = RPMineTopicPicturesView()
    
    private var indexPath = IndexPath()
    private var model = RPTopicModel()
    
    func setCellData(model: RPTopicModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.model = model
        estableish()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        dateTimeLabel = UILabel.init()
        dateTimeLabel.textAlignment = .center
        contentView.addSubview(dateTimeLabel)
        
        normal = RPMineTopicNormalView.init()
        contentView.addSubview(normal)
        
        picture = RPMineTopicPicturesView.init()
        contentView.addSubview(picture)
    }
    
    func estableish() {
        let str = String(format: "%02d%zd月", Date.init().calculateDay(),Date.init().calculateMonth())
        let attrStr = NSMutableAttributedString.init(string: str)

        let dict = {[NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 25)]}()
        attrStr.addAttributes(dict, range:NSRange(location: 0, length: 2))
        dateTimeLabel.attributedText = attrStr
        dateTimeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        dateTimeLabel.center.y = frame.height * 0.5 //同一天不需要显示多个没做处理
        let rframe = CGRect(x:110, y: 10, width: frame.width - 120, height: frame.height - 10)
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
            picture.initWithData(model.images, video: model.video, content: model.text)
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
        
        pv = UIView.init()
        addSubview(pv)
        
        contentLabel = UILabel.init()
        contentLabel.font = .systemFont(ofSize: 15)
        contentLabel.numberOfLines = 3
        addSubview(contentLabel)
        
        numsLabel = UILabel.init()
        numsLabel.font = .systemFont(ofSize: 12)
        numsLabel.textColor = .lightGray
        addSubview(numsLabel)
    }
    
    func initWithData(_ imgs:[RPImageModel]?,video:RPVideoModel?,content:String?) {
        contentLabel.text = content
        if content?.count == 0 {
            contentLabel.frame = .zero
        }else{
            contentLabel.frame = CGRect(x: frame.height, y: 5, width: frame.width - frame.height, height: 20)
            contentLabel.sizeToFit()
        }
        pv.subviews.forEach {$0.removeFromSuperview()}
        pv.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        numsLabel.frame =  CGRect(x: frame.height, y: frame.height - 20, width: frame.width - frame.height, height: 20)
        if video?.videoPath.count == 0 {
            numsLabel.isHidden = false
            numsLabel.text = String(format: "共%d张", Int(imgs?.count ?? 0))
            
            switch imgs?.count {
            case 1:
                let model = imgs?.first
                let picImg = UIImageView.init()
                picImg.frame = pv.bounds
                pv.addSubview(picImg)
                picImg.setImageWithURL(model?.url ?? "", placeholder: UIImage.init(color: RPColor.ShallowColor)!)
                break
            case 2,3,4,5,6,7,8,9:
                let count = imgs!.count > 4 ? 4 : imgs!.count
                let w =  pv.frame.width/2-1
                var h = pv.frame.height
                for i in 0..<count {
                    let model = imgs?[i]
                    var x = pv.frame.width*0.5*CGFloat(i%2)
                    let y = (h+1)*CGFloat(i/2)
                    if count == 3{
                        h = i == 0 ? pv.frame.height : (pv.frame.height*0.5 - 1)
                        x = i == 2 ? pv.frame.width*0.5 : x
                    }else if count == 4 {
                        h = (pv.frame.height*0.5 - 1)
                    }
                    let picImg = UIImageView.init()
                    picImg.frame = CGRect(x:x, y:y, width: w, height: h)
                    pv.addSubview(picImg)
                    picImg.setImageWithURL(model?.url ?? "", placeholder: UIImage.init(color: RPColor.ShallowColor)!)
                }
                break
            default:
                break
            }
        }else{
            numsLabel.isHidden = true
            let videoImg = UIImageView.init()
            videoImg.frame = pv.bounds
            pv.addSubview(videoImg)
            videoImg.setImageWithURL(video?.converUrl ?? "", placeholder: UIImage.init(color: RPColor.ShallowColor)!)
        }
        
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
            converImgV.setImageWithURL(converURL!, placeholder: RPImage.init(color: RPColor.ShallowColor)!)
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
