//
//  RPMyQRCodeViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/11.
//

import UIKit

class RPMyQRCodeViewController: RPBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sexImgV: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var qrCodeImgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的QR Code"
        contentView.layercornerRadius(cornerRadius: 8)
        qrCodeImgV.image = UIImage.creatQRCode(content: "www.baidu.com",size: 200 ,tintColor: .green)
    }

}
