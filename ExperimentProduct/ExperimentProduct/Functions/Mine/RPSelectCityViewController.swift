//
//  RPSelectCityViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/10.
//

import UIKit

enum xxtype {
    case province
    case city
    case area
}

let tips = "请选择"

class RPSelectCityViewController: RPBaseViewController {
    
    private lazy var tableView = UITableView()
    private lazy var provinceBtn = UIButton()
    private lazy var cityBtn = UIButton()
    private lazy var areaBtn = UIButton()
    private lazy var lineV = UIView()
    
    public typealias SelectCityCallBack = (_ provinces:RProvincesModel,_ city:RPCityModel,_ area:RPAreaModel)->()
    public var selectCityCallBack: SelectCityCallBack?

    var type:xxtype = .province
    var proIndex:Int = 0//选中省
    var cityIndex:Int = 0//选中市
    
    var dataArray = [RProvincesModel](){
        didSet {
            tableView.reloadData()
        }
    }
    
    func selectCityFinishedCallBack(_ block:@escaping SelectCityCallBack) {
        self.selectCityCallBack = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        //注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        //去掉多余的分割线
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-RPTools.BottomPadding)
            make.height.equalTo(300)
        }
        
        let topV = UIView.init()
        topV.backgroundColor = .purple
        self.view.addSubview(topV)
        
        topV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalTo(tableView.snp_top)
        }
        
        provinceBtn = UIButton.init(type: .custom)
        provinceBtn.setTitle(tips, for: .normal)
        provinceBtn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        topV.addSubview(provinceBtn)
        provinceBtn.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH/3, height: 38)
        
        cityBtn = UIButton.init(type: .custom)
        cityBtn.setTitle(tips, for: .normal)
        cityBtn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        cityBtn.isHidden = true
        topV.addSubview(cityBtn)
        cityBtn.frame = CGRect.init(x: SCREEN_WIDTH/3, y: 0, width: SCREEN_WIDTH/3, height: 38)
        
        areaBtn = UIButton.init(type: .custom)
        areaBtn.setTitle(tips, for: .normal)
        areaBtn.isHidden = true
        topV.addSubview(areaBtn)
        areaBtn.frame = CGRect.init(x: SCREEN_WIDTH/3*2, y: 0, width: SCREEN_WIDTH/3, height: 38)
        
        lineV = UIView.init()
        lineV.backgroundColor = .red
        lineV.layercornerRadius(cornerRadius: 1)
        topV.addSubview(lineV)
        lineV.frame.size = CGSize.init(width: 30, height: 2)
        lineV.center.x = provinceBtn.center.x
        lineV.center.y = provinceBtn.frame.maxY + 1
    }
    
    @objc func clickButton(_ sender:UIButton) {
        if sender == provinceBtn {
            UIView.animate(withDuration: 0.25) {
                self.lineV.center.x = self.provinceBtn.center.x
                self.type = .province
                self.provinceBtn.setTitle(tips, for: .normal)
                self.cityBtn.isHidden = true
                self.cityBtn.setTitle(tips, for: .normal)
                self.areaBtn.isHidden = true
                self.areaBtn.setTitle(tips, for: .normal)
                self.tableView.reloadData()
            }
        }else if sender == cityBtn {
            UIView.animate(withDuration: 0.25) {
                self.lineV.center.x = self.cityBtn.center.x
                self.type = .city
                self.cityBtn.setTitle(tips, for: .normal)
                self.areaBtn.isHidden = true
                self.areaBtn.setTitle(tips, for: .normal)
                self.tableView.reloadData()
            }
        }
    }
    
    func getProvince() -> [RProvincesModel] {
         return dataArray
    }
    
    func getCity() -> [RPCityModel] {
        let model = self.getProvince()[proIndex]
        let citys = model.cities
        return citys.city
    }

    func getArea() -> [RPAreaModel] {
        let cityModel = self.getCity()[cityIndex]
        let areas = cityModel.areas
        return areas.area
    }
}

extension RPSelectCityViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .province {
            return self.getProvince().count
        }else if type == .city {
            return self.getCity().count
        }
        return self.getArea().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        if type == .province {
            let model = self.getProvince()[indexPath.row]
            cell.textLabel?.text = model.ssqname
        }else if type == .city {
            let model = self.getCity()[indexPath.row]
            cell.textLabel?.text = model.ssqname
        }else{
            let model = self.getArea()[indexPath.row]
            cell.textLabel?.text = model.ssqname
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .province {
            let model = self.getProvince()[indexPath.row]
            UIView.animate(withDuration: 0.25) {
                self.proIndex = indexPath.row
                self.lineV.center.x = self.cityBtn.center.x
                self.provinceBtn.setTitle(model.ssqname, for: .normal)
                self.type = .city
                self.cityBtn.isHidden = false
                tableView.reloadData()
                self.areaBtn.isHidden = true
            }
        }else if type == .city {
            UIView.animate(withDuration: 0.25) {
                self.cityIndex = indexPath.row
                self.lineV.center.x = self.areaBtn.center.x
                let model = self.getCity()[indexPath.row]
                self.cityBtn.setTitle(model.ssqname, for: .normal)
                self.type = .area
                self.areaBtn.isHidden = false
                tableView.reloadData()
            }
        }else{
            let model = self.getProvince()[proIndex]
            let cityModel = self.getCity()[cityIndex]
            let model3 = self.getArea()[indexPath.row]
            if self.selectCityCallBack != nil {
                self.selectCityCallBack?(model,cityModel,model3)
            }
            self.dimiss()
        }
    }
    
    func dimiss() {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
