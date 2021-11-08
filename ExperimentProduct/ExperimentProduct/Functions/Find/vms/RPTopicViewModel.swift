//
//  RPTopicViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/5.
//

import UIKit
import ActiveLabel

class RPTopicViewModel: NSObject {
    
    private lazy var label :ActiveLabel = {
        let label = ActiveLabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.lineSpacing = 4
        return label
    }()
    
    func getTopicLists(params:NSDictionary,
                       success:(_ datas: NSArray)->(),
                       failed:(_ error: NSError)->()) {
        let tt = NSMutableArray.init()
        
        let dict : NSDictionary! = NSDictionary(contentsOfFile: (Bundle.main.path(forResource: "RPTopicDatas", ofType: "plist")!))
        let array = dict["data"] as! NSArray
        
//        let model = RPTopicModel.init(jsonData: dict)
        
        for xxx in array {
            let dic = xxx as! NSDictionary
//            let model = RPTopicModel.deserialize(from: dic)
            
            let model = RPTopicModel.init(dict: dic)
            let type = dic["type"] as! String
            switch type {
            case "text":model.type = .text
                break
            case "picture":model.type = .pictures
                break
            case "article":model.type = .article
                break
            case "video":model.type = .video
                break
            default:  break
            }
            fixxxxx(model)
            tt.add(model)
        }
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
                    midH = 256
                    model.photoCellSize = CGSize.init(width: midH/2, height: midH)
                }else if rate > 2 {
                    midH = 128
                    model.photoCellSize = CGSize.init(width: midH*2, height: midH)
                }else{
                    //随便写的 实际情况按比例算
                    midH = 100
                    model.photoCellSize = CGSize.init(width: 100, height: 90)
                }
            }
            else if model.images.count == 2 || model.images.count == 4 {
                //这里+1是为了打破colletionview一行布局三个的规律
                let singleWidth = ceil((midW - 2 * 5)/3+1)
                let row = model.images.count/2
                midH = (singleWidth + 5) * CGFloat(row)
                model.photoCellSize = CGSize.init(width: singleWidth, height: singleWidth)
            }
            else {
                let singleWidth = (midW - 2 * 5)/3
                var row = model.images.count/3
                if model.images.count%3 != 0 {
                    row += 1
                }
                midH = (singleWidth + 5) * CGFloat(row)
                model.photoCellSize = CGSize.init(width: singleWidth, height: singleWidth)
            }
        }
        
        if model.type == .video {
            let rate = model.video.width / model.video.height
            //根据比例看情况而定 可以限制宽高最大比例和最大值
            if rate < 0.5 {
                midH = 256
                model.photoCellSize = CGSize.init(width: midH/2, height: midH)
            }else if rate > 2 {
                midH = 128
                model.photoCellSize = CGSize.init(width: midH*2, height: midH)
            }else{
                //随便写的 实际情况按比例算
                midH = 100
                model.photoCellSize = CGSize.init(width: 100, height: 90)
            }
        }
        
        if model.type == .article {
            midH = 50
        }
        
        let width:CGFloat = SCREEN_WIDTH - 66 - 16
        var expand:CGFloat = 0
        if model.text.count > 0 {
            label.frame = CGRect.init(x: 0, y: 0, width: width, height: 20)
            label.numberOfLines = 0
            label.text = model.text
            label.sizeToFit()
            model.textTotalH = CGFloat(ceilf(Float(label.frame.size.height)))
            
            label.numberOfLines = 4
            label.sizeToFit()
            model.textLimitH = CGFloat(ceilf(Float(label.frame.size.height)))
            
            model.textCurrH = (model.textTotalH > model.textLimitH) ? model.textLimitH : model.textTotalH
            expand = (model.textTotalH > model.textLimitH) ? 30 : 0
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
        
        model.midH = midH
        //16+名字高度+10+文本高度+显示全文按钮高度+中间视图+地址+时间
        totalH = 16+userNameH+10+model.textCurrH+expand+model.midH+locationH+20
        if commentH == 0 {
            totalH += 10
        }else{
            totalH += (10+commentH+10)
        }
        model.cellH = totalH
    }
}
