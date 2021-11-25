//
//  RPMineTopicViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/20.
//

import UIKit

class RPMineTopicViewModel: NSObject {
    
    private lazy var label :UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    func getMineTopicLists(params:NSDictionary,
                           success:(_ datas: NSArray)->(),
                           failed:(_ error: NSError)->()) {
        let tt = NSMutableArray.init()
        
        let dict : NSDictionary! = NSDictionary(contentsOfFile: (Bundle.main.path(forResource: "RPTopicDatas", ofType: "plist")!))
        let array = dict["data"] as! NSArray
        
        for xxx in array {
            let dic = xxx as! NSDictionary
            let model = RPTopicModel.deserialize(from: dic)
            let type = dic["type"] as! String
            switch type {
            case "text":model?.type = .text
                break
            case "picture":model?.type = .pictures
                break
            case "article":model?.type = .article
                break
            case "video":model?.type = .video
                break
            default:  break
            }
            fix(model!)
            tt.add(model as Any)
        }
        success(tt)
    }
    
    func fix(_ model:RPTopicModel){
        switch model.type {
        case .text,.article:
            let width:CGFloat = SCREEN_WIDTH - 120
            label.font = UIFont.systemFont(ofSize: 15)
            label.frame = CGRect.init(x: 0, y: 0, width: width, height: 20)
            label.numberOfLines = 2
            label.text = model.text
            label.sizeToFit()
            model.textTotalH = CGFloat(ceilf(Float(label.frame.size.height)))
            model.cellH = model.textTotalH+20
            if model.type == .article {
                if model.artic.converUrl.count == 0 {
                    label.font = UIFont.systemFont(ofSize: 13)
                    label.frame = CGRect.init(x: 0, y: 0, width: width, height: 20)
                    label.numberOfLines = 2
                    label.text = model.artic.title
                    label.sizeToFit()
                    model.cellH += CGFloat(ceilf(Float(label.frame.size.height))) + 5
                }else{
                    model.cellH += 40
                }
            }
            break;
        case .pictures,.video:
            model.cellH = 120
            break
        }
    }
}
