//
//  RPNiceModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/29.
//

import UIKit
import HandyJSON

class RPNiceModel: HandyJSON {
    
    var imageList = [RPImageModel]()
    
    var type = "" //类型 图片 视频
    var title = "" //主题
    var desc = "" //描述
    var keywords = "" //#标签🏷
    var datePublished = ""
    var uploadDate = ""
    var likes:Int = 0
    var isLiked:Bool = false
    var author = RPAuthorModel()
    
    var cover = RPImageModel()
    
    var contentH:CGFloat = 0
    var cellH:CGFloat = 0
    
    required init() {}
}

class RPAuthorModel: HandyJSON {
    var id = ""
    var officialVerified:Bool = false
    var type = "" //类型 个人/公司 or 普通/优质
    var name = ""
    var nickname = ""
    var image = "" //头像
    var url = "" //个人主页
    required init() {}
}

//看了下小红书网页的数据 打扰了
/**
 {
       "context": "http://schema.org/",
       "type": "WebPage",
       "name": "毛爹地道湘菜新店开业啦！人均不过百🌶",
       "headline": "毛爹地道湘菜新店开业啦！人均不过百🌶",
       "description": "老字号毛爹湘菜馆儿新分店终于开业啦‼️ 毛爹对于福田锝小伙伴真的再熟悉不过 对于我这个个忠实爱好者来说，真的期待已久~      新店不仅环境很好，服务、菜品都真的是湘菜中的天花板了！ 🌶️🌶️性价比居",
       "image": "https://ci.xiaohongshu.com/d8370a60-0c4e-26f5-1f92-48caa7?imageMogr2/format/jpg/quality/92/auto-orient/strip/crop/450x300/gravity/center",
       "datePublished": "2021-11-20T01:24:00",
       "uploadDate": "2021-11-20T01:24:00",
       "author": {
         "type": "Person",
         "name": "桃圆圆O",
         "image": "https://sns-avatar-qc.xhscdn.com/avatar/6134ef6b152a54e19b68c03a.jpg?imageView2/1/w/540/format/jpg",
         "url": "https://www.xiaohongshu.com/user/profile/5f911772000000000101d3f7"
       }
 }
 
 
 {
     "commentInfo":{
         "comments":[
             {
                 "ats":[

                 ],
                 "content":"排队久吗 有那种适合十个人左右的桌子吗 聚会想去",
                 "hashTags":[

                 ],
                 "id":"619a4e99000000000102b9de",
                 "likes":0,
                 "isLiked":false,
                 "targetNoteId":"6197ddd80000000001026ea7",
                 "subComments":[
                     {
                         "ats":[

                         ],
                         "content":"新分店暂时不用排队 还有包间～",
                         "hashTags":[

                         ],
                         "id":"619a4ed4000000002103b66f",
                         "targetCommentId":"619a4e99000000000102b9de",
                         "isLiked":false,
                         "likes":0,
                         "time":"2021-11-21 21:51",
                         "user":{
                             "id":"5f911772000000000101d3f7",
                             "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F6134ef6b152a54e19b68c03a.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                             "nickname":"桃圆圆O"
                         }
                     }
                 ],
                 "subCommentsTotal":1,
                 "time":"2021-11-21 21:50",
                 "user":{
                     "id":"61267409000000000101faca",
                     "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F61811b8f0e891282ccdb0e05.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                     "nickname":"lemonbitter"
                 }
             },
             {
                 "ats":[

                 ],
                 "content":"啥时候分店开到北京来啊，看着就很美味",
                 "hashTags":[

                 ],
                 "id":"619a499b0000000021001384",
                 "likes":0,
                 "isLiked":false,
                 "targetNoteId":"6197ddd80000000001026ea7",
                 "subComments":[
                     {
                         "ats":[

                         ],
                         "content":"手动圈毛爹哈哈哈",
                         "hashTags":[

                         ],
                         "id":"619a49ec000000002103a4e5",
                         "targetCommentId":"619a499b0000000021001384",
                         "isLiked":false,
                         "likes":0,
                         "time":"2021-11-21 21:30",
                         "user":{
                             "id":"5f911772000000000101d3f7",
                             "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F6134ef6b152a54e19b68c03a.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                             "nickname":"桃圆圆O"
                         }
                     }
                 ],
                 "subCommentsTotal":1,
                 "time":"2021-11-21 21:28",
                 "user":{
                     "id":"5fb8b15b000000000101db8b",
                     "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F60142f47eef5383ed5f06309.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                     "nickname":"微笑みの悟空"
                 }
             },
             {
                 "ats":[

                 ],
                 "content":"好好吃呀",
                 "hashTags":[

                 ],
                 "id":"619b7022000000002003dc3e",
                 "likes":0,
                 "isLiked":false,
                 "targetNoteId":"6197ddd80000000001026ea7",
                 "subComments":[

                 ],
                 "subCommentsTotal":0,
                 "time":"2021-11-22 18:25",
                 "user":{
                     "id":"587d762b50c4b4221d575fe1",
                     "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F5ffdcda982ab61daed85b328.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                     "nickname":"AI婧"
                 }
             },
             {
                 "ats":[

                 ],
                 "content":"扣肉我的爱！一看就流口水了～",
                 "hashTags":[

                 ],
                 "id":"619b136c00000000210009ab",
                 "likes":0,
                 "isLiked":false,
                 "targetNoteId":"6197ddd80000000001026ea7",
                 "subComments":[

                 ],
                 "subCommentsTotal":0,
                 "time":"2021-11-22 11:50",
                 "user":{
                     "id":"555705bf67bc651675f40549",
                     "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F5f38114fef01b60001fb353e.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                     "nickname":"早買晚買都是要買"
                 }
             },
             {
                 "ats":[

                 ],
                 "content":"最近有套餐优惠活动吗",
                 "hashTags":[

                 ],
                 "id":"619b0a9c000000002003c0f5",
                 "likes":0,
                 "isLiked":false,
                 "targetNoteId":"6197ddd80000000001026ea7",
                 "subComments":[

                 ],
                 "subCommentsTotal":0,
                 "time":"2021-11-22 11:12",
                 "user":{
                     "id":"5db51522000000000100984d",
                     "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F61273b7535fae1327949fc1a.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                     "nickname":"刘二珂"
                 }
             }
         ],
         "targetNoteId":"6197ddd80000000001026ea7",
         "targetNoteUserId":"5f911772000000000101d3f7",
         "commentsLevel1Count":8,
         "commentsTotal":10,
         "pageSize":5
     },
     "noteInfo":{
         "ats":[

         ],
         "likes":0,
         "collects":0,
         "shareCount":0,
         "comments":0,
         "title":"毛爹地道湘菜新店开业啦！人均不过百🌶",
         "desc":"老字号毛爹湘菜馆儿新分店终于开业啦‼️\n毛爹对于福田锝小伙伴真的再熟悉不过\n对于我这个个忠实爱好者来说，真的期待已久~\n\t\n新店不仅环境很好，服务、菜品都真的是湘菜中的天花板了！\n🌶️🌶️性价比居然还特别高，真的太给力了！\n.\n🎆环境\n环境整洁干净，特别大气的装修。\n给人很有档次的感觉，古朴的味道很浓郁，现代与古代的完美结合。非常简约的感觉\n.\n🙋服务\n店员服务态度很好，上餐速度也特别快，有求必应，整体的穿戴也非常整齐~\n🌶️每次去bi点菜品：\n❤蒸扣肉：扣肉真的是绝绝子！肥肉相间的肉质，一口吃下去，口感香浓丝滑。肥而不腻，肥的地方入口即化，汤汁特别棒！拌饭巨香\n❤茶油蒸回头鱼：鱼的肉质也太嫩啦！又嫩又白的鱼肉，QQ弹弹的，茶味儿香浓，鱼肉蒸出来的味道特别鲜美，这个好评！！\n❤干锅香辣土鸡：干锅系列好好吃！香辣的味道吃起来特别爽，土鸡的味道很原生态，正宗湖南辣椒做出来的味道就是那味儿！鸡肉一点儿都不柴，干锅儿的味道特别好\n❤鸡汁小笋：笋做的真的好鲜嫩！这个小菜搭配着肉一起吃，解腻又开胃！笋挑选的都特别好，鸡汁的搭配爷恰到好处！！\n.\n🏠店名：毛爹·地道湘菜\n📍地址：泰然八路深业泰然大厦C座1楼\n🕓营业时间：11:00--14:00 16:00--21:00\n💰人均：84\n\t\n#深圳福田美食 #地道湖南菜 #深圳湘辣菜 #深圳美食 #深圳老字号 ",
         "id":"6197ddd80000000001026ea7",
         "imageList":[
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002Fd8370a60-0c4e-26f5-1f92-48caa77b1cd3?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":426,
                 "height":568,
                 "fileId":"d8370a60-0c4e-26f5-1f92-48caa77b1cd3",
                 "traceId":"cbc37003-0511-3fdd-9452-4baceb9eb1aa"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002F090c73d4-1695-9718-72f4-6a64c3f206aa?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":426,
                 "height":568,
                 "fileId":"090c73d4-1695-9718-72f4-6a64c3f206aa",
                 "traceId":"9c514e35-ca1e-346c-b0ae-ed78b1890089"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002Ffe1bf9d2-f8c1-fee4-0064-0bdb5c5d6dd3?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":385,
                 "height":514,
                 "fileId":"fe1bf9d2-f8c1-fee4-0064-0bdb5c5d6dd3",
                 "traceId":"28c26a7b-d4e7-3dc9-81bc-9288be4897ba"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002Fb561624f-b8da-0c42-fc65-e3404e26dc9e?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":354,
                 "height":472,
                 "fileId":"b561624f-b8da-0c42-fc65-e3404e26dc9e",
                 "traceId":"b4205558-0d71-3e06-9a4a-a5e8def45f04"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002F19525528-4137-1ce8-b113-f8e828e5848b?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":329,
                 "height":438,
                 "fileId":"19525528-4137-1ce8-b113-f8e828e5848b",
                 "traceId":"f5e10331-09a8-38b1-a615-76461e8c231a"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002F334d3e9e-5e54-6834-12dd-7a804bbf4c0a?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":416,
                 "height":555,
                 "fileId":"334d3e9e-5e54-6834-12dd-7a804bbf4c0a",
                 "traceId":"1c8c05ab-eaa3-3c4e-b4c0-127f4de479a5"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002Fe8170932-9f19-c9a9-a885-7aa8a1e010c9?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":426,
                 "height":568,
                 "fileId":"e8170932-9f19-c9a9-a885-7aa8a1e010c9",
                 "traceId":"7ca5a0f7-522d-3656-ae15-afc01df4cddd"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002F8936143f-ae58-4339-bc2e-a0bcb9616e6a?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":426,
                 "height":568,
                 "fileId":"8936143f-ae58-4339-bc2e-a0bcb9616e6a",
                 "traceId":"e27f3b93-f948-3b48-b830-19876bbcaaa4"
             },
             {
                 "url":"\u002F\u002Fci.xiaohongshu.com\u002F80fc4876-1fc2-d8df-1edf-9cc100b98503?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
                 "width":372,
                 "height":496,
                 "fileId":"80fc4876-1fc2-d8df-1edf-9cc100b98503",
                 "traceId":"ab2afeba-000c-3f52-9482-b5882120c0b3"
             }
         ],
         "cover":{
             "url":"\u002F\u002Fci.xiaohongshu.com\u002Fd8370a60-0c4e-26f5-1f92-48caa77b1cd3?imageView2\u002F2\u002Fw\u002F1080\u002Fformat\u002Fjpg",
             "width":426,
             "height":568,
             "fileId":"d8370a60-0c4e-26f5-1f92-48caa77b1cd3",
             "traceId":"cbc37003-0511-3fdd-9452-4baceb9eb1aa"
         },
         "isLiked":false,
         "time":"2021-11-20 01:24",
         "type":"normal",
         "hashTags":[
             {
                 "id":"5bf4b48de8390300012950b8",
                 "name":"深圳福田美食",
                 "type":"topic"
             },
             {
                 "id":"608a1e0300000000010082d9",
                 "name":"地道湖南菜",
                 "type":"topic"
             },
             {
                 "id":"61630642000000000100110f",
                 "name":"深圳湘辣菜",
                 "type":"topic"
             },
             {
                 "id":"57f126768472706d326fe998",
                 "name":"深圳美食",
                 "type":"topic"
             },
             {
                 "id":"5e60f6450000000001002846",
                 "name":"深圳老字号",
                 "type":"topic"
             }
         ],
         "cooperateBinds":[

         ],
         "isCollected":false,
         "generatedTitle":"毛爹地道湘菜新店开业啦！人均不过百🌶",
         "keywords":[

         ],
         "categories":[

         ],
         "categoriesIndex":[

         ],
         "seoMeta":{
             "title":"毛爹地道湘菜新店开业啦！人均不过百🌶_湘菜_干锅_美食_老字号_土鸡_鱼肉_扣肉_湘菜馆_鸡肉_深圳福田美食_美食探店_美食_美食探店_餐厅探店",
             "description":"老字号毛爹湘菜馆儿新分店终于开业啦 毛爹对于福田锝小伙伴真的再熟悉不过 对于我这个个忠实爱好者来说，真的期待已久~ 新店不仅环境很好，服务、菜品都真的是湘菜中的天花板了！ 性价比居然还特别高，真的太给",
             "keywords":"湘菜,干锅,美食,老字号,土鸡,鱼肉,扣肉,湘菜馆,鸡肉,深圳福田美食,美食探店,美食,美食探店,餐厅探店",
             "image":[
                 "https:\u002F\u002Fci.xiaohongshu.com\u002Fd8370a60-0c4e-26f5-1f92-48caa77b1cd3?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002F090c73d4-1695-9718-72f4-6a64c3f206aa?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002Ffe1bf9d2-f8c1-fee4-0064-0bdb5c5d6dd3?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002Fb561624f-b8da-0c42-fc65-e3404e26dc9e?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002F19525528-4137-1ce8-b113-f8e828e5848b?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002F334d3e9e-5e54-6834-12dd-7a804bbf4c0a?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002Fe8170932-9f19-c9a9-a885-7aa8a1e010c9?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002F8936143f-ae58-4339-bc2e-a0bcb9616e6a?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter",
                 "https:\u002F\u002Fci.xiaohongshu.com\u002F80fc4876-1fc2-d8df-1edf-9cc100b98503?imageMogr2\u002Fformat\u002Fjpg\u002Fquality\u002F92\u002Fauto-orient\u002Fstrip\u002Fcrop\u002F450x300\u002Fgravity\u002Fcenter"
             ]
         },
         "inCensor":false,
         "censorTip":"",
         "user":{
             "bannerImage":"",
             "fans":0,
             "follows":0,
             "gender":1,
             "id":"5f911772000000000101d3f7",
             "nickname":"桃圆圆O",
             "notes":0,
             "boards":0,
             "location":"中国 广东 深圳",
             "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F6134ef6b152a54e19b68c03a.jpg?imageView2\u002F1\u002Fw\u002F540\u002Fformat\u002Fjpg",
             "collected":0,
             "desc":"🍬时尚｜穿搭｜好物｜旅拍｜艺术\n📍深圳、广州，香港、澳门\n📮7 9 1 7 8 8 7 4 5 @qq.com\n🎓MFA",
             "liked":0,
             "officialVerified":false,
             "redOfficialVerifyShowIcon":false,
             "level":{
                 "image":"https:\u002F\u002Ffe-static.xhscdn.com\u002Fformula-static\u002Fuser-growth\u002Fpublic\u002F11f_05e45936bee244cb9fafd4768b8f6810.png",
                 "name":"金冠薯"
             },
             "fstatus":"none",
             "redOfficialVerifyIconType":0,
             "red_id":"taotao2325",
             "officialVerifyIcon":"",
             "officialVerifyName":"",
             "isFollowed":false
         },
         "poi":{

         }
     },
     "noteType":"normal",
     "userId":"5f911772000000000101d3f7",
     "player":null,
     "panelData":[
         {
             "id":"61206cef000000002103bd4c",
             "title":"章鱼吃深圳🌶️福田湘菜之光宝藏店铺湘椒❗",
             "type":"normal",
             "likes":43,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F28fa9190-0ae0-e317-64fe-bc05f2c2d375?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1280,
                 "height":1706,
                 "fileId":"28fa9190-0ae0-e317-64fe-bc05f2c2d375"
             },
             "time":"2021-08-21 11:03",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5abf9e76e8ac2b2dded701e7",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F611784aff9aaf866b4f257a2.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"章鱼吃什么",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_2_61206cef000000002103bd4c_-1_"
         },
         {
             "id":"61125c7b000000000102bdeb",
             "title":"深圳探店|湘阁里辣🌶 广东人都超爱的湘菜",
             "type":"normal",
             "likes":48,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F0e27b91b-41aa-86b5-4cae-c6747f8873a8?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1280,
                 "height":1706,
                 "fileId":"0e27b91b-41aa-86b5-4cae-c6747f8873a8"
             },
             "time":"2021-08-10 19:01",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5bd434c4313b6500010172a9",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F60be393c341f1be93644c12a.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"尤腻腻酱",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_3_61125c7b000000000102bdeb_-1_"
         },
         {
             "id":"611d55b90000000021035cbf",
             "title":"河源探店｜🌶️河源top1正宗地道湘菜馆🥘",
             "type":"normal",
             "likes":36,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F9f5ade71-5b07-5b97-1525-f97f51bdf4cf?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1280,
                 "height":1706,
                 "fileId":"9f5ade71-5b07-5b97-1525-f97f51bdf4cf"
             },
             "time":"2021-08-19 02:47",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5af2c49ce8ac2b307e4a1e72",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F5ec22bcddb545b0001b9801b.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"Kaka",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_4_611d55b90000000021035cbf_-1_"
         },
         {
             "id":"611a59de000000002103bd2e",
             "title":"深圳美食|正宗地道的宝藏川湘馆🍱人均80+",
             "type":"normal",
             "likes":394,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F360c6fab-c82b-8097-dd87-47df92a2f59c?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":640,
                 "height":853,
                 "fileId":"360c6fab-c82b-8097-dd87-47df92a2f59c"
             },
             "time":"2021-08-16 20:28",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"60aa185d0000000001003c1e",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F60aa1902038cade4fa8de330.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"大禾",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_5_611a59de000000002103bd2e_-1_"
         },
         {
             "id":"611e88a7000000002103d1c6",
             "title":"呼和浩特探店｜必去地道湘菜🌶️",
             "type":"normal",
             "likes":20,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F5c821ea3-ccb6-7cbf-d323-77e576393900?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":426,
                 "height":568,
                 "fileId":"5c821ea3-ccb6-7cbf-d323-77e576393900"
             },
             "time":"2021-08-20 00:36",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5bd699e8f7e8b957f12ac69a",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F619601557ca337e853543a28.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"Tingt.",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_6_611e88a7000000002103d1c6_-1_"
         },
         {
             "id":"611dad36000000002103a05a",
             "title":"深圳美食｜人均50的超下饭湘菜",
             "type":"normal",
             "likes":11,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002Ffdd7f38e-a4a9-0c9d-c766-a08cb2c3a778?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":404,
                 "height":539,
                 "fileId":"fdd7f38e-a4a9-0c9d-c766-a08cb2c3a778"
             },
             "time":"2021-08-19 09:00",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5b6704314b5238000179bdde",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F5f584d9f39dd560001dd9ba0.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"可乐不加冰~",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_7_611dad36000000002103a05a_-1_"
         },
         {
             "id":"61028774000000000102910d",
             "title":"深圳美食\u002F在深圳也可以吃到费大厨辣椒炒肉",
             "type":"normal",
             "likes":0,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F76ce2a92-fc78-4a28-f571-dc684b9856e0?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1080,
                 "height":1439,
                 "fileId":"76ce2a92-fc78-4a28-f571-dc684b9856e0"
             },
             "time":"2021-07-29 18:48",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5ae498fc11be102992e33e4d",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F5ae498fc11be102992e33e4d.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"食神（爱吃如命）",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_8_61028774000000000102910d_-1_"
         },
         {
             "id":"611ddf37000000002103e022",
             "title":"天津美食||吃湘菜，到湘芸！",
             "type":"normal",
             "likes":7,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F0fcb5edf-aae9-d5ca-02bb-dfc2cac7fc67?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1080,
                 "height":1439,
                 "fileId":"0fcb5edf-aae9-d5ca-02bb-dfc2cac7fc67"
             },
             "time":"2021-08-19 12:33",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5b6584fb11be1074680bb0b6",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F6102a626ae310f6873f2407a.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"叫我大琦琦💫🍔🥪🎂🍮",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_9_611ddf37000000002103e022_-1_"
         },
         {
             "id":"61107488000000002103cd34",
             "title":"一口入湘❤️湘印湖南菜",
             "type":"normal",
             "likes":10,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002Fe39515d0-c3eb-5cca-2db1-7ad170f3e688?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":1280,
                 "height":1706,
                 "fileId":"e39515d0-c3eb-5cca-2db1-7ad170f3e688"
             },
             "time":"2021-08-09 08:19",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5bd96fc57ab6e400019156a2",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F6178090746325b2d0761ca9e.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"爱吃爱逛的张能能",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_10_61107488000000002103cd34_-1_"
         },
         {
             "id":"61027296000000000102e2e2",
             "title":"深圳美食｜打卡好吃又划算的费大厨辣椒炒肉",
             "type":"normal",
             "likes":11,
             "isLiked":false,
             "cover":{
                 "url":"https:\u002F\u002Fci.xiaohongshu.com\u002F791603c8-78f9-8b60-e5c4-d51d63c2bb85?imageView2\u002F2\u002Fw\u002F540\u002Fformat\u002Fjpg",
                 "gifUrl":"",
                 "width":540,
                 "height":720,
                 "fileId":"791603c8-78f9-8b60-e5c4-d51d63c2bb85"
             },
             "time":"2021-07-29 17:19",
             "comments":0,
             "collects":0,
             "user":{
                 "id":"5c146fca00000000060075ee",
                 "image":"https:\u002F\u002Fsns-avatar-qc.xhscdn.com\u002Favatar\u002F60118af33d095c6cfaedc81b.jpg?imageView2\u002F2\u002Fw\u002F80\u002Fformat\u002Fjpg",
                 "nickname":"没事偷着玩",
                 "redOfficialVerifyType":0,
                 "redOfficialVerifyShowIcon":false,
                 "officialVerified":false
             },
             "trackId":"txt_11_61027296000000000102e2e2_-1_"
         }
     ],
     "panelContent":"相关笔记",
     "isLoading":false,
     "isSougou":false
 }
 */
