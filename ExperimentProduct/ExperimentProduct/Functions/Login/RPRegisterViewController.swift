//
//  RPRegisterViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/11.
//

import UIKit
import ActiveLabel

class RPRegisterViewController: RPBaseViewController {
    
    var protocolLabel:ActiveLabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if  protocolLabel == nil {
            
            protocolLabel = ActiveLabel()
            let customType = ActiveType.custom(pattern: "\\《xx用户使用协议》")
            protocolLabel?.enabledTypes = [customType]
            protocolLabel?.numberOfLines = 2
            protocolLabel?.text = "点击注册按钮，即表示您同意《xx用户使用协议》"
            protocolLabel?.font = UIFont.systemFont(ofSize: 14)
            protocolLabel?.customColor[customType] = UIColor.blue
            protocolLabel?.textColor = UIColor.black
            protocolLabel?.handleCustomTap(for: customType, handler: { (customType) in
                print("1111111")
            })
            self.view.addSubview(protocolLabel!)
            protocolLabel?.frame = CGRect.init(x: 0, y: 0, width: 182, height: 40)
            protocolLabel?.center = CGPoint.init(x: SCREEN_WIDTH * 0.5,
                                                 y: (self.view.bounds.size.height - 40 - (RPTools.IS_IPHONEX ? 34 : 0)))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
