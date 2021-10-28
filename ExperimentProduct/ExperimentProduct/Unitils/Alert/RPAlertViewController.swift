//
//  RPAlertViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/28.
//

import UIKit

enum RPAlertViewButtonType {
    case none
    case onlyLeft
    case onlyRight
    case both
}

class RPAlertViewController: RPBaseViewController {
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageTop: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var cancelWidth: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var confirmWidth: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    
    public typealias ClickButtonCallBack = (_ index:Int)->()
    public var clickButtonCallBack: ClickButtonCallBack?
    
    private var titles:String?
    private var messages:String?
    private var cancels:String?
    private var confirms:String?
    
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16){didSet {}}
    public var msgFont: UIFont = UIFont.systemFont(ofSize: 13){didSet {}}
    public var titleColor: UIColor = .black{didSet {}}
    public var msgColor: UIColor = .lightGray{didSet {}}
    public var cancelFont: UIFont = UIFont.systemFont(ofSize: 16){didSet {}}
    public var confirmFont: UIFont = UIFont.systemFont(ofSize: 16){didSet {}}
    public var cancelColor: UIColor = .black{didSet {}}
    public var confirmColor: UIColor = .black{didSet {}}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        log.warning("⚠️ Use Present, if you want to push, you can customize the transition animation")
        //设置半透明属性
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.modalPresentationStyle = .overFullScreen
        
        establishConstraint()
    }
    
    func establishConstraint()  {
        self.titleLabel.textColor = titleColor
        self.titleLabel.font = titleFont
        self.titleLabel.text = titles != nil ? titles! : nil
        self.titleTop.constant = titles != nil ? 20 : 0
        
        self.messageLabel.textColor = msgColor
        self.messageLabel.font = msgFont
        self.messageLabel.text = messages != nil ? messages! : nil
        self.messageTop.constant = messages != nil ? 20 : 0
        
        var type = RPAlertViewButtonType.none
        if cancels == nil || cancels?.count == 0 {
            type = .onlyLeft
            if confirms == nil || confirms?.count == 0 {
                type = .both
            }
        }else{
            if confirms == nil || confirms?.count == 0 {
                type = .onlyRight
            }
        }
        
        switch type {
        case .none:
            // what can i say
            break
        case .onlyLeft:
            self.confirmButton.isHidden = true
            self.confirmWidth.constant = 0
            self.cancelButton.isHidden = false
            self.cancelButton.setTitle(cancels, for: .normal)
            self.cancelWidth.constant = self.centerView.frame.size.width
            break
        case .onlyRight:
            self.confirmButton.setTitle(confirms, for: .normal)
            self.confirmButton.isHidden = false
            self.confirmWidth.constant = self.centerView.frame.size.width
            self.cancelButton.isHidden = true
            self.cancelWidth.constant = 0
            break
        case .both:
            self.confirmButton.setTitle(confirms, for: .normal)
            self.cancelButton.setTitle(cancels, for: .normal)
            self.confirmButton.isHidden = false
            self.confirmWidth.constant = self.centerView.frame.size.width * 0.5 - 0.5
            self.cancelButton.isHidden = false
            self.cancelWidth.constant = self.centerView.frame.size.width * 0.5 - 0.5
            break
        }
        
        self.cancelButton.setTitleColor(cancelColor, for: .normal)
        self.cancelButton.titleLabel?.font = cancelFont
        self.confirmButton.setTitleColor(confirmColor, for: .normal)
        self.confirmButton.titleLabel?.font = confirmFont
        
        self.centerView.layercornerRadius(cornerRadius: 8)
        self.centerView.clipsToBounds = true
    }
    
    public convenience init(title: String?, message: String?, cancel:String?,confirm:String?,clickCallBack: ClickButtonCallBack?) {
        self.init()
        self.titles = title
        self.messages = message
        self.cancels = cancel
        self.confirms = confirm
        self.clickButtonCallBack = clickCallBack
        //Xib should be responsible for the problem
        self.modalPresentationStyle = .overFullScreen
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        if self.clickButtonCallBack != nil {
            self.clickButtonCallBack?(0)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        if self.clickButtonCallBack != nil {
            self.clickButtonCallBack?(1)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
