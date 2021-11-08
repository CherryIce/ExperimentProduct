//
//  RPTopViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/5.
//

import UIKit
import ActiveLabel

protocol RPTopViewCellDelegate:NSObjectProtocol
{
    func selectURLInTopic(_ cell:RPTopViewCell,url:String)
    func expandTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath)
    func commentTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath)
    func updatePermission(_ cell:RPTopViewCell,indexPath:IndexPath)
    func deleteTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath)
    func likeTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath)
    func locationClickInTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath)
    func photoListClickInTheTopic(_ cell:RPTopViewCell,indexPath:IndexPath,index:Int)
}

class RPTopViewCell: UITableViewCell {

    @IBOutlet weak var headIconV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: ActiveLabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var middleContentView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var permissionBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var textH: NSLayoutConstraint!
    @IBOutlet weak var moreBtnH: NSLayoutConstraint!
    @IBOutlet weak var middleContentH: NSLayoutConstraint!
    @IBOutlet weak var commentH: NSLayoutConstraint!
    @IBOutlet weak var commentTop: NSLayoutConstraint!
    @IBOutlet weak var locationH: NSLayoutConstraint!
    
    @IBOutlet weak var fromLeft: NSLayoutConstraint!
    @IBOutlet weak var permissionLeft: NSLayoutConstraint!
    @IBOutlet weak var permissionWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteLeft: NSLayoutConstraint!
    
    private weak var delegate:RPTopViewCellDelegate?
    private var indexPath = IndexPath()
    private var model = RPTopicModel()
    private var photoListView:RPTopicPhotoListView?
    private var videoView:RPTopicVideoView?
    private var artcleView:RPTopicArtcleView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headIconV.layercornerRadius(cornerRadius: 4)
        headIconV.backgroundColor = RPColor.Separator
        contentLabel.delegate = self
        let customType = ActiveType.custom(pattern: "\\b((?:https?://|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>???“”‘’]))")
        contentLabel.enabledTypes = [customType]//enabledTypes = [.mention,.hashtag,.url]
        contentLabel.customColor[customType] = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
        contentLabel.customSelectedColor[customType] = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        //设置标签的行数
        contentLabel.numberOfLines = 0
        //设置标签的行间距
        contentLabel.lineSpacing = 4
        //设置动态标签对象的文字颜色
        contentLabel.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
//        //设置动态标签对象的主题标签文字的颜色
//        contentLabel.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
//        //设置动态标签的提及文字的颜色
//        contentLabel.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
//        //设置动态标签的网址文字的颜色
//        contentLabel.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
//        //设置动态标签对象的网址被选中时的颜色
//        contentLabel.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(model: RPTopicModel, delegate: RPTopViewCellDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.model = model
        fixUI()
    }
    
    func fixUI() {
        //是不是分享
        if model.from.count == 0 {
            fromLeft.constant = 0
            fromLabel.text = ""
        }else{
            fromLeft.constant = 5
            fromLabel.text = model.from
        }
        //有没有开放显示发布地址
        if model.location.count == 0 {
            locationH.constant = 0
            locationView.isHidden = true
        }else{
            locationView.isHidden = false
            locationBtn.setTitle(model.location, for: .normal)
            locationH.constant = 25
        }
        //是不是自己
        deleteBtn.isHidden = !model.isMe
        deleteLeft.constant = model.isMe ? 5 : 0
        //权限
        permissionBtn.isHidden = model.permission == 0
        permissionBtn.isHidden = !model.isMe
        permissionLeft.constant = !permissionBtn.isHidden ? 5 : 0
        permissionWidth.constant = !permissionBtn.isHidden ? 20 : 0
        
        textH.constant = model.textCurrH
        moreBtn.isHidden = model.textTotalH <= model.textLimitH
        moreBtnH.constant = moreBtn.isHidden ? 0 : 30
        moreBtn.isSelected = model.isExpand
        
        middleContentH.constant = model.midH
        middleContentView.isHidden = model.midH == 0
        
        contentLabel.text = model.text
        
        commentView.isHidden = model.commentH == 0
        commentH.constant = model.commentH
        commentTop.constant = commentView.isHidden ? 0 : 10
        
        photoListView?.removeFromSuperview()
        photoListView = nil
        videoView?.removeFromSuperview()
        videoView = nil
        artcleView?.removeFromSuperview()
        artcleView = nil
        switch model.type {
        case .text:
            break
        case .pictures:
            if photoListView == nil {
                photoListView = RPTopicPhotoListView.init()
                middleContentView.addSubview(photoListView!)
                photoListView?.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalToSuperview()
                })
            }
            photoListView?.itemSize = model.photoCellSize
            photoListView?.dataArray = model.images
            photoListView?.callBack({ (indexPath, currView) in
                if (self.delegate != nil) {
                    self.delegate?.photoListClickInTheTopic(self, indexPath: self.indexPath, index: indexPath.item)
                }
            })
            break
        case .article:
            if artcleView == nil {
                artcleView = RPTopicArtcleView.init()
                middleContentView.addSubview(artcleView!)
                artcleView?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview().offset(5)
                    make.bottom.equalToSuperview().offset(-5)
                    make.right.equalToSuperview().offset(50)
                })
                artcleView?.initWithTitle(model.artic.title, converURL: model.artic.converUrl, block: {
                    if (self.delegate != nil) {
                        self.delegate?.selectURLInTopic(self, url: self.model.artic.url)
                    }
                })
            }
            break
        case .video:
            if videoView == nil {
                videoView = RPTopicVideoView.init()
                middleContentView.addSubview(videoView!)
                videoView?.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalToSuperview()
                })
            }
            videoView?.itemSize = model.photoCellSize
            videoView?.path = URL.init(string: model.video.videoPath)
            videoView?.clickVideoCallBack = {
                if (self.delegate != nil) {
                    self.delegate?.photoListClickInTheTopic(self, indexPath: self.indexPath, index: 0)
                }
            }
            break
        }
    }
    
    @IBAction func expand(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.expandTheTopic(self, indexPath:indexPath )
        }
    }
    
    @IBAction func locationSearch(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.locationClickInTheTopic(self, indexPath: indexPath)
        }
    }
    
    @IBAction func updatePermission(_ sender: Any) {
        if (self.delegate != nil) {
            self.delegate?.updatePermission(self, indexPath: indexPath)
        }
    }
    
    @IBAction func deleteThisTopic(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.deleteTheTopic(self, indexPath: indexPath)
        }
    }
    
    
    @IBAction func like_comment_click(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.likeTheTopic(self, indexPath: indexPath)
        }
    }
}

extension RPTopViewCell:ActiveLabelDelegate {
    func didSelect(_ text: String, type: ActiveType) {
        if (self.delegate != nil) {
            self.delegate?.selectURLInTopic(self, url: text)
        }
    }
}
