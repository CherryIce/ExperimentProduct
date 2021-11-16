//
//  RPRecivePayCodeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/16.
//

import UIKit

class RPRecivePayCodeViewController: RPBaseViewController {

    private lazy var codeV = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "收付款码"
        configuration()
    }

    func configuration()  {
        let segmentedControl = UISegmentedControl.init(items: ["付款码","收款码"])
        segmentedControl.frame = CGRect.init(x: 100, y: 20, width: SCREEN_WIDTH-200, height: 40)
        segmentedControl.tintColor = .init(hexString: "#FF7700")
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(changeIndex), for: .valueChanged)
        //没选中的字体颜色
        let normal = {[NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#666666"),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]}()
        segmentedControl.setTitleTextAttributes(normal, for: .normal)
        //选中颜色
        let selected = {[NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]}()
        segmentedControl.setTitleTextAttributes(selected, for: .selected)
        // 没选中的
        segmentedControl.setBackgroundImage(UIImage.init(color:.init(hexString: "F5F5F7")), for: .normal, barMetrics: .default)
        //选中的渐变色
        let image = UIImage.init(gradientColors: [.init(hexString: "FFB367"),.init(hexString: "FF7700")],
                                 size: CGSize.init(width: segmentedControl.frame.width/2, height: segmentedControl.frame.height-5),
                                 locations: [0.0,1.0])
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        //分割线
        segmentedControl.setDividerImage(UIImage.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.layercornerRadius(cornerRadius: 4)
        
        codeV = UIImageView.init()
        codeV.image = RPTools.creatQRCodeImage(text: "www.baidu.com", logoImage: nil)
        view.addSubview(codeV)
        codeV.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(SCREEN_WIDTH - 100)
            make.top.equalTo(segmentedControl.snp_bottom).offset(20)
        }
    }
    
    @objc func changeIndex(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            codeV.image = RPTools.creatQRCodeImage(text: "www.baidu.com", logoImage: nil)
        }else{
            codeV.image = RPTools.creatQRCodeImage(text: "www.jianshu.com", logoImage: nil)
        }
    }
}
