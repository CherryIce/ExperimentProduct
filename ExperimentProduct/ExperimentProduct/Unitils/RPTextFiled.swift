//
//  RPTextFiled.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/12.
//

import UIKit

public enum RPTextFiledType : Int {
    case common = 0
    case loginPhone = 1
    case loginPw = 2
}

class RPTextFiled: UIView {
    
    private var textField = HoshiTextField()
    //闭包
    public typealias TextFieldCompletionHandler = (_ textFiled: HoshiTextField)->()
    public var blockTextFieldDidChange: TextFieldCompletionHandler?
    
    //输入框类型
    public var type: RPTextFiledType{
        didSet {
            adjsutUIType()
        }
    }
    
    //输入长度最大限制
    public var maxLength: Int{
        didSet {
            
        }
    }
    
    //回调闭包
    func callBackFunction ( block: @escaping (_ textFiled: HoshiTextField) -> Void ) {
        blockTextFieldDidChange = block
    }
   
    //根据类型适配UI
    private func adjsutUIType() {
        switch type {
        case .common:
            
            break
        case .loginPhone:
//            textField.backgroundColor = .purple
            self.maxLength = 11
            textField.placeholderColor = UIColor.init(hexString: "#999999")
//            textField.borderActiveColor = .red
            textField.borderInactiveColor = UIColor.init(hexString: "#E5E5E5")
            textField.leftViewWithImgName(imgName: "phone", size: CGSize.init(width: 19, height: 19))
            textField.keyboardType = .numberPad
            break
        case .loginPw:
            self.maxLength = 12
            textField.leftViewWithImgName(imgName: "lock", size: CGSize.init(width: 19, height: 19))
            textField.placeholderColor = UIColor.init(hexString: "#999999")
            textField.borderInactiveColor = UIColor.init(hexString: "#E5E5E5")
            textField.isSecureTextEntry = true
            rightViewWithImgName(imgName: "eye_hide",selectedImageName: "eye", size: CGSize.init(width: 19, height: 19))
            break
        }
    }
    
    //提示语
    func placeholder(_ placeholder:String){
        textField.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        self.maxLength = 0
        self.type = .common
        super.init(frame: frame)
        
        textField = HoshiTextField.init()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholderFontScale = 1
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        //监听长度变化
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //文本变化拦截
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        let textLength = Int.init(text?.count ?? 0)
        if maxLength > 0 {
            if  textLength  > maxLength {
                textField.text = String(text?.prefix(maxLength) ??  "")
            }
        }
        if (blockTextFieldDidChange != nil) {
            blockTextFieldDidChange?(textField as! HoshiTextField)
        }
        switch type {
        case .common:
            break
        case .loginPhone:
            break
        case .loginPw:
            break
        }
    }
    
    //设置textfield rightView
    func rightViewWithImgName(imgName:String,selectedImageName:String , size:CGSize){
        let buttonV = UIButton.init(type: .custom)
        buttonV.frame = CGRect(x: 0, y: 0, width: size.width+20, height: self.frame.height)
        buttonV.setImage(UIImage.loadImage(imgName), for: .normal)
        buttonV.setImage(UIImage.loadImage(selectedImageName), for: .selected)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = buttonV
        
        buttonV.addTarget(self, action: #selector(changeValue), for: .touchUpInside)
    }
    
    @objc func changeValue(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField{
    func leftViewWithImgName(imgName:String , size:CGSize){
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: size.width+20, height: self.frame.height))
        let y  = (self.frame.height - size.height)/2;
        let imgV = UIImageView(frame: CGRect(x: 10, y: y, width: size.width, height: size.height))
        containerView.addSubview(imgV)
        self.leftViewMode = UITextField.ViewMode.always
        imgV.contentMode = UIView.ContentMode.left;
        imgV.image = UIImage.loadImage(imgName)
        self.leftView = containerView
    }
}
