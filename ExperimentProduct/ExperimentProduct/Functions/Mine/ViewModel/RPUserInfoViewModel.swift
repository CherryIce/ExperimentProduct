//
//  RPUserInfoViewModel.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/18.
//

import UIKit
import RxSwift
import RxCocoa

class RPUserInfoViewModel: NSObject {
    
    //input
    private var offset = Variable("")

    func transform(input: (Variable<String>), dependecies: (RPNetWorkManager)) -> Driver<[SettingSection]> {
        self.offset = input
        return offset.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(dependecies.getNews)
            .asDriver(onErrorJustReturn: [])
    }

}


