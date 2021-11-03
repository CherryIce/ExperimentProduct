//
//  RPNiceViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/29.
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
            let height:CGFloat = CGFloat(arc4random()%100 + 250)
            let item = RPNiceModel.init()
            item.imgs = ["https://nim-nosdn.netease.im/MTY2Nzk0NTU=/bmltYV8xMzgzOTQ1OTEyM18xNTk3OTkwOTE0NjU4XzNlYTcwYjRiLWJiZjAtNDExOS1hOTBkLTAxYTgyNGJjYTVmOA==","https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1734913275,3830009060&fm=26&gp=0.jpg","https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2189728697,1720975443&fm=26&gp=0.jpg"]
            item.converUrl = item.imgs.first!
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