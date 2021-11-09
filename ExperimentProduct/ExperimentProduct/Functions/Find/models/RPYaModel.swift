//
//  RPYaModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPYaModel: NSObject {
    //图片名字
    var image = ""
    //左边文字
    var title = ""
    var titleFont:UIFont = UIFont.systemFont(ofSize: 16)
    var titleColor:UIColor = .black
    //点击cell
    var clickAction = ""
    //点击图片
    var imgClickAction = ""
    //是否需要显示箭头
    var needArrow:Bool = false
    //右边文本
    var detail = ""
    var detailFont:UIFont = UIFont.systemFont(ofSize: 16)
    var detailColor:UIColor = .lightGray
}
