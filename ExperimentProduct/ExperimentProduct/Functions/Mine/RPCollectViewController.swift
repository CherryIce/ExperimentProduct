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
//        gcdGroupHandle()
    }
    
    //method 1
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

    //method2
    func gcdGroupHandle () {
//        NSString *str = @"http://xxxx.com/";
//        NSURL *url = [NSURL URLWithString:str];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLSession *session = [NSURLSession sharedSession];
//
//        dispatch_group_t downloadGroup = dispatch_group_create();
//        for (int i=0; i<10; i++) {
//            dispatch_group_enter(downloadGroup);
//
//            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                NSLog(@"%d---%d",i,i);
//                dispatch_group_leave(downloadGroup);
//            }];
//            [task resume];
//        }
//
//        dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
//            NSLog(@"end");
//        });

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL.init(string: "www.baidu.com")
        let downloadGroup = DispatchGroup()
        for i in 0..<10 {
            session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                log.debug(i)
                session.finishTasksAndInvalidate()
            }).resume()
        }
        downloadGroup.notify(qos: .unspecified, flags: .inheritQoS, queue: DispatchQueue.main) {
            log.debug("gcd group end method\(2)")
        }
    }
}
