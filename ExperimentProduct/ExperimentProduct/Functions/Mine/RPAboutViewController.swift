//
//  RPAboutViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

class RPAboutViewController: RPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "关于我们"
        
        let logoImgView = UIImageView.init()
        logoImgView.backgroundColor = RPColor.init(hexString: "#DCF6EB")
        self.view.addSubview(logoImgView)
        logoImgView.layercornerRadius(cornerRadius: 8)
        
        logoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        let versonLabel = UILabel.init()
        versonLabel.textColor = UIColor.init(hexString: "#999999")
        versonLabel.font = .systemFont(ofSize: 14)
        self.view.addSubview(versonLabel)
        
        versonLabel.text = "当前版本："+RPTools.getVersion()
        
        versonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgView.snp_bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        //custom
        let customLabel = UILabel.init()
        customLabel.textColor = UIColor.init(hexString: "#2E3135")
        customLabel.font = .systemFont(ofSize: 14)
        customLabel.numberOfLines = 0
        customLabel.textAlignment = .center
        self.view.addSubview(customLabel)
        
        customLabel.snp.makeConstraints { (make) in
            make.top.equalTo(versonLabel.snp_bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        //要显示的文字
        let str =  "关于我们可以是一段不错的产品描述，也可以是一个功能性列表放这里，主要看产品需求，这里就随便写写。 \n About us can be a good product description, or it can be a list of features put here, mainly depends on the product requirements, here just write."
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //行间距
        paraph.lineSpacing = 15
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.paragraphStyle: paraph]
        customLabel.attributedText = NSAttributedString(string: str, attributes: attributes)
        
        let bottomLabel = UILabel.init()
        bottomLabel.textColor = UIColor.init(hexString: "#2E3135")
        bottomLabel.font = .systemFont(ofSize: 14)
        self.view.addSubview(bottomLabel)
        
        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        bottomLabel.text = "Copyright 🐰🐇 @2021"
    }

}
