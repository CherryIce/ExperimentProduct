//
//  HBEmptyDelegate.swift
//  EmptyKit-Demo
//
//  Created by hubin on 2021/10/21.
//  Copyright © 2021 archerzz. All rights reserved.
//

import Foundation
import UIKit

public protocol HBEmptyDelegate: AnyObject {
    func customViewForEmpty() -> UIView?
}
