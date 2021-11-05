//
//  RPTopicViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/5.
//

import UIKit
import ActiveLabel

class RPTopicViewModel: NSObject {
    
    func getTopicLists(params:NSDictionary,
                       success:(_ datas: NSArray)->(),
                       failed:(_ error: NSError)->()) {
        let tt = NSMutableArray.init()
        let ptt = NSMutableArray.init()
        for i in 0 ..< 20 {
            let person = RPPersonModel.init()
            person.userId = String(format: "%02d", i)
            person.userName = person.userId
            person.headIconUrl = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn.sinaimg.cn%2Fsinakd10114%2F555%2Fw700h655%2F20200305%2Fb9ee-iqmtvwu8356931.jpg&refer=http%3A%2F%2Fn.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1638686632&t=835a92395bfdff2311545d5012d134bc"
            ptt.add(person)
        }
        
        let model = RPTopicModel.init()
        model.type = .text
        model.text = "明月几时有？把酒问青天。"
        model.author = ptt.firstObject as! RPPersonModel
        fixxxxx(model)
        tt.add(model)
        
        let model1 = RPTopicModel.init()
        model1.type = .text
        model1.text = "明月几时有？把酒问青天。www.google.com?login=2021, 不知天上宫阙，今夕是何年。13612341234,我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间？转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。"
        model1.author = ptt[1] as! RPPersonModel
        fixxxxx(model1)
        tt.add(model1)
        success(tt)
    }
    
    func fixxxxx(_ model:RPTopicModel){
        var midH:CGFloat = 0
        let midW = SCREEN_WIDTH - 66*2
        if model.images.count > 0 {
            if model.images.count == 1 {
                let imgModel = model.images.first!
                let rate = imgModel.width / imgModel.height
                //根据比例看情况而定 可以限制宽高最大比例和最大值
                if rate < 0.5 {
                    midH = 128
                }else if rate > 2 {
                    midH = 256
                }else{
                    midH = 200
                }
            }
            else if model.images.count == 2 || model.images.count == 4 {
                //这里+1是为了打破colletionview一行布局三个的规律
                let singleWidth = (midW - 2 * 10)/3 + 1 //每行3个2个间隙
                let row = model.images.count/2
                midH = (singleWidth + 10) * CGFloat(row)
            }
            else {
                let singleWidth = (midW - 2 * 10)/3
                var row = model.images.count/3
                if model.images.count%3 != 0 {
                    row += 1
                }
                midH = (singleWidth + 10) * CGFloat(row-1)
            }
        }
        
        if model.type == .video || model.type == .textAndVideo {
            let rate = model.video.width / model.video.height
            //根据比例看情况而定 可以限制宽高最大比例和最大值
            if rate < 0.5 {
                midH = 128
            }else if rate > 2 {
                midH = 256
            }else{
                midH = 200
            }
        }
        
        if model.type == .article || model.type == .textAndArticle {
            midH = 72
        }
        
        let width:CGFloat = SCREEN_WIDTH - 66 - 16
        var expand:CGFloat = 0
        if model.text.count > 0 {
            let label = ActiveLabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 20))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.lineSpacing = 4
            label.text = model.text
            label.sizeToFit()
            model.textTotalH = CGFloat(ceilf(Float(label.frame.size.height)))
            model.textCurrH = (model.textTotalH > 90) ? 90 : model.textTotalH
            expand = (model.textTotalH > 90) ? 30 : 0
        }
        
        var commentH:CGFloat = 0
        if model.likes.count != 0 {
            //点赞做成一个文本的话就是计算文本的高度 把💖和名字拼成一个字符串算高度就可以了
            commentH += 20 //暂时写死
        }
        
        if model.comments.count != 0 {
            //谁回复谁:内容  计算高度和
            commentH += CGFloat(20 * model.comments.count)
        }
        model.commentH = commentH
        
        var totalH:CGFloat = 0
        let h = RPTools.calculateTextSize(model.author.userName, size: CGSize.init(width:width, height: CGFloat(HUGE)), font: UIFont.systemFont(ofSize: 16)).height
        let userNameH = CGFloat(ceilf(Float(h)))
        let locationH:CGFloat = (model.location.count>0) ? 25 :0
        
        //16+名字高度+10+文本高度+显示全文按钮高度+中间视图+地址+时间
        totalH = 16+userNameH+10+model.textCurrH+expand+midH+locationH+20
        if commentH == 0 {
            totalH += 10
        }else{
            totalH += (10+commentH+10)
        }
        model.cellH = totalH
    }
}
