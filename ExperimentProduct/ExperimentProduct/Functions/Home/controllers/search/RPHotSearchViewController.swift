//
//  RPHotSearchViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit
import Then

class RPHotSearchViewController: RPBaseViewController {
    lazy var historyLists = [String]()
    lazy var guessLists = [String]()
    lazy var hotLists = [String]()
    lazy var collectionView = UICollectionView()
    lazy var tableView = UITableView()
    var textField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        creatNav()
        headerView()
        createTableViewUI()
        loadData()
    }
    
    func creatNav(){
        let topNavView = UIView.init()
        topNavView.backgroundColor = .white
        self.view.addSubview(topNavView)
        topNavView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(RPTools.NAV_HEIGHT)
        }
        
        let cancelBtn = UIButton.init(type: .custom).then {
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
            $0.addTarget(self, action: #selector(returnBack), for: .touchUpInside)
        }
        topNavView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-3)
        }
        
        textField = UITextField.init().then {
            $0.backgroundColor = RPColor.ShallowColor
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "请输入"
            $0.tintColor = RPColor.redWine
            $0.delegate = self
        }
        topNavView.addSubview(textField!)
        textField?.leftViewWithImgName(imgName: "search", size: CGSize.init(width: 19, height: 19))
        textField?.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(cancelBtn.snp_centerY)
            make.height.equalTo(30)
            make.right.equalTo(cancelBtn.snp_left).offset(-10)
        }
        textField?.layercornerRadius(cornerRadius: 15)
        
        textField?.becomeFirstResponder()
    }
    
    @objc func returnBack() {
        //我不理解 可能是因为MLeaksFinder对于textField没那么友好
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: textField, for: nil)
//        UIApplication.shared.resignFirstResponder()
//        textField?.resignFirstResponder()
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func headerView () {
        let flowLayout = RPCustomTagFlowLayout.init()
        flowLayout.delegate = self
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
    }
    
    func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(RPTools.NAV_HEIGHT)
        }
    }
    
    func loadData()  {
        let object = RPCache.shared.cache?.object(forKey: kHostSearchCacheKey)
        if object != nil {
            historyLists = object as! [String]
        }
        guessLists = ["鬼王大人","seventeen壁纸","高级小众情头","小猫咪不听话会变成拖鞋"]
        collectionView.reloadData()
        hotLists = ["谁还不是个岛主千金","冬季斩男穿搭","洋葱乳酪风格摇摇薯测评","神秘组织外卖射手","这里是长白山仙境","证件照可以多好看","如有撞脸纯属巧合"]
        tableView.reloadData()
    }
    
    @objc func searchKeyword(_ keywords:String) {
        if !historyLists.contains(keywords) {
            historyLists.append(keywords)
            RPCache.shared.cache?.setObject(historyLists as NSCoding, forKey: kHostSearchCacheKey)
            collectionView.reloadData()
        }
    }
    
    @objc func deleteHistory() {
        RPCache.shared.cache?.removeObject(forKey: kHostSearchCacheKey)
        historyLists.removeAll()
        collectionView.reloadData()
    }
}

extension RPHotSearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if historyLists.count > 0 && guessLists.count > 0 {
            return 2
        }else if (historyLists.count > 0 || guessLists.count > 0) {
            return 1
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if historyLists.count > 0 && section == 0 {
            return historyLists.count
        }
        return guessLists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataArray = (historyLists.count > 0 && indexPath.section == 0) ? historyLists : guessLists
        let identifier = RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPTagCell.self, collectionView: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RPTagCell
        cell.tagLabel.text = dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataArray = (historyLists.count > 0 && indexPath.section == 0) ? historyLists : guessLists
        let size =  RPTools.calculateTextSize(dataArray[indexPath.item], size: CGSize(width: 200, height: 20), font: .systemFont(ofSize: 13))
        return CGSize(width: size.width + 20, height: size.height+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if historyLists.count > 0 || guessLists.count > 0 {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if historyLists.count > 0 || guessLists.count > 0 {
            if kind == UICollectionView.elementKindSectionHeader{
                let id = RPCollectionViewAdapter.init().reuseIdentifierForReusableViewClass(reusableView: RPSearchTitleView.self, collectionView: collectionView, forSupplementaryViewOfKind: kind)
                let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath as IndexPath) as! RPSearchTitleView
                v.titleLabel.text = (historyLists.count > 0 && indexPath.section == 0) ? "历史记录" : "猜你想搜"
                v.deleBtn.isHidden = (historyLists.count > 0 && indexPath.section == 0) ? false : true
                if !v.deleBtn.isHidden {
                    v.deleBtn.addTarget(self, action: #selector(deleteHistory), for: .touchUpInside)
                }
                return v
            }
        }
        return UICollectionReusableView.init()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataArray = (historyLists.count > 0 && indexPath.section == 0) ? historyLists : guessLists
        searchKeyword(dataArray[indexPath.item])
    }
}

extension RPHotSearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPSearchLabelCell.self,tableView:tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RPSearchLabelCell
        cell.setText(hotLists[indexPath.row], andIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchKeyword(hotLists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if hotLists.count == 0 {
            return nil
        }
        let xxx = RPSearchTitleView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        xxx.titleLabel.text = "搜索发现"
        xxx.titleLabel.textColor = .init(patternImage: UIImage.init(gradientColors: [.init(hexString: "FFB367"),RPColor.redWine])!)//渐变色
        xxx.deleBtn.isHidden = true
        return xxx
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hotLists.count == 0 {
            return 0
        }
        return 40
    }
}

extension RPHotSearchViewController:RPCustomTagFlowLayoutDelegate {
    func getCollectionVIewHeight(H: CGFloat) {
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:collectionView.collectionViewLayout.collectionViewContentSize.height)
        tableView.tableHeaderView = collectionView
    }
}

extension RPHotSearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count != 0 {
            searchKeyword(textField.text!)
            return textField.resignFirstResponder()
        }
        return false
    }
}
