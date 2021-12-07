//
//  RPFeedBackViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/11.
//

import UIKit
import Then

enum  RPTextViewFromType {
    case feedback
    case personalInfo
}

class RPFeedBackViewController: RPBaseViewController {

    public typealias UpdatePersonInfoSuccessCallBack = (_ nickName:String)->()
    public var updatePersonInfoSuccessCallBack: UpdatePersonInfoSuccessCallBack?
    private lazy var textView = NextGrowingInternalTextView()
    private lazy var maxLength = 200
    private var placeholder = ""
    
    var type : RPTextViewFromType = .feedback {
        didSet {
            adjustUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configurationUI()
    }
    
    fileprivate func adjustUI() {
        switch type {
        case .feedback:
            self.placeholder = "请输入您的建议与意见"
            self.maxLength = 200
            break
        case .personalInfo:
            self.placeholder = "描述自己,让更多人认识你"
            self.maxLength = 20
            break
        }
    }
    
    fileprivate func configurationUI() {
        let contentView = UIView.init(frame: CGRect.init(x: 16, y: 10, width: SCREEN_WIDTH - 32, height: 128))
        contentView.backgroundColor = RPColor.ShallowColor
        self.view.addSubview(contentView)
        
        textView = NextGrowingInternalTextView(frame: CGRect(origin: CGPoint.init(x: 10, y: 10), size: CGSize.init(width: contentView.frame.width - 20, height: contentView.frame.height - 20)))
        textView.tintColor = .red
        contentView.addSubview(textView)
        
        let limitLabel = UILabel.init()
        limitLabel.font = .systemFont(ofSize: 10)
        limitLabel.textColor = .lightGray
        limitLabel.text = String(format: "%zd/%zd", maxLength,maxLength)
        contentView.addSubview(limitLabel)
        
        limitLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        textView.layer.cornerRadius = 4
        textView.backgroundColor = contentView.backgroundColor
        textView.textContainerInset = .init(top: 4, left: 0, bottom: 4, right: 0)
        textView.placeholderAttributedText = NSAttributedString(
            string: self.placeholder,
          attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
          ]
        )
        
        //限制最大字数可以放这里
        textView.didChange = { [weak self] in
            if (self?.textView.text.count)! > self!.maxLength {
                self?.textView.text = String(self?.textView.text?.prefix(self!.maxLength) ??  "")
            }else{
                limitLabel.text = String(format: "%zd/%zd", self!.maxLength-(self?.textView.text.count)!,self!.maxLength)
            }
        }
        
        //超出默认高度开始偏移
        textView.didUpdateHeightDependencies = { [weak self] in
            log.debug("\n\n\n this is a test : "+(self?.textView.text)!)
        }
        
        let submit = UIButton.init(type: .custom).then {
            $0.setTitle("提 交", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .red
            $0.titleLabel?.font = .systemFont(ofSize: 15)
        }
        self.view.addSubview(submit)
        submit.layercornerRadius(cornerRadius: 4)
        submit.addTarget(self, action: #selector(submitApi), for: .touchUpInside)
        
        submit.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp_bottom).offset(30)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(44)
        }
    }
    
    @objc func submitApi()  {
        switch type {
        case .feedback:
            //提交接口后
            self.navigationController?.popViewController(animated: true)
            break
        case .personalInfo:
            //提交接口后
            if self.updatePersonInfoSuccessCallBack != nil {
                self.updatePersonInfoSuccessCallBack?(self.textView.text)
            }
            self.navigationController?.popViewController(animated: true)
            break
        }
    }
    
    func callBackFunction ( block: @escaping UpdatePersonInfoSuccessCallBack) {
        updatePersonInfoSuccessCallBack = block
    }
}
