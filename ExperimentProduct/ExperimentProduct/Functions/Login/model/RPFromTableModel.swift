//
//  RPFromTableModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

enum RPFromTableType {
    case verification // label - textfiled - button
    case inputMid // label - textfiled - left
    case inputRight // label - textfild - right
}

class RPFromTableModel: NSObject {
    //左边文字
    var title = ""
    var titleFont:UIFont = UIFont.systemFont(ofSize: 16)
    var titleColor:UIColor = .black
    //内容
    var info = ""
    //输入框文本
    var textfiledPlaceholder = ""
    var textfiledFont:UIFont = UIFont.systemFont(ofSize: 16)
    var textfiledColor:UIColor = .lightGray
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
        self.textfiledPlaceholder = placeholder ?? ""
        if cellClass != nil {
            self.cellClass = cellClass!
        }
        self.type = type
    }
}
