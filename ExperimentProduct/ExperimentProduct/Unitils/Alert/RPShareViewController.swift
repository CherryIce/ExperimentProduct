//
//  RPShareViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/28.
//

import UIKit

class RPShareViewController: RPBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colletionH: NSLayoutConstraint!
    
    public typealias ClickItemCallBack = (_ indexPath:IndexPath)->()
    public var clickItemCallBack: ClickItemCallBack?
    
    var dataArray = [[RPShareItem]](){didSet {}}
    var titles: String = "分享至"{didSet {}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //设置半透明属性
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.modalPresentationStyle = .overFullScreen
        
        addGesture()
        establishConstraint()
    }
    
    func establishConstraint()  {
        let count = self.dataArray.count
        var h = (count - 1) * 10
        h += count*100
        
        self.colletionH.constant = CGFloat(h)
        
        self.titleLabel.text = self.titles
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    public convenience init(title:String?, dataArray:[[RPShareItem]],clickCallBack: ClickItemCallBack?) {
        self.init()
        title != nil ? self.titles = title! : nil
        self.dataArray = dataArray
        self.clickItemCallBack = clickCallBack
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        RPTools.IS_IPHONEX ? nil : self.contentView.layerRoundedRect(byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.pop()
    }
}

extension RPShareViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let setionArray = self.dataArray[indexPath.row] as NSArray
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RPCollectionViewAdapter.init().reuseIdentifierForCellClass(cellClass: RPShareSheetCell.self, collectionView: collectionView), for: indexPath) as! RPShareSheetCell
        cell.shareItems = setionArray as! [RPShareItem]
        cell.sheetCellClicked = { (cell, index) in
            let indexP = IndexPath.init(row: index, section: indexPath.row)
            if self.clickItemCallBack != nil {
                self.clickItemCallBack?(indexP)
            }
            self.pop()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
}

extension RPShareViewController:UIGestureRecognizerDelegate {
    func addGesture()  {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(pop))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func pop() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        if (touch.view == self.view) {
            return true
        }
        return false
    }
}

class RPShareSheetCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate {

    var shareItems: [RPShareItem] = []
    
    var collectionView: UICollectionView!
    
    var sheetCellClicked: ((RPShareSheetCell, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 70, height:80)
        
        collectionView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RPShareViewCell.self, forCellWithReuseIdentifier: "cell")
        self.contentView.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RPShareViewCell
        cell.item = shareItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.sheetCellClicked != nil {
            self.sheetCellClicked?(self, indexPath.row)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RPShareViewCell: UICollectionViewCell {
    
    var imgV = UIImageView()
    var title = UILabel()
    var item: RPShareItem{
        didSet {
            self.title.text = item.title
            self.title.font = item.titleFont
            self.title.textColor = item.titleColor
            self.imgV.image = item.icon
        }
    }
    
    override init(frame: CGRect) {
        self.item = RPShareItem.init()
        super.init(frame: frame)
        
        imgV = UIImageView.init()
        self.addSubview(imgV)
        
        title = UILabel.init()
        title.textAlignment = .center
        self.addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgV.frame = CGRect.init(x: 0, y: 5, width: 50, height: 50)
        imgV.center.x = self.frame.size.width * 0.5
        
        title.frame = CGRect.init(x: 0, y: imgV.frame.maxY + 5, width: self.frame.size.width, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RPShareItem: NSObject {
    
    var title:String?
    var titleFont = UIFont.systemFont(ofSize: 12)
    var titleColor = UIColor.black
    var icon:UIImage?
    
    override init() {
        super.init()
    }
    
    convenience init(text: String?,icon:UIImage) {
        self.init(text: text, font: nil, color: nil, icon: icon)
    }
    
    init(text: String?,font:UIFont?,color:UIColor?,icon:UIImage) {
        super.init()
        self.title = text ?? nil
        self.titleFont = font != nil ? font! : UIFont.systemFont(ofSize: 12)
        self.titleColor = color != nil ?  color! : .black
        self.icon = icon
    }
    
    class func shareToWeChat() -> RPShareItem  {
        return RPShareItem.init(text: "微信", icon: RPTools.getPngImage(forResource: "wechat@2x"))
    }
    
    class func shareToWechatCircle() -> RPShareItem  {
        return RPShareItem.init(text: "朋友圈", icon: RPTools.getPngImage(forResource: "wechat_circle@2x"))
    }
}
