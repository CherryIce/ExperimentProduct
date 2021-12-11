//
//  RPDynamicProtocol.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit

enum RPDynamicViewControllerType {
    case pictures
    case video
}

enum RPDynamicViewEventType {
    case dismiss
    case share
    case commit
    case like
    case collect
    case browser
    case look
    case follow
}

protocol RPDynamicViewEventDelegate:NSObjectProtocol {
    func clickEventCallBack(_ type: RPDynamicViewEventType,_ index:Int?)
}

extension RPDynamicViewEventDelegate {func clickEventCallBack(_ type: RPDynamicViewEventType,_ index:Int?){}}

