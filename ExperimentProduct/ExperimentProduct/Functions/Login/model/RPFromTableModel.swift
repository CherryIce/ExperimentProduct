//
//  RPFromTableModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

enum RPFromTableType {
    case verification // label - textfiled - button
    case labelAndTextField // label - textfiled
    case textfieldAndButton //textfiled - button
    case textField//textfield
}

class RPFromTableModel: NSObject {
    //左边文字
    var title = ""
    var titleFont:UIFont = UIFont.systemFont(ofSize: 16)
    var titleColor:UIColor = .black
    //内容
    var info = ""
    //输入框文本
    var placeholder = ""
    var inputFont:UIFont = UIFont.systemFont(ofSize: 16)
    var inputColor:UIColor = .lightGray
    var alignment:NSTextAlignment = .left
    var keyboardType:UIKeyboardType = .default
    var maxLength = 20//长度限制
    
    //类型 默认验证码
    var cellClass:AnyClass = RPFromTableVerificationCell.self
    var type:RPFromTableType = .verification
    
    public convenience init(title: String?,
                            placeholder:String?,
                            cellClass:AnyClass?,
                            type: RPFromTableType = .verification) {
        self.init()
        self.title = title ?? ""
        self.placeholder = placeholder ?? ""
        if cellClass != nil {
            self.cellClass = cellClass!
        }
        self.type = type
    }
}
