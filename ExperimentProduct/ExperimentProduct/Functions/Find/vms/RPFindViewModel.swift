//
//  RPFindViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPFindViewModel: NSObject {
    
    func getFindLists(params:NSDictionary,
                      success:(_ datas: NSArray)->(),
                      failed:(_ error: NSError)->()) {
        //没有模拟数据 所以全是成功
        let arr = NSMutableArray.init()
        for j in 0 ..< 2 {
            let item = RPTableViewSectionItem.init()
            item.sectionHeaderData = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户"] as NSObject
            let cell = RPTableViewCellItem.init()
            let cc = NSMutableArray.init()
            for _ in 0 ..< 8 {
                if j == 0 {
                    let item = RPCollectionViewCellItem.init()
                    let datas = NSMutableArray.init()
                    //(arc4random()%8+1)
                    for k in 0 ..< 8 {
                        let dd = RPPosterModel.init()
                        dd.imgName = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户"][Int(k)]
                        datas.add(dd)
                    }
                    item.cellData = datas
                    item.cellClass = RPNewsLinkCell.self
                    cc.add(item)
                }else{
                    let item = RPCollectionViewCellItem.init()
                    let datas = NSMutableArray.init()
                    for k in 0 ..< (arc4random()%2+7) {
                        let dd = RPPosterModel.init()
                        dd.imgName = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "🐫"][Int(k)]
                        dd.imgUrlPath = ["https://img9.doubanio.com/view/status/l/public/03b19a4a8b04c65.webp",
                                         "https://img1.doubanio.com/view/status/l/public/57c6e5635156a87.webp",
                                         "https://i03piccdn.sogoucdn.com/6df1e5e59eae07c3",
                                         "http://5b0988e595225.cdn.sohucs.com/images/20170913/ffcf6c45abf145eea01524a8a9ae426f.jpeg",
                                         "https://i03piccdn.sogoucdn.com/fa9490d2514e4555",
                                         "https://i02piccdn.sogoucdn.com/33d06029dcef187b",
                                         "https://p2.itc.cn/images01/20210409/ee723c9a005244c6a0350a0cd40c1dfd.jpeg",
                                         "http://i0.hdslb.com/bfs/article/659d3645531d1955b2e5fe064d0d71cab1251ce4.jpg",
                                         "http://b.zol-img.com.cn/desk/bizhi/start/4/1387880532223.jpg"][Int(k)]
                        datas.add(dd)
                    }
                    item.cellData = datas
                    item.cellClass = RPFindCardCell.self
                    cc.add(item)
                }
            }
            cell.cellData = cc
            cell.cellh = CGFloat(60 * cc.count + 40)
            cell.cellClass = RPFindNewsLinkCell.self
            item.cellDatas.append(cell)
            arr.add(item)
        }
        success(arr)
        
        //        failed(NSError.init())
    }
}
