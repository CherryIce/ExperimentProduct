//
//  RPFindViewController.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/9/17.
//

import UIKit

class RPFindViewController: RPBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let num =  arc4random() % 20
        if num % 2 == 0 {
            self.tabBarItem.badgeValue = "\(num)"
        }else {
            self.tabBarItem.badgeValue = nil
        }
    }
    
}
