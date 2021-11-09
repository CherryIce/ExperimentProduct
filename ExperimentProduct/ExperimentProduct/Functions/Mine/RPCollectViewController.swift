//
//  RPCollectViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/9.
//

import UIKit

class RPCollectViewController: RPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug(1)
        requestHandle()
    }
    
    func requestHandle() {
        let queue = OperationQueue.init()
        let op1 = BlockOperation.init {
            self.requestTitleDatas()
        }
        let op2 = BlockOperation.init {
            self.requestData()
        }
        op2.addDependency(op1)
        queue.addOperations([op1,op2], waitUntilFinished: false)
    }
    
    func requestTitleDatas()  {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            sema.signal()
            log.debug(2)
        }
        sema.wait()
    }
    
    func requestData()  {
        log.debug(3)
    }

}
