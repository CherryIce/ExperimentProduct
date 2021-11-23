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
        let imgs = ["https://img9.doubanio.com/view/status/l/public/03b19a4a8b04c65.webp",
                    "https://img1.doubanio.com/view/status/l/public/57c6e5635156a87.webp",
                    "https://i03piccdn.sogoucdn.com/6df1e5e59eae07c3",
                    "http://5b0988e595225.cdn.sohucs.com/images/20170913/ffcf6c45abf145eea01524a8a9ae426f.jpeg",
                    "https://i03piccdn.sogoucdn.com/fa9490d2514e4555",
                    "https://i02piccdn.sogoucdn.com/33d06029dcef187b",
                    "https://p2.itc.cn/images01/20210409/ee723c9a005244c6a0350a0cd40c1dfd.jpeg",
                    "http://i0.hdslb.com/bfs/article/659d3645531d1955b2e5fe064d0d71cab1251ce4.jpg",
                    "http://b.zol-img.com.cn/desk/bizhi/start/4/1387880532223.jpg"]
        let str = "时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。俨骖騑于上路，访风景于崇阿；临帝子之长洲，得天人之旧馆。层峦耸翠，上出重霄；飞阁流丹，下临无地。鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。披绣闼，俯雕甍，山原旷其盈视，川泽纡其骇瞩。闾阎扑地，钟鸣鼎食之家；舸舰弥津，青雀黄龙之舳。云销雨霁，彩彻区明。落霞与孤鹜齐飞，秋水共长天一色。渔舟唱晚，响穷彭蠡之滨；雁阵惊寒，声断衡阳之浦。遥襟甫畅，逸兴遄飞。爽籁发而清风生，纤歌凝而白云遏。睢园绿竹，气凌彭泽之樽；邺水朱华，光照临川之笔。四美具，二难并。穷睇眄于中天，极娱游于暇日。天高地迥，觉宇宙之无穷；兴尽悲来，识盈虚之有数。望长安于日下，目吴会于云间。地势极而南溟深，天柱高而北辰远。关山难越，谁悲失路之人？萍水相逢，尽是他乡之客。怀帝阍而不见，奉宣室以何年？"
        let tt = NSMutableArray.init()
        for i in 0 ..< imgs.count {
            let width:CGFloat = CGFloat(arc4random()%100 + 300)
            let height:CGFloat = CGFloat(arc4random()%100 + 250)
            let item = RPNiceModel.init()
            item.author = RPAuthorModel.init()
            item.author.name = String(format: "oh no %d", i)
            item.author.image = imgs[i]
            item.cover = RPImageModel.init()
            item.cover.url = imgs[i]
            item.cover.width = width
            item.cover.height = height
            for j in 0 ..< (arc4random()%4+1) {
                let x = RPImageModel.init()
                x.url = j == 0 ? imgs[i] : imgs[8-Int(j)]
                item.imageList.append(x)
            }
            let nsrange = NSRange(location: Int(arc4random()%100), length: 40)
            if let range = Range(nsrange, in: str) {
                item.title = String(str[range])
            }
            item.desc = String(str.prefix(Int(arc4random())%200))
            item.likes = Int(arc4random()%1000 + 1)
            
            if item.desc.count > 0 {
                let label = UILabel.init()
                label.frame = CGRect.init(x: 0, y: 0, width: width, height: 20)
                label.numberOfLines = 2
                label.text = item.desc
                label.sizeToFit()
                item.contentH = CGFloat(ceilf(Float(label.frame.size.height)))
            }
            item.cellH = item.cover.height + 10 + item.contentH + 10 + 20 + 10
            tt.add(item)
        }
        success(tt)
        
        //        failed(NSError.init())
    }
    
    func getFollowLists(params:NSDictionary,
                        success:(_ datas: NSArray)->(),
                        failed:(_ error: NSError)->()) {
        success([1,2,3,4,5,6,7,8,9,10])
    }
}
