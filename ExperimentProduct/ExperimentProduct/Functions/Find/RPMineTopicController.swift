//
//  RPMineTopicController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/20.
//

import UIKit

/*
 个人的话题中心 → 查看自己的 → 所有数量 且可以操作 →
 ↓                                         ↓
 查看别人的
 ↓                                         ↓
 权限限制了数量的显示 且不能操作
 ↓                                         ↓
 查看图片视频是当前拿下来的全部
 情形1:(参考微信聊天)
 带有工具栏
 视频的进度播放和时长这一些和视频cell绑定在一起
 查看原图和图片cell绑定在一起
 公共操作部分和browser控制器绑定在一起
 情形2:(参考微信朋友圈)
 不带工具栏 带有话题详情
 */

class RPMineTopicController: RPBaseViewController {
    private lazy var viewModel = RPMineTopicViewModel()
    private var tableView = UITableView()
    private lazy var dataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createTableViewUI()
        loadData()
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: /*RPTools.BottomPadding+*/10))
        tableView.tableFooterView = v
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        viewModel.getMineTopicLists(params: NSDictionary.init()) { (dataArray) in
            self.dataArray = NSMutableArray.init(array: dataArray)
            self.tableView.reloadData()
        } failed: { (error) in
            
        }
    }
    
}

extension RPMineTopicController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        let cell = tableView.dequeueReusableCell(withIdentifier: RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPMineTopicViewCell.self, tableView: tableView), for: indexPath) as! RPMineTopicViewCell
        cell.setCellData(model: model, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        return model.cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //图片 视频 有单独的中间拓展页 其他类型直接飞详情页
        let model = self.dataArray[indexPath.row] as! RPTopicModel
        switch model.type {
        case .text,.article:
            let detail = RPTopicDetailViewController.init()
            self.navigationController?.pushViewController(detail, animated: true)
            break
        case .video,.pictures:
            //需要把已经获取到的所有媒体model放进一个数组中打包
            var index = 0
            let media = RPMeidDetailViewController.init()
            for i in 0..<self.dataArray.count {
                let xm:RPTopicModel = self.dataArray[i] as! RPTopicModel
                if xm.type == .video || xm.type == .pictures {
                    media.dataArray.append(xm)
                    if i == indexPath.row {
                        index = (media.dataArray.count - 1)
                    }
                }
            }
            media.currentIndex = index
            customPresent(media, animated: true)
//            media.modalPresentationStyle = .overFullScreen
//            //可以模拟个push动画
//            self.present(media, animated: true, completion: nil)
            break
        }
    }
}
