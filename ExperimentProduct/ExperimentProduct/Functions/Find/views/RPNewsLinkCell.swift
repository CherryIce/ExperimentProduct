//
//  RPNewsLinkCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/16.
//

import UIKit

class RPNewsLinkCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:RPListViewCellEventDelegate?
    private var indexPath = IndexPath()
    var datas = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing:UITableViewCell.self))
    }

}

extension RPNewsLinkCell:RPListCellDataDelegate {
    func setCellData(cellData: AnyObject, delegate: RPListViewCellEventDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if cellData is RPCollectionViewCellItem {
            let xx = cellData as! RPCollectionViewCellItem
            if xx.cellData is RPPosterModel {
                datas = ["🐰", "秃子", "鹰酱", "毛熊", "棒子", "脚盆鸡", "高卢鸡", "狗大户"]
                tableView.reloadData()
            }
        }
    }
}

extension RPNewsLinkCell:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = datas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:UITableViewCell.self), for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = datas[indexPath.row] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
//        let sectionItem = dataList[indexPath.section] as! RPTableViewSectionItem
//        let item = sectionItem.cellDatas[indexPath.row]
//        return item.cellh
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didSelectListView(tableView, indexPath: indexPath, sectionData: nil, cellData: nil)
        }
    }
}
