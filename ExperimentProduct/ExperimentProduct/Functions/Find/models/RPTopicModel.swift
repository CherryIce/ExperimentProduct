//
//  RPTopicModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/5.
//

import UIKit
//import HandyJSON

//The hard thing to do and the right thing to do are usually the same thing.
//正确的事情，往往并不容易做到。
/**
 纯文本
 文本+多图
 文章链接
 文本+文章
 视频
 文本+视频
 */
enum RPTopicType {
    case text
    case pictures
    case video
    case article
}

class RPTopicModel: NSObject {
    var author = RPPersonModel()
    var text = ""
    var images = [RPImageModel]()
    var video = RPVideoModel()
    var artic = RPArticleModel()
    var location = ""
    var likes = [RPPersonModel]()
    var comments = [RPCommentModel]()
    var publishTime = ""
    var from = ""
    var permission = Int() // 0所有人 1屏蔽了一些人 2私密
    var type = RPTopicType.text //当前类型
    
    //自定义 附加信息
    var isMe :Bool = false //是否是自己发布的话题
    var textTotalH: CGFloat = 0 // 文本总高度
    var textCurrH: CGFloat = 0 //文本当前显示高度
    var textLimitH: CGFloat = 0 //限制文本显示高度
    var isExpand:Bool = false //是否是显示全文状态
    var midH:CGFloat = 0 // 中间区域高度
    var commentH:CGFloat = 0 // 点赞评论区域高度
    var cellH:CGFloat = 0 // 当前cell的总高度
    var photoCellSize:CGSize = .zero //布局大小 仅限于图片视频类型使用
    
    override init() {
        super.init()
    }
    
    convenience init(dict: NSDictionary) {
        self.init()
        if dict.object(forKey: "author") != nil{
            let dic = dict["author"] as! NSDictionary
            let model = RPPersonModel.init()
            model.userName = dic["userName"] as? String ?? ""
            model.userId = dic["userId"] as? String ?? ""
            model.headIconUrl = dic["headIconUrl"] as? String ?? ""
            author = model
        }
        text = dict["text"] as? String ?? ""
        location = dict["location"] as? String ?? ""
        publishTime = dict["publishTime"] as? String ?? ""
        from = dict["from"] as? String ?? ""
        permission = dict["permission"] as? Int ?? 0
        
        if dict.object(forKey: "video") != nil{
            let videoDic = dict["video"] as! NSDictionary
            let tv = RPVideoModel.init()
            tv.converUrl = videoDic["converUrl"] as? String ?? ""
            tv.videoPath = videoDic["videoPath"] as? String ?? ""
            tv.width = videoDic["width"] as? CGFloat ?? 0
            tv.height = videoDic["height"] as? CGFloat ?? 0
            video = tv
        }
        
        if dict.object(forKey: "article") != nil {
            let videoDic = dict["article"] as! NSDictionary
            let tv = RPArticleModel.init()
            tv.converUrl = videoDic["converUrl"] as? String ?? ""
            tv.url = videoDic["url"] as? String ?? ""
            tv.title = videoDic["title"] as? String ?? ""
            artic = tv
        }
        
        if dict.object(forKey: "images") != nil {
            let oneDicts = dict["images"] as? [NSDictionary]
            let tempArr_1 = NSMutableArray()
            for item in oneDicts! {
                let modelOne = RPImageModel.init()
                modelOne.url = item["url"] as? String ?? ""
                modelOne.width = item["width"] as? CGFloat ?? 0
                modelOne.height = item["height"] as? CGFloat ?? 0
                tempArr_1.add(modelOne)
            }
            images = tempArr_1 as! [RPImageModel]
        }
        
//        if dict.object(forKey: "likes") != nil {
//            let oneDicts2 = dict["likes"] as? [NSDictionary]
//            let tempArr_2 = NSMutableArray()
//            for item in oneDicts2! {
//                let modelOne = RPPersonModel.init()
//                modelOne.userName = item["userName"] as? String ?? ""
//                modelOne.userId = item["userId"] as? String ?? ""
//                modelOne.headIconUrl = item["headIconUrl"] as? String ?? ""
//                tempArr_2.add(modelOne)
//            }
//            likes = (tempArr_2 as? [RPPersonModel])!
//        }
        
//        if dict.object(forKey: "comments") != nil{
//            let oneDicts3 = dict["comments"] as? [NSDictionary]
//            let tempArr_3 = NSMutableArray()
//            for item in oneDicts3! {
//                let modelOne = RPCommentModel.init()
//                let replyD = item["replyPerson"] as! NSDictionary
//                let replay = RPPersonModel.init()
//                replay.userName = replyD["userName"] as? String ?? ""
//                replay.userId = replyD["userId"] as? String ?? ""
//                replay.headIconUrl = replyD["headIconUrl"] as? String ?? ""
//                modelOne.replyPerson = replay
//
//                tempArr_3.add(modelOne)
//            }
//            comments = (tempArr_3 as? [RPCommentModel])!
//        }
    }
}

class RPImageModel: NSObject {
    //图片链接
    var url = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
}

class RPVideoModel: NSObject {
    //封面链接
    var converUrl = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    //视频地址
    var videoPath = ""
}

class RPArticleModel: NSObject {
    //文章封面图
    var converUrl = ""
    //标题
    var title = ""
    //跳转链接
    var url = ""
}

class RPPersonModel: NSObject {
    //用户名
    var userName = ""
    //用户Id
    var userId = ""
    //用户头像
    var headIconUrl = ""
}

class RPCommentModel: NSObject {
    //评论人
    var replyPerson = RPPersonModel()
    //被评论人
    var byReplyPerson = RPPersonModel()
    //评论内容
    var content = ""
    //时间
    var dateTime = ""
}
