//
//  RPExploreViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

let cellID = "RPExploreViewCellIdentifier"

class RPExploreViewController: RPBaseViewController {
    
    //tableView
    var tableView = UITableView()
    
    //数据
    var dataList = [String]()
    
    //处理后的数据(根据首字母进行分组)
    var resultDict = [String : [String]]()
    
    //组头标题数组
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //原始数据
        dataList = ["兔子", "秃子", "鹰酱", "毛熊", "猫", "棒子", "脚盆鸡", "高卢鸡", "狗大户", "骆驼", "沙某", "河马", "Big D", "Apple"]
        
        //数据处理
        createResultDict()
        
        //tableVIew
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //去掉多余的分割线
        tableView.tableFooterView = UIView()
        //注册cell
        tableView.register(UINib(nibName: "RPExploreViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    //MARK: - 数据处理，根据首字母进行分组
    /**
     ```
     数据**处理**，根据`首字母`进行分组
     ```
     */
    func createResultDict() {
        for str in dataList {
            //获得首字母
            let firstLetterIndex = str.index(str.startIndex, offsetBy: 1)
            var firstLetter = String(str[..<firstLetterIndex])
            
            //转成大写字母
            firstLetter = firstletterFromString(str: firstLetter)
            
            if var values = resultDict[firstLetter] {
                values.append(str)
                resultDict[firstLetter] = values
            } else {
                resultDict[firstLetter] = [str]
            }
            
            //组头标题
            sectionTitles = [String](resultDict.keys)
            //排序
            sectionTitles = sectionTitles.sorted(by: {$0 < $1})
        }
    }
    
    //MARK: - 将中文转成大写字母
    func firstletterFromString(str: String) -> String {
        //转变成可变字符串
        let mutableStr = NSMutableString.init(string: str)
        
        //将中文转变成带声调的拼音
        CFStringTransform(mutableStr as CFMutableString, nil, kCFStringTransformToLatin, false)
        
        //去掉声调
        let pyStr = mutableStr.folding(options: .diacriticInsensitive, locale: .current)
        
        //将拼音换成大写
        let PYStr = pyStr.uppercased()
        
        //截取大写首字母
        let index = PYStr.index(PYStr.startIndex, offsetBy: 1)
        let firstStr = PYStr[..<index]
        
        //判断首字母是否为大写
        let uppercaseLetter = "^[A-Z]$"
        let predicateLetter = NSPredicate.init(format: "SELF MATCHES %@", uppercaseLetter)
        
        return String(predicateLetter.evaluate(with: firstStr) ? firstStr : "#")
    }
}

extension RPExploreViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - 返回多少组
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    //MARK: - 每组多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        guard let values = resultDict[key] else {
            return 0
        }
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RPExploreViewCell
        
        let key = sectionTitles[indexPath.section]
        let values = resultDict[key]
        
        cell.iconV.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(25)
        cell.nameLab.text = values?[indexPath.row]
        
        return cell
    }
    
    //MARK: - 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK: - section标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //MARK: - 索引列表
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}
