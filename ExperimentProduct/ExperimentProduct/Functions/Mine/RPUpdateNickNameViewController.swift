//
//  RPUpdateNickNameViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/11.
//

import UIKit
import WHC_KeyboardManager
import Then
import SnapKit

class RPUpdateNickNameViewController: RPBaseViewController {
    
    public typealias UpdateNickNameSuccessCallBack = (_ nickName:String)->()
    public var updateNickNameSuccessCallBack: UpdateNickNameSuccessCallBack?
    private lazy var textfiled = UITextField()
    private lazy var doneBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        WHC_KeyboardManager.share.addMonitorViewController(self)
        creatUI()
    }
    
    func creatUI() {
        doneBtn = UIButton.init(type: .custom).then {
            $0.setTitle("确定", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.setTitleColor(RPColor.Separator, for: .normal)
            $0.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
            $0.isEnabled = false
        }
        let rightItem = UIBarButtonItem.init(customView: doneBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        textfiled = UITextField.init().then {
            $0.placeholder = "请输入昵称"
            $0.font = .systemFont(ofSize: 16)
            $0.backgroundColor = .white
            $0.clearButtonMode = .always
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        self.view.addSubview(textfiled)
        
        textfiled.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(10)
            make.height.equalTo(45)
        }
    }

    @objc func doneClick() {
        //上传后台
        if self.updateNickNameSuccessCallBack != nil {
            self.updateNickNameSuccessCallBack?(textfiled.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        let textLength = Int.init(text?.count ?? 0)
        doneBtn.isEnabled = (textLength > 0)
        doneBtn.setTitleColor(doneBtn.isEnabled ? RPColor.MainColor:RPColor.Separator, for: .normal)
        if  textLength  > 20 {
            textField.text = String(text?.prefix(20) ??  "")
        }
    }
    
    func callBackFunction ( block: @escaping UpdateNickNameSuccessCallBack) {
        updateNickNameSuccessCallBack = block
    }
}
