//
//  RPPasswordViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/11.
//

import UIKit

//修改或重置密码
public enum RPPasswordHandleType : Int {
    case add = 0 //设置密码
    case change = 1 //修改密码
}

class RPPasswordViewController: RPBaseViewController {
    
    var type = RPPasswordHandleType(rawValue: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adjsutUIType()
    }
    
    private func adjsutUIType() {
        self.navigationController?.view.hideAllToasts(includeActivity: true, clearQueue: true)
        switch type {
        case .add:
            self.navigationItem.title = "设置密码"
            self.navigationController?.view.makeToast("self.navigationItem.title = " + self.navigationItem.title!,
                                                      duration: 3.0,
                                                      position: .bottom,
                                                      style: RPTools.RPToastStyle)
            break
        case .change:
            self.navigationItem.title = "修改密码"
            self.navigationController?.view.makeToast("self.navigationItem.title = " + self.navigationItem.title!,
                                                      duration: 3.0,
                                                      position: .bottom,
                                                      style: RPTools.RPToastStyle)
            break
        case .none: break
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
