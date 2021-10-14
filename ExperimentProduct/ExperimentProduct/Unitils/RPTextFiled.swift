//
//  RPTextFiled.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/12.
//

import UIKit

public enum RPTextFiledType : Int {
    case common = 0
    case loginPhone = 1
    case right = 2
}

class RPTextFiled: UIView {
    
    var textField = HoshiTextField()
   
    func setType(_ type: RPTextFiledType) {
        switch type {
        case .common:
            
            break
        case .loginPhone:
//            textField.backgroundColor = .purple
            textField.placeholderColor = .lightGray
            textField.borderActiveColor = .red
            textField.borderInactiveColor = .orange
            textField.leftViewWithImgName(imgName: "phone", size: CGSize.init(width: 19, height: 19))
            break
        case .right:
            textField.rightViewWithImgName(imgName: "", size: CGSize.init(width: 19, height: 19))
            break
        }
    }
    
    func setPlaceholder(_ placeholder:String){
        textField.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField = HoshiTextField.init()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholderFontScale = 1
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
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
        imgV.image = UIImage.init(named: imgName)
        self.leftView = containerView
    }
    
    func rightViewWithImgName(imgName:String , size:CGSize){
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: size.width+20, height: self.frame.height))
        let y  = (self.frame.height - size.height)/2;
        let buttonV = UIButton.init(type: .custom)
        buttonV.frame = CGRect(x: 10, y: y, width: size.width, height: size.height)
        buttonV.setImage(UIImage.init(named: imgName), for: .normal)
        containerView.addSubview(buttonV)
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = containerView
    }
}
