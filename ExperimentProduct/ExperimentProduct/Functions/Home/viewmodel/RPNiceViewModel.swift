//
//  RPNiceViewModel.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/29.
//

import UIKit

class RPNiceViewModel: NSObject {
    
    func getNicesLists(params:NSDictionary,
                       success:(_ datas: NSArray)->(),
                       failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        let tt = NSMutableArray.init()
        for _ in 0...10 {
            let width:CGFloat = CGFloat(arc4random()%100 + 300)
            let height:CGFloat = CGFloat(arc4random()%100 + 80)
            let item = RPNiceModel.init()
            item.converUrl = ""
            item.content = "just so so , bala bala"
            item.converW = width
            item.converH = height
            item.headImgUrl = ""
            item.userName = "user 007"
            item.likes = Int(arc4random()%1000 + 1)
            item.cellH = item.converH + 10 + RPTools.calculateTextSize(item.content, size: CGSize.init(width: (SCREEN_WIDTH - 3 * 10)/2, height: 100), font: UIFont.systemFont(ofSize: 16)).height + 10 + 20 + 10
            tt.add(item)
        }
        success(tt)
        
        //        failed(NSError.init())
    }
    
}
