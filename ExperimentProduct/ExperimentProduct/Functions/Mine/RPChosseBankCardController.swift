//
//  RPChosseBankCardController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/22.
//

import UIKit

class RPChosseBankCardController: RPBaseViewController {
    
    public typealias SelectBankCardCallBack = (_ model:RPBankCardModel)->()
    public var selectBankCardCallBack: SelectBankCardCallBack?
    private lazy var contentView = UIView()
    private var tableView = UITableView()
    private var dataList:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        simpleUI()
    }
    
    func simpleUI()  {
        contentView = UIView.init()
        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT*0.2, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.8)
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 12, height: 12))
        
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.frame = CGRect.init(x: 10, y: 10, width: 30, height: 30)
        closeBtn.setImage(UIImage(named: "back"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        closeBtn.titleLabel?.font = .systemFont(ofSize: 12)
        contentView.addSubview(closeBtn)
        
        createTableViewUI()
        loadData()
    }
    
    fileprivate func createTableViewUI() {
        tableView = UITableView.init(frame:CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = RPColor.Separator
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 1
        tableView.sectionFooterHeight = 50
        tableView.tableFooterView = UIView()
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        let v = UIView.init()
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 150)
        let doneBtn = UIButton.init(type: .custom)
        doneBtn.frame = CGRect.init(x: 30, y: 50, width: v.frame.width - 60, height: 50)
        doneBtn.backgroundColor = RPColor.MainColor
        doneBtn.setTitle("确定", for:.normal)
        doneBtn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        doneBtn.titleLabel?.font = .systemFont(ofSize: 16)
        doneBtn.layercornerRadius(cornerRadius: 4)
        v.addSubview(doneBtn)
        
        tableView.tableFooterView = v
    }
    
    fileprivate func loadData () {
        //请求拿到数据
        tableView.reloadData()
    }
    
    @objc func doneClick()  {
        //选了哪张卡 回调回去
        let model = RPBankCardModel.init()
        model.cardName = "天地银行"
        model.cardNumber = "xxxx xxxx xxxx 0808"
        self.selectBankCardCallBack?(model)
        closeClick()
    }
    
    @objc func closeClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addClick() {
        let nav = RPNavigationController.init(rootViewController: RPAddBankCardController.init())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取点击点的坐标
        let touch = touches.first
        let touchPoint = touch?.location(in: self.view)
        //空白处的范围
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.2)
        //判断 点（CGPoint）是否在某个范围（CGRect）内
        if rect.contains(touchPoint!) {
            closeClick()
        }
    }
    
    public convenience init(selectCallBack: SelectBankCardCallBack?) {
        self.init()
        self.selectBankCardCallBack = selectBankCardCallBack
        self.modalPresentationStyle = .overFullScreen
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.modalPresentationStyle = .overFullScreen
    }
}

extension RPChosseBankCardController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = RPTableViewAdapter.init().reuseIdentifierForCellClass(cellClass: UITableViewCell.self, tableView: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "天地银行(0808)"
        cell.selectionStyle = .none
        cell.accessoryType = indexPath.row == 0 ? .checkmark : .none;//实际情况根据 RPBankCardModel isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        v.backgroundColor = .white
        let addBtn = UIButton.init(type: .custom)
        addBtn.frame = CGRect.init(x: 16, y: 0, width: v.frame.width - 32, height: 50)
        addBtn.setTitleColor(RPColor.redWine, for: .normal)
        addBtn.setTitle("添加新卡", for:.normal)
        addBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        addBtn.titleLabel?.font = .systemFont(ofSize: 13)
        v.addSubview(addBtn)
        return v
    }
}
