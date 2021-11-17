//
//  RPRecivePayCodeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/16.
//

import UIKit

class RPRecivePayCodeViewController: RPBaseViewController {

    private lazy var barCodeV = UIImageView()
    private lazy var qrCodeV = UIImageView()
    let width = SCREEN_WIDTH - 100
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "收付款码"
        configuration()
    }

    func configuration()  {
        let scrollView = UIScrollView.init()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:SCREEN_HEIGHT-RPTools.NAV_HEIGHT)
        
        let segmentedControl = UISegmentedControl.init(items: ["付款码","收款码"])
        segmentedControl.frame = CGRect.init(x: 100, y: 20, width: SCREEN_WIDTH-200, height: 40)
        segmentedControl.tintColor = .init(hexString: "#FF7700")
        segmentedControl.selectedSegmentIndex = 0
        scrollView.addSubview(segmentedControl)
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
        let image = UIImage.init(gradientColors: [.init(hexString: "FFB367"),RPColor.redWine],
                                 size: CGSize.init(width: segmentedControl.frame.width/2, height: segmentedControl.frame.height-5),
                                 locations: [0.0,1.0])
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        //分割线
        segmentedControl.setDividerImage(UIImage.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        segmentedControl.layercornerRadius(cornerRadius: 4)
        segmentedControl.layer.cornerRadius = 4
        segmentedControl.clipsToBounds = true
        
        barCodeV = UIImageView.init()
        scrollView.addSubview(barCodeV)
        barCodeV.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp_bottom).offset(20)
            make.width.equalTo(width)
            make.height.equalTo(width/2)
            make.centerX.equalToSuperview()
        }
        barCodeV.image = UIImage.createCode128(codeString: "www.baidu.com", size: CGSize(width: width, height: width/2), qrColor: RPColor.redWine, bkColor: .clear)
        
        qrCodeV = UIImageView.init()
        qrCodeV.image = UIImage.creatQRCode(content: "www.baidu.com", logo: nil, logoFrame: .zero, size: width, highCorrection: true, tintColor: RPColor.redWine)
        scrollView.addSubview(qrCodeV)
        qrCodeV.snp.makeConstraints { make in
            make.width.height.equalTo(width)
            make.top.equalTo(barCodeV.snp_bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func changeIndex(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            barCodeV.image = UIImage.createCode128(codeString: "www.baidu.com", size: CGSize(width: width, height: width/2), qrColor: RPColor.redWine, bkColor: .white)
            qrCodeV.image = UIImage.creatQRCode(content: "www.baidu.com",size: width,tintColor: RPColor.redWine)
        }else{
            barCodeV.image = UIImage.createCode128(codeString: "www.jianshu.com", size: CGSize(width: width, height: width/2), qrColor: RPColor.redWine, bkColor: .white)
            qrCodeV.image = UIImage.creatQRCode(content: "www.jianshu.com",size: width,tintColor: RPColor.redWine)
        }
    }
}
