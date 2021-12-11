//
//  RPTopicModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/5.
//

import UIKit
import HandyJSON
import IGListKit

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

class RPTopicModel: HandyJSON {
    var author = RPPersonModel()
    var text = ""
    var images: [RPImageModel]! = []
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
    
    required init() {}
}

class RPImageModel: HandyJSON {
    //图片链接
    var url = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    required init() {}
}

class RPVideoModel: HandyJSON {
    //封面链接
    var converUrl = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    //视频地址
    var videoPath = ""
    required init() {}
}

class RPArticleModel: HandyJSON {
    //文章封面图
    var converUrl = ""
    //标题
    var title = ""
    //跳转链接
    var url = ""
    required init() {}
}

class RPPersonModel: HandyJSON {
    //用户名
    var userName = ""
    //用户Id
    var userId = ""
    //用户头像
    var headIconUrl = ""
    required init() {}
}

class RPCommentModel: HandyJSON {
    //评论人
    var replyPerson = RPPersonModel()
    //被评论人
    var byReplyPerson = RPPersonModel()
    //评论内容
    var content = ""
    //时间
    var dateTime = ""
    required init() {}
}
