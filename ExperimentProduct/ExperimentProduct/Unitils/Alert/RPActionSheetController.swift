//
//  RPActionSheetController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/27.
//

import UIKit

// Because the actionSheet of UIAlertController in the system has constraint bug, I wrote a simple version by myself

class RPActionSheetController: RPBaseViewController {
    
    private let cellId = "RPActionSheetCellId"
    private var dataArray = [[RPActionSheetCellItem]]()
    public typealias ClickItemCallBack = (_ indexPath:IndexPath)->()
    public var clickItemCallBack: ClickItemCallBack?
    private var titleItem = RPActionSheetTopItem()
    private var messageItem = RPActionSheetTopItem()
    private var headerH = CGFloat(0)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.register(RPActionSheetCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = RPColor.Separator
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = 50 //Whether to fix the height is up to you
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        log.warning("⚠️ Use Present, if you want to push, you can customize the transition animation")
        //设置半透明属性
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.modalPresentationStyle = .overFullScreen
    }
    
    //调整约束
    private func establishConstraint(){
        let nums = self.dataArray.count
        var row = 0
        for xx in self.dataArray {
            row += xx.count
        }
        var h = row * 50 //cell高度总合
        h += (nums-1) * 10 // section间间隙总和
        h += Int(RPTools.BottomPadding) //刘海屏下面的空隙
        
        var titles = 0
        headerH = 0
        if self.titleItem.title != nil {
            titles += 1
            let size = RPTools.calculateTextSize(self.titleItem.title!, size: CGSize.init(width: SCREEN_WIDTH - 2*16, height: CGFloat(MAXFLOAT)), font: self.titleItem.titleFont)
            h += Int(ceil(size.height))+1
            headerH += CGFloat(Int(ceil(size.height))+1)
        }
        if self.messageItem.title != nil {
            titles += 1
            let size = RPTools.calculateTextSize(self.messageItem.title!, size: CGSize.init(width: SCREEN_WIDTH - 2*16, height: CGFloat(MAXFLOAT)), font: self.messageItem.titleFont)
            h += Int(ceil(size.height))+1
            headerH += CGFloat(Int(ceil(size.height))+1)
        }
        
        headerH += titles > 0 ? CGFloat((titles+1)*10) : 0
        h += Int(headerH)
        
        //限制高度
        h = h > 400 ? 400 : h
        
        self.tableView.frame = CGRect.init(x: 0, y: Int(SCREEN_HEIGHT-CGFloat(h)), width: Int(SCREEN_WIDTH), height: h)
        
        RPTools.IS_IPHONEX ? nil : self.tableView.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
    }
    
    public convenience init(title: String?, message: String?, dataArray:[[RPActionSheetCellItem]],clickCallBack: ClickItemCallBack?) {
        self.init(titleItem: RPActionSheetTopItem.init(text: title, type: .title),
                  messageItem:RPActionSheetTopItem.init(text: message, type: .message),
                  dataArray:dataArray,
                  clickCallBack: clickCallBack)
    }
    
    public convenience init(titleItem: RPActionSheetTopItem?, messageItem: RPActionSheetTopItem?, dataArray:[[RPActionSheetCellItem]],clickCallBack: ClickItemCallBack?) {
        self.init()
        self.titleItem = titleItem ?? RPActionSheetTopItem.init()
        self.messageItem = messageItem ?? RPActionSheetTopItem.init()
        self.dataArray = dataArray
        self.clickItemCallBack = clickCallBack
        establishConstraint()
        self.tableView.reloadData()
    }
}

extension RPActionSheetController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = self.dataArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionArray = self.dataArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RPActionSheetCell
        let cellItem = sectionArray[indexPath.row]
        cell.button.setTitle(cellItem.text, for: .normal)
        cell.button.setTitleColor(cellItem.textColor, for: .normal)
        cell.button.setImage(cellItem.icon, for: .normal)
        cell.button.titleLabel?.font = cellItem.textFont
//        cell.button.titleLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerH
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if (self.titleItem.title != nil || self.messageItem.title != nil) && section == 0{
                let v = RPActionSheetHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: headerH), title: self.titleItem, details: self.messageItem)
                v.backgroundColor = .white
                RPTools.IS_IPHONEX ? nil : v.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
                return v
            }
            return nil
        }
        let v = UIView.init()
        v.backgroundColor = RPColor.Separator
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.clickItemCallBack != nil {
            self.clickItemCallBack?(indexPath)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

class RPActionSheetHeaderView: UIView {
    private var titleLabel  = UILabel()
    private var detailLabel  = UILabel()
    private var titleItem  = RPActionSheetTopItem()
    private var detailsItem  = RPActionSheetTopItem()
    
    convenience init(frame: CGRect, title:RPActionSheetTopItem?,details:RPActionSheetTopItem?) {
        self.init(frame: frame)
        self.titleItem = title ?? RPActionSheetTopItem.init()
        self.detailsItem = details ?? RPActionSheetTopItem.init()
        creatUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func creatUI() {
        if self.titleItem.title != nil {
            let size = RPTools.calculateTextSize(self.titleItem.title!, size: CGSize.init(width: SCREEN_WIDTH - 2*16, height: CGFloat(MAXFLOAT)), font: self.titleItem.titleFont)
            titleLabel = UILabel.init()
            titleLabel.frame = CGRect.init(x: 16, y: 10, width: self.frame.size.width - 16*2, height: CGFloat(Int(ceil(size.height))+1))
            titleLabel.textColor = self.titleItem.titleColor
            titleLabel.font = self.titleItem.titleFont
            titleLabel.textAlignment = .center
            titleLabel.text = self.titleItem.title!
            self.addSubview(titleLabel)
        }
        
        if self.detailsItem.title != nil {
            let size = RPTools.calculateTextSize(self.detailsItem.title!, size: CGSize.init(width: SCREEN_WIDTH - 2*16, height: CGFloat(MAXFLOAT)), font: self.detailsItem.titleFont)
            detailLabel = UILabel.init()
            detailLabel.frame = CGRect.init(x: 16, y: titleLabel.frame.maxY + 10, width: self.frame.size.width - 16*2, height: CGFloat(Int(ceil(size.height))+1))
            detailLabel.textColor = self.detailsItem.titleColor
            detailLabel.font = UIFont.systemFont(ofSize: 12)
            detailLabel.textAlignment = .center
            detailLabel.text = self.detailsItem.title
            self.addSubview(detailLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RPActionSheetCell: UITableViewCell {
    
    var button = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        button = UIButton.init(type: .custom)
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        button.frame = self.bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class RPActionSheetCellItem: NSObject {
    //You can try customizing if you want custom cell
    //var cellClass = UITableViewCell.self
    
    var text:String?
    var icon:UIImage?
    var textFont = UIFont.systemFont(ofSize: 16)
    var textColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    public convenience init(title: String) {
        self.init(title:title,image:nil)
    }
    
    public convenience init(image: UIImage) {
        self.init(title:nil,image:image)
    }
    
    convenience init(title: String?, image:UIImage?) {
        self.init(title: title,font:nil,color:nil,image:image)
    }
    
    init(title: String?,font:UIFont?,color:UIColor?,image:UIImage?) {
        super.init()
        self.text = title ?? nil
        if font != nil {
            self.textFont = font!
        }
        if color != nil {
            self.textColor = color!
        }
        self.icon = image ?? nil
    }
    
    class func cancel() -> RPActionSheetCellItem  {
        return RPActionSheetCellItem.init(title: "取消")
    }
}

enum RPActionSheetTopType {
    case title
    case message
}

class RPActionSheetTopItem: NSObject {
    
    var title:String?
    var titleFont = UIFont.systemFont(ofSize: 16)
    var titleColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    convenience init(text: String?,type:RPActionSheetTopType) {
        self.init(text: text, font: nil, color: nil, type: type)
    }
    
    init(text: String?,font:UIFont?,color:UIColor?,type:RPActionSheetTopType) {
        super.init()
        self.title = text ?? nil
        self.titleFont = font != nil ? font! : (type == RPActionSheetTopType.title ? UIFont.systemFont(ofSize: 16) : UIFont.systemFont(ofSize: 13))
        self.titleColor = color != nil ?  color! : (type == RPActionSheetTopType.title ? .black : .lightGray)
    }
}

